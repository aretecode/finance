[![Build Status](https://travis-ci.org/aretecode/finance.svg)](https://travis-ci.org/aretecode/finance)

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)


# Wondering
* [x] default wiring for Components connect & disconnect? (@see component/Validate)
* [x] how to test components that do database transactions? (@see spec/)

^ both of these were caused thanks to inheriting an auto disconnect when prev process disconnected.

* [x] why the first test will timeout, and why they will all timeout sometimes? (Have to use a stupidly high [10 sec] timeout when testing... this was fickle.)
* [ ] how to send array to inPort.pattern in xpress/Router using FlowHub
* [ ] Why does https://github.com/noflo/noflo-xpress/blob/master/lib/BaseRouter.coffee not list `HEAD` and `PATCH` as valid verbs?
* [ ] Where to do HTTP req, set up Routing Server in FlowHub?
* [ ] Why the pool gets destroyed when including the connection now?
* [ ] How to pass data on with no inPort?

# New:
* [x] rename FinanceOperation to FinanceOp
* [x] put database init/cleanup functions called in beforeAll/afterAll
* [x] merge Expense & Income entities (finance_op)
* [x] rewrite main queries for finance_op
* [x] change string id to uuid type (then to char(36))
* [x] add (done()) to tests
* [x] parse in JSON
* [ ] parse JSON body only on certain routes
* [x] simplify tests
* [x] simplify entities
* [x] move away from OOD & OOP (looking @ you src/)
* [ ] write a better SUM query for balancetrend
* [x] make it work on FlowHub
* [x] recreate FBP graphs as subgraphs in FlowHub
* [ ] recreate *all* FBP graphs
* [ ] example of all working in FlowHub
* [x] make it work in FlowHub
* [x] make it *all* work in FlowHub
* [ ] rename `name` as `type`
* [ ] could pass all down one pipeline, no res port
* [ ] Response could be one in port, pass in data about which

# @TODO:
* [x] Validate
* [x] Validate.update (optional params)
* [x] use WirePattern
* [x] use WirePattern more in depth
* [x] use Group
* [x] use FloHub
* [ ] use FloHub more in depth
* [x] fix this Test inconsistency (sometimes has a timeout, usually on first test?)
* [x] pass the `req` down a side port to the Response
* [x] update all properties
* [x] PATCH to PUT unless I extend lib/BaseRouter
* [x] fix PUT to POST
* [x] .fbp into .json
* [x] import .json into flowhub via github (using https://github.com/noflo/noflo-browser-app)
* [x] add .json to github via flowhub
* [x] Test methods of the src/ (FinanceOperation, Tag)
* [ ] improve code clarity in FetchWithMonthYear
* [x] add Income
* [x] add Balance Reports
* [ ] download flowhub graphs and run them in noflo
* [ ] convert raw queries to knexjs
* [x] change test order so it doesn't have to be run three times

# After
* [ ] pass in connection to an inPort (@see components/Database)
* [x] Test with HTTP
* [x] update tags
* [ ] add Morgan as Middleware to log
* [ ] send things after tags are all saved (@see components/Store)
* [ ] improve query to save if not exists (use Raw) (@see components/Store)
* [x] Filter null instead of returning in the map in FetchList
* [ ] TODOS in non noflo `personal-finance-tracker`
* [x] add Travis
* [x] use Travis
* [x] Travis badge
* [ ] use Groups to send the data to Response
* [ ] Test using noflo-tester using .fbp
* [ ] Test in FlowHub (http Component?)
* [x] call Super insteadof childConstructor
* [ ] rename CRUD component to better represent it as the router connection
* [x] remove unnessecary port events

# Future
* [x] Change update to use query insteadof params for updating individual parts (actually, body insteadof params&query)
* [ ] add rollback & undo feature to the commit
* [ ] filter XSS in the description
* [x] static (or something) optional Error port sender
* [ ] Validate could be a filter insteadof a Component ***
* [ ] transform Data before going to Validator? in Create or _
* [ ] add chaining constructor to src/Factory
* [ ] Test the AuthMiddlewareComponent
* [ ] Test the DeleteComponent
* [ ] could change CRUD to take inPort of the action and not need named Components
* [x] work with BlueBird Promises
* [ ] work with BlueBird more in depth
* [ ] validate range in BalanceTrend
* [ ] write documentation?
* [ ] port for each Validate param?
* [ ] multiple responses in components/Response not just failure success(pass)

# NoFlo extension
* [ ] dig into the noflo source code & compare how it translates from PHP & if any of my extensions are applicable
* [x] ^ did a microextension (addOn)
* [ ] add SendThenDisconnect()

# Other
* [ ] rename `successful` to `success`

* A lot was learned & used from https://github.com/noflo/noflo-xpress
