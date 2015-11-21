# Wondering
* [ ] default wiring for Components connect & disconnect? (@see component/Validate)
* [ ] how to test components that do database transactions? (@see spec/)
* [x] why the first test will timeout, and why they will all timeout sometimes? (Have to use a stupidly high [10 sec] timeout when testing... this was fickle.)
* [ ] how to send array to inPort.pattern in xpress/Router using FlowHub
* [ ] Why does https://github.com/noflo/noflo-xpress/blob/master/lib/BaseRouter.coffee not list `HEAD` and `PATCH` as valid verbs?

# @TODO:
* [x] Validate
* [x] Validate.update (optional params)
* [x] use WirePattern
* [ ] use WirePattern more in depth 
* [ ] use Group
* [x] use FloHub
* [ ] use FloHub more in depth
* [x] fix this Test inconsistency (sometimes has a timeout, usually on first test?)
* [x] pass the `req` down a side port to the Response
* [x] update all properties
* [x] PATCH to PUT unless I extend lib/BaseRouter
* [x] fix PUT to POST
* [x] .fbp into .json 
* [ ] import .json into flo via github (using https://github.com/noflo/noflo-browser-app)

# After 
* [ ] pass in connection to an inPort (@see components/Database)
* [ ] Add `Income` & `Reports`
* [ ] Test with HTTP
* [ ] List Test could load the list from the db and compare each result
* [ ] update tags
* [ ] add Morgan as Middleware to log 
* [ ] send things after tags are all saved (@see components/Store)
* [ ] improve query to save if not exists (use Raw) (@see components/Store)
* [ ] Filter null instead of returning in the map in FetchList
* [ ] TODOS in non noflo `personal-finance-tracker`
* [x] add Travis
* [ ] use Travis

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

* A lot was learned & used from https://github.com/noflo/noflo-xpress