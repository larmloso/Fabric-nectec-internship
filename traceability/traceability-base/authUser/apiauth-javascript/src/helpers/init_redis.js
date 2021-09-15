require('dotenv').config({
  path: `${__dirname}/../.env`
})
const redis = require('redis')
const DOMAIN = process.env.DOMAIN || '127.0.0.1';
const client = redis.createClient(
  6379, DOMAIN
)

client.on('connect', () => {
  console.log('Client connected to redis...')
})

client.on('ready', () => {
  console.log('Client connected to redis and ready to use...')
})

client.on('error', (err) => {
  console.log(err.message)
})

client.on('end', () => {
  console.log('Client disconnected from redis')
})

process.on('SIGINT', () => {
  client.quit()
})

module.exports = client