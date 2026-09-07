<?php
require 'config.php';

header('Content-Type: application/json');

if ($db->connect_error) {
    echo json_encode(['error' => 'db fail']);
    exit;
}

function reply($data)
{
    echo json_encode($data);
    exit;
}

$input  = json_decode(file_get_contents('php://input'), true) ?? [];
$action = $input['action'] ?? $_GET['action'] ?? '';

switch ($action) {

    case 'menu':
        $result = $db->query("SELECT id, name, description AS `desc`, price,
                                     category, qty, is_available AS isAvailable,
                                     icon
                              FROM menu_items");

        $menuItems = $result->fetch_all(MYSQLI_ASSOC);
        reply($menuItems);
        break;

    case 'sales':
        $result = $db->query("SELECT id, order_code, created AS date,
                                     order_type AS type,
                                     total
                              FROM orders
                              ORDER BY id DESC");

        $orders = $result->fetch_all(MYSQLI_ASSOC);

        foreach ($orders as &$order) {
            $orderId = $order['id'];

            $itemsResult = $db->query("SELECT item_name AS name, qty, price
                                       FROM order_items
                                       WHERE order_id = $orderId");

            $order['items'] = $itemsResult->fetch_all(MYSQLI_ASSOC);
        }

        reply($orders);
        break;

    case 'signup':
        $username = trim($input['username'] ?? '');
        $email    = trim($input['email']    ?? '');

        $check = $db->prepare("SELECT username FROM users WHERE username=? OR email=?");
        $check->bind_param('ss', $username, $email);
        $check->execute();
        $existing = $check->get_result()->fetch_assoc();

        if ($existing) {
            reply(['error' => 'Username or Email already exists']);
        }

        $hashedPassword = password_hash($input['password'] ?? '', PASSWORD_DEFAULT);

        $stmt = $db->prepare("INSERT INTO users (email, username, password, role)
                              VALUES (?, ?, ?, 'student')");
        $stmt->bind_param('sss', $email, $username, $hashedPassword);
        $stmt->execute();

        reply(['ok' => true, 'role' => 'student']);
        break;

    case 'login':
        $stmt = $db->prepare("SELECT username, password, role FROM users WHERE username=?");
        $stmt->bind_param('s', $input['username']);
        $stmt->execute();
        $user = $stmt->get_result()->fetch_assoc();

        if (!$user || !password_verify($input['password'] ?? '', $user['password'])) {
            reply(['error' => 'Incorrect username or password']);
        }

        reply([
            'ok'       => true,
            'role'     => $user['role'],
            'username' => $user['username']
        ]);
        break;

    case 'save_item':
        $item = $input['item'];

        if (!empty($item['id'])) {
            $stmt = $db->prepare("UPDATE menu_items
                                  SET name=?, description=?, price=?, category=?,
                                      qty=?, is_available=?
                                  WHERE id=?");
            $stmt->bind_param('ssisiii',
                $item['name'],
                $item['desc'],
                $item['price'],
                $item['category'],
                $item['qty'],
                $item['isAvailable'],
                $item['id']
            );

        } else {
            $icon = $item['icon'] ?? '';

            $stmt = $db->prepare("INSERT INTO menu_items
                                  (name, description, price, category, qty, is_available, icon)
                                  VALUES (?, ?, ?, ?, ?, ?, ?)");
            $stmt->bind_param('ssissis',
                $item['name'],
                $item['desc'],
                $item['price'],
                $item['category'],
                $item['qty'],
                $item['isAvailable'],
                $icon
            );
        }

        $stmt->execute();
        reply(['ok' => true]);
        break;

    case 'record_sale':
        $order = $input['order'];
        $orderCode = 'ORD-' . time();

        $stmt = $db->prepare("INSERT INTO orders (order_code, order_type, table_num, total)
                              VALUES (?, 'Open Order', 0, ?)");
        $stmt->bind_param('si',
            $orderCode,
            $order['total']
        );
        $stmt->execute();

        $orderId = $db->insert_id;

        foreach ($order['items'] as $item) {
            $itemStmt = $db->prepare("INSERT INTO order_items (order_id, item_name, qty, price)
                                      VALUES (?, ?, ?, ?)");
            $itemStmt->bind_param('isii',
                $orderId,
                $item['name'],
                $item['qty'],
                $item['price']
            );
            $itemStmt->execute();

            $safeName = $db->real_escape_string($item['name']);
            $qty = (int) $item['qty'];

            $db->query("UPDATE menu_items
                        SET qty = GREATEST(0, qty - $qty),
                            is_available = IF(qty > $qty, 1, 0)
                        WHERE name = '$safeName'");
        }

        reply(['ok' => true]);
        break;

    default:
        reply(['error' => 'invalid action']);
        break;
}
