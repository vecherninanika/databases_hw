import express from 'express'
import bodyParser from 'body-parser'
import { MongoClient, ObjectId } from 'mongodb'
import { config } from 'dotenv'

config()

const { MONGO_USER, MONGO_PASSWORD, MONGO_HOST, MONGO_PORT, MONGO_DB, EXPRESS_PORT } = process.env

const client = new MongoClient(`mongodb://${MONGO_USER}:${MONGO_PASSWORD}@${MONGO_HOST}:${MONGO_PORT}`)
const db = client.db(MONGO_DB)

const app = express()
app.use(bodyParser.json())
const appPort = EXPRESS_PORT

app.get('/', (_, res) => {
    res.send('Main page')
}) 

app.get('/tasks', async (_, res) => {
    try {
        const tasks = await db
            .collection('task')
            .find({}, { limit: 10, sort: { _id: -1 } })
            .toArray()


        res.json(tasks)
    }
    catch(err) {
        console.log(err)
        res.sendStatus(400)
    }
})

app.post('/tasks/create', async (req, res) => {
    try {
        const { task, difficulty, answer, topic_id } = req.body
        console.log({ task, difficulty, answer, topic_id })
        const { insertedId } = await db
            .collection('task')
            .insertOne({ task, difficulty, answer, topic_id })
        res.json({ id: insertedId })
    } catch(err) {
        console.log(err)
        res.sendStatus(400)
    }
})

app.post('/tasks/update', async (req, res) => {
    try {
        const { id, task, difficulty, answer, topic_id } = req.body
        const result = await db
            .collection('task')
            .updateOne(
                { _id: new ObjectId(id) },
                { $set: { task, difficulty, answer, topic_id }}
            )
        if (result.matchedCount === 0 ) {
            console.log('0 results by this filter')
            res.sendStatus(404)
        } else {
            res.sendStatus(204)
        }
    } catch(err) {
        console.log(err)
        res.sendStatus(400)
    }
})


app.delete('/tasks/delete', async (req, res) => {
    try {
        const { id } = req.body
        const { deletedCount } = await db.collection('tasks').deleteOne({ _id: new ObjectId(id) })
        if ( deletedCount === 0 ) {
            console.log('0 results by this filter')
            res.sendStatus(404)
        } else {
            res.sendStatus(204)
        }
    } catch(err) {
        console.log(err)
        res.sendStatus(400)
    }
})

app.listen(appPort, () => {
    console.log(`app listening on port ${appPort}`)
})
