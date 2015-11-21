chai = require 'chai'

createFinancialOperation = (pg, name) ->
  pg.schema.createTableIfNotExists name, (table) ->
    ### @TODO: should change to uuid ###
    table.string('id').primary()
    table.string('currency').notNullable()
    table.integer('amount').notNullable()
    table.timestamp('created_at') # .defaultTo(pg.fn.now())
    table.string('description').nullable().defaultTo(null)
  .then (what) ->
    console.log "created"

createTags = (pg) ->
  pg.schema.createTableIfNotExists 'tags', (table) ->
    ### @TODO: should change to uuid ###
    table.string('id')
    table.string('tag').notNullable()
    table.primary(['id', 'tag'])
  .then (what) ->
    console.log "created tags"

describe 'Creating & validating Database Tables', ->
  conn =
    host: process.env.DATABASE_HOST
    user: process.env.DATABASE_USER
    password: process.env.DATABASE_PASSWORD
    database: process.env.DATABASE_NAME
    charset: 'utf8'
  pg = require('knex')({client: 'pg', connection: conn, debug: false})

  it 'should create income', ->
    pg.schema.hasTable('income').then (exists) ->
      createFinancialOperation(pg, 'income') if not exists

  it 'should create expense', ->
    pg.schema.hasTable('expense').then (exists) ->
      createFinancialOperation(pg, 'expense') if not exists

  it 'should create tags', ->
    pg.schema.hasTable('tags').then (exists) ->
      createTags(pg) if not exists

  it 'should have tables in the postgres', ->
    pg.schema.hasTable('tags').then (exists) ->
      chai.expect(exists).to.equal(true)
    pg.schema.hasTable('income').then (exists) ->
      chai.expect(exists).to.equal(true)
    pg.schema.hasTable('expense').then (exists) ->
      chai.expect(exists).to.equal(true)