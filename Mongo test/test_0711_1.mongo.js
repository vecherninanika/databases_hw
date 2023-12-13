use('sirius')

db.customer.drop()
db.order.drop()

db.createCollection('order', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            properties: {
                _id: {
                    bsonType: 'number'
                },
                date: {
                    bsonType: 'date'
                },
                sum: {
                    bsonType: 'number'
                },
            },
        },
    }
})

db.createCollection("customer", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            properties: {
                _id: {
                    bsonType: 'number'
                },
                name: {
                    bsonType: "string"
                },
                surname: {
                    bsonType: "string"
                },
                phone: {
                    bsonType: "string"
                },
                orders: {
                    bsonType: "array",
                    items: {
                        bsonType: "number"
                    }
                }
            }
        }
    }
})

db.customer.insertMany([
    { _id: 1, name: "Alexandr", surname: "Aleksandrov", phone: '+79035441011', orders: [2] },
    { _id: 2, name: "Vasiliy", surname: "Vasilyev", phone: '+79035441012', orders: [4] },
    { _id: 3, name: "Ivan", surname: "Ivanov", phone: '+79035441012', orders: [1, 3] }
])


db.order.insertMany([
    { _id: 1, date: new Date("1212.12.12"), sum: 350 },
    { _id: 2, date: new Date("1212.12.12"), sum: 1150 },
    { _id: 3, date: new Date("1212.12.12"), sum: 1250 },
    { _id: 4, date: new Date("1212.12.12"), sum: 125 }
])


db.customer.aggregate([{
    $lookup: {
        from: "order",
        localField: "orders",
        foreignField: "_id",
        as: "orders"
    }
}])


db.order.aggregate([{
    $lookup: {
        from: "customer",
        localField: "_id",
        foreignField: "orders",
        as: "customers"
    }
}])
