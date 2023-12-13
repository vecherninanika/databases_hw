use('sirius')

db.repository.drop()
db.ticket.drop()


db.createCollection('ticket', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            properties: {
                _id: {
                    bsonType: 'number'
                },
                title: {
                    bsonType: 'string'
                },
                description: {
                    bsonType: 'string'
                },
                status: {
                    bsonType: 'string'
                },
            },
        },
    }
})

db.createCollection("repository", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            properties: {
                _id: {
                    bsonType: 'number'
                },
                title: {
                    bsonType: "string"
                },
                description: {
                    bsonType: "string"
                },
                stars_qty: {
                    bsonType: "number"
                },
                tickets: {
                    bsonType: "array",
                    items: {
                        bsonType: "number"
                    }
                }
            }
        }
    }
})

db.repository.insertMany([
    { _id: 1, title: "Rep1", description: "First repository", stars_qty: 5, tickets: [2] },
    { _id: 2, title: "Rep2", description: "Second repository", stars_qty: 4, tickets: [4] },
    { _id: 3, title: "Rep3", description: "Third repository", stars_qty: 9, tickets: [1, 3] }
])


db.ticket.insertMany([
    { _id: 1, title: 'Ticket1', description: '350', status: 'Done'},
    { _id: 2, title: 'Ticket2', description: '1150', status: 'In prograss' },
    { _id: 3, title: 'Ticket3', description: '1250', status: 'Done' },
    { _id: 4, title: 'Ticket4', description: '125', status: 'In prograss' }
])


db.repository.aggregate([{
    $lookup: {
        from: "ticket",
        localField: "tickets",
        foreignField: "_id",
        as: "tickets"
    }
}])


db.ticket.aggregate([{
    $lookup: {
        from: "repository",
        localField: "_id",
        foreignField: "tickets",
        as: "repositories"
    }
}])
