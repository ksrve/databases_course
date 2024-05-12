db = db.getSiblingDB('db');

db.createCollection('Orders');
db.createCollection('Clients');
db.createCollection('Restaurant');

try {
    db.Restaurant.insertMany([
    {
        "_id": ObjectId("66411ca50a42c236002202d8"),
        "name": "Отличная курочка",
        "phone": "5444485",
        "email": "hen@mail.ru",
        "founding_day": "30.04.2014",
        "address": "……"
    }  
    ]);

    db.Clients.insertMany([
        {
            "_id": ObjectId("66411d5bbe756ac35f2202d8"),
            "name": "Иванова Инна Ивановна",
            "phone": "5824585",
            "email": "iii@mail.ru",
            "birthday": "30.04.2014",
            "login": "iii",
            "address": {
                "update_time": "30.04.2024 15:22:55"
            }
        }  
    ]);

    db.Orders.insertMany([
        {
            "_id": ObjectId('66411d5bbe756ac35f2202d9'),
            "restaurant_id": ObjectId("66411ca50a42c236002202d8"),
            "client_id": ObjectId("66411d5bbe756ac35f2202d8"),
            "order_items": [
                ObjectId(),
                ObjectId(),
                ObjectId()
            ],
            "total_bonus": 579,
            "cost": 1760,
            "payment": 1760,
            "bonus_for_visit": 60,
            "statuses": [
                {
                    "status": "finished",
                    "time": "2024-03-29 10:25:18"
                },
                {
                    "status": "delivering",
                    "time": "2024-03-29 09:28:14"
                },
                {
                    "status": "prepairyng",
                    "time": "2024-03-29 08:51:12"
                },
                {
                    "status": "new",
                    "time": "2024-03-29 08:21:53"
                }
            ],
            "final_status": "finished",
            "update_time": "2024-03-29T10:25:18.572+00:00"
        }  
    ]);

} catch (e) {
    print (e);
}