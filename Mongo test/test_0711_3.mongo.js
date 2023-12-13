use('sirius')

db.task.drop()
db.person.drop()

db.createCollection('task', {
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
                status: {
                    bsonType: 'string'
                }
            }
        }
    }
})

db.createCollection('person', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            properties: {
                _id: {
                    bsonType: 'number'
                },
                name: {
                    bsonType: 'string'
                },
                surname: {
                    bsonType: 'string'
                },
                post: {
                    bsonType: 'string'
                },
                tasks: {
                    bsonType: 'array',
                    items: {
                        bsonType: 'number'
                    }
                }
            }
        }
    }
})


db.task.insertMany([
    { _id: 1, title: "First task", status: "finished" },
    { _id: 2, title: "Second task", status: "not started" },
    { _id: 3, title: "Third task", status: "in progress" },
    { _id: 4, title: "Forth task", status: "in progress" }
])

db.person.insertMany([
    { _id: 1, name: "Alexandr", surname: "Aleksandrov", post: 'teacher', orders: [2, 4] },
    { _id: 2, name: "Vasiliy", surname: "Vasilyev", post: 'student', orders: [1, 4] },
    { _id: 3, name: "Ivan", surname: "Ivanov", post: 'manager', orders: [1, 3] }
])


db.person.aggregate([{
    $lookup: {
        from: "task",
        localField: "tasks",
        foreignField: "_id",
        as: "tasks"
    }
}])



db.task.aggregate([{
    $lookup: {
        from: "person",
        localField: "_id",
        foreignField: "tasks",
        as: "persons"
    }
}])

