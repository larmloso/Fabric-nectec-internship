const redis = require('redis')
require('dotenv').config()

const DOMAINS = process.env.domain
const client  = redis.createClient(
6379, DOMAINS
)
console.log(DOMAINS);


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