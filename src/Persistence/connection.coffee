conn =
  host: process.env.DATABASE_HOST
  user: process.env.DATABASE_USER
  password: process.env.DATABASE_PASSWORD
  database: process.env.DATABASE_NAME
  charset: 'utf8'
  port: 5432

pool =
  min: 2
  max: 20

pg = require('knex')(client: 'pg', connection: conn, pool, debug: false)
module.exports.getPg = -> return pg


