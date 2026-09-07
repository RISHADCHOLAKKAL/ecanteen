SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE TABLE `menu_items` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` varchar(255) DEFAULT '',
  `price` int(11) NOT NULL DEFAULT 0,
  `category` enum('food','beverage','snacks') NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `is_available` tinyint(1) NOT NULL DEFAULT 1,
  `icon` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `menu_items` (`id`, `name`, `description`, `price`, `category`, `qty`, `is_available`, `icon`) VALUES
(1, 'Traditional Kanji', 'Served hot with green gram & pickle', 40, 'food', 75, 1, 'M12 2C8.14 2 5 5.14 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.86-3.14-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z'),
(2, 'Special Meal Thali', 'Rice, Sambar, Aviyal, Thoran & Curd', 80, 'food', 0, 0, 'M11 9H9V2H7v7H5V2H3v7c0 2.12 1.46 3.9 3.45 4.35V22h2.1v-8.65C10.54 12.9 12 11.12 12 9V2h-1v7zm8-7h-2c-1.1 0-2 .9-2 2v6c0 1.66 1.34 3 3 3v8h2V2z'),
(3, 'Special Masala Tea', 'Brewed with fresh ginger & cardamom', 15, 'beverage', 24, 1, 'M20 3H4v10c0 2.21 1.79 4 4 4h6c2.21 0 4-1.79 4-4v-3h2c1.11 0 2-.89 2-2V5c0-1.11-.89-2-2-2zm0 5h-2V5h2v3zM4 19h16v2H4z'),
(4, 'Fresh Lime Juice', 'Chilled refreshing mint lime', 25, 'beverage', 10, 1, 'M12 2c-5.52 0-10 4.48-10 10s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z'),
(5, 'Pazham Pori', 'Crispy banana fritters', 20, 'snacks', 0, 0, 'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z'),
(6, 'Samosa', 'Spiced potato filling', 20, 'snacks', 0, 0, 'M12 2l-5.5 9h11zM12 22l5.5-9h-11z'),
(7, 'usman pacha', 'nalla pacha', 60, 'beverage', 59, 1, 'M11 9H9V2H7v7H5V2H3v7c0 2.12 1.46 3.9 3.45 4.35V22h2.1v-8.65C10.54 12.9 12 11.12 12 9V2h-1v7zm8-7h-2c-1.1 0-2 .9-2 2v6c0 1.66 1.34 3 3 3v8h2V2z');

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `order_code` varchar(20) NOT NULL,
  `order_type` varchar(50) NOT NULL,
  `table_num` int(11) DEFAULT NULL,
  `total` int(11) NOT NULL DEFAULT 0,
  `created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `orders` (`id`, `order_code`, `order_type`, `table_num`, `total`, `created`) VALUES
(1, 'ORD-1787320825', 'Open Order', NULL, 800, '2026-08-21 14:00:25'),
(2, 'ORD-1787320831', 'Open Order', NULL, 160, '2026-08-21 14:00:31'),
(3, 'ORD-1787320898', 'Open Order', NULL, 240, '2026-08-21 14:01:38'),
(4, 'ORD-1787322189', 'Open Order', NULL, 280, '2026-08-21 14:23:09'),
(5, 'ORD-1787322202', 'Open Order', NULL, 400, '2026-08-21 14:23:22'),
(6, 'ORD-1787322517', 'Open Order', NULL, 15, '2026-08-21 14:28:37'),
(7, 'ORD-1787545803', 'Open Order', NULL, 60, '2026-08-24 04:30:03'),
(8, 'ORD-1787546792', 'Open Order', NULL, 80, '2026-08-24 04:46:32');

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `item_name` varchar(150) NOT NULL,
  `qty` int(11) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `order_items` (`id`, `order_id`, `item_name`, `qty`, `price`) VALUES
(1, 1, 'Traditional Kanji', 20, 40),
(2, 2, 'Special Meal Thali', 2, 80),
(3, 3, 'Samosa', 12, 20),
(4, 4, 'Traditional Kanji', 5, 40),
(5, 4, 'Special Meal Thali', 1, 80),
(6, 5, 'Special Meal Thali', 5, 80),
(7, 6, 'Special Masala Tea', 1, 15),
(8, 7, 'usman pacha', 1, 60),
(9, 8, 'Special Meal Thali', 1, 80);

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('student','admin') DEFAULT 'student',
  `created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `users` (`id`, `email`, `username`, `password`, `role`, `created`) VALUES
(3, 'diyaf848@gmail.com', 'hello', '$2y$10$YR3h5phEkZFJ9Pd49uL4CuCK8Vd3K6Gh734juSOBYiLpPLTmovXBC', 'student', '2026-08-24 04:29:29'),
(4, 'admin@ecanteen.com', 'admin', '$2y$10$KC/D3h67.R6v0xwpttINY.O5F7ZxggdUK9OpbDbhSe2rL/EpY5Seq', 'admin', '2026-08-24 04:39:36');

ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`);

ALTER TABLE `menu_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
