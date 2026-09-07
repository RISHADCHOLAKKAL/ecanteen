var API = 'api.php';

function getMenuItems(callback) {
    fetch(API + '?action=menu')
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            callback(data);
        });
}

function saveMenuItem(item, callback) {
    fetch(API, {
        method: 'POST',
        body: JSON.stringify({ action: 'save_item', item: item })
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        callback(data);
    });
}

function getSalesHistory(callback) {
    fetch(API + '?action=sales')
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            callback(data);
        });
}

function recordSale(order, callback) {
    fetch(API, {
        method: 'POST',
        body: JSON.stringify({ action: 'record_sale', order: order })
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        callback(data);
    });
}
