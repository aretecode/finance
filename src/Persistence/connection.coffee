conn =
  host: process.env.DATABASE_HOST
  user: process.env.DATABASE_USER
  password: process.env.DATABASE_PASSWORD
  database: process.env.DATABASE_NAME
  charset: 'utf8'

pg = require('knex')(client: 'pg', connection: conn, debug: true)
module.exports.getPg = -> return pg
