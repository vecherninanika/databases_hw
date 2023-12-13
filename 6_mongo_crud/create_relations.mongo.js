use ('sirius')

db.createCollection('task', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            properties: {
                _id: {
                    bsonType: 'number'
                },
                task: {
                    bsonType: 'string'
                },
                difficulty: {
                    bsonType: 'string'
                },
                answer: {
                    bsonType: 'string'
                },
                topic_id: {
                    bsonType: 'number'
                }
            },
            additionalProperties: false,
            required: ['task', 'answer', 'topic_id']
        }
    }
})

db.createCollection('topic', {
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
                studentsbook: {
                    bsonType: 'string'
                }
            },
            additionalProperties: false,
            required: ['title']
        }
    }
})

db.task.insertMany([
    {_id: 1, task: 'Area of circle', difficulty: 'Easy', answer: '', topic_id: 1},
    {_id: 2, task: 'Sum of three numbers', difficulty: 'Easy', answer: '', topic_id: 2},
    {_id: 3, task: 'Probability of passing the exam', difficulty: 'Hard', answer: '', topic_id: 1},
])

db.topic.insertMany([
    {_id: 1, title: 'Geometry', studentsbook: 'Baranov geometry'},
    {_id: 2, title: 'Arithmetics', studentsbook: 'Ivanov - Easy counting'}
])


db.topic.aggregate([
    {
        $lookup: {
            from: 'task',
            localField: '_id',
            foreignField: 'topic_id',
            as: 'tasks'
        }
    }
])
