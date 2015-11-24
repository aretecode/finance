# Wondering
* [x] default wiring for Components connect & disconnect? (@see component/Validate)
* [x] how to test components that do database transactions? (@see spec/)

^ both of these were caused thanks to inheriting an auto disconnect when prev process disconnected.

* [x] why the first test will timeout, and why they will all timeout sometimes? (Have to use a stupidly high [10 sec] timeout when testing... this was fickle.)
* [ ] how to send array to inPort.pattern in xpress/Router using FlowHub
* [ ] Why does https://github.com/noflo/noflo-xpress/blob/master/lib/BaseRouter.coffee not list `HEAD` and `PATCH` as valid verbs?

# @TODO:
* [x] Validate
* [x] Validate.update (optional params)
* [x] use WirePattern
* [ ] use WirePattern more in depth 
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
* [ ] Test methods of the src/ (FinanceOperation, Tag)
* [ ] improve code clarity in FetchWithMonthYear
* [x] add Income
* [x] add Balance Reports
* [ ] download flowhub graphs and run them in noflo
* [ ] convert raw queries to knexjs

# After 
* [ ] pass in connection to an inPort (@see components/Database)
* [x] Test with HTTP
* [ ] List Test could load the list from the db and compare each result
* [ ] update tags
* [ ] add Morgan as Middleware to log 
* [ ] send things after tags are all saved (@see components/Store)
* [ ] improve query to save if not exists (use Raw) (@see components/Store)
* [x] Filter null instead of returning in the map in FetchList
* [ ] TODOS in non noflo `personal-finance-tracker`
* [x] add Travis
* [ ] use Travis
* [ ] use Groups to send the data to Response
* [ ] Test using noflo-tester using .fbp
* [ ] Test in FlowHub (http Component?) 
* [ ] call Super insteadof childConstructor
* [ ] rename CRUD component to better represent it as the router connection

# Future
* [ ] Change update to use query insteadof params for updating individual parts
* [ ] add rollback & undo feature to the commit
* [ ] filter XSS in the description
* [ ] static (or something) optional Error port sender
* [ ] Validate could be a filter insteadof a Component ***
* [ ] transform Data before going to Validator? in Create or _
* [ ] add chaining constructor to src/Factory
* [ ] Test the AuthMiddleware & Delete 
* [ ] could change CRUD to take inPort of the action and not need named Components
* [ ] work with BlueBird Promises
* [ ] validate range in BalanceTrend

# Other
* [ ] rename `successful` to `success`

* A lot was learned & used from https://github.com/noflo/noflo-xpress