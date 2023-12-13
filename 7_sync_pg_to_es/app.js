import express from 'express'
import bodyParser from 'body-parser'
import { Client } from '@elastic/elasticsearch'

const client = new Client({
    node: 'http://localhost:41554'
})

const app = express()
app.use(bodyParser.json())
const appPort = 3000

app.get('/', (_, res) => {
    res.send('Main page')
})


app.get('/fuzzy_matching', async (req, res) => {
    try {
        const text = req.query['text']
        const result = await client.search({
            index: 'task',
            query: {
                match: {
                    task: {
                        query: text,
                        fuzziness: 1,
                        minimum_should_match: 2
                    }
                }
            }
        })

        res.json(result.hits.hits)
    } catch (err) {
        console.log(err)
        res.sendStatus(400)
    }
})


app.get('/part_of_word', async (req, res) => {
    try {
        const text = req.query['text']

        const result = await client.search({
            index: 'task',
            query: {
                match: {
                    title: {
                        query: "тетрадей"
                    }
                }
            }
        
        })

        res.json(result.hits.hits)
    } catch (err) {
        console.log(err)
        res.sendStatus(400)
    }
})


app.get('/synonims', async (req, res) => {
    try {
        const text = req.query['text']

        const result = await client.search({
            index: 'person',
            query: {
                match: {
                    personal_info: {
                        query: text
                    }
                }
            }
        })

        res.json(result.hits.hits)
    } catch (err) {
        console.log(err)
        res.sendStatus(400)
    }
})


app.listen(appPort, () => {
    console.log(`app listening on port ${appPort}`)
})
