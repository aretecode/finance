noflo = require 'noflo'

class Response extends noflo.Component
  description: 'Send a Response.'
  icon: 'send'

  constructor: ->
    @inPorts = new noflo.InPorts
      res:
        datatype: 'object'
        description: 'Response object'
      created:
        datatype: 'object'
      updated:
        datatype: 'object'
      deleted:
        datatype: 'object'
      retrieved:
        datatype: 'object'
      monthly:
        datatype: 'object'
      trend:
        datatype: 'object'

    @outPorts = new noflo.OutPorts
      out:
        datatype: 'object'
        description: 'optional'
      error:
        datatype: 'object'

    wiredResponse = (res, data, passCode, passMsg, failCode, failMsg) ->
      try
        if data.success is true
          res.status(passCode).json
            message: passMsg
            body: data.data
        else
          res.status(failCode).json
            message: failMsg
            body: data.data
      catch e
        console.log e
        c.error
          error: e
          component 'Response'
          data: data

    wiredResponses = (res, data, responses) ->
      for r in responses
        if r.passCond? and data.success is r.passCond
          return res.status(r.passCode).json
            message: r.passMsg
            body: data.data
        else if r.failCond? and data.success is r.failCond
          return res.status(r.failCode).json
            message: r.failMsg
            body: data.data
      return res.status(500).json
        message: 'unknown error, unhandled'
        body: data.data

    wirePatternFor = (context, name, cb) ->
      noflo.helpers.WirePattern context,
        in: ['res', name]
        out: []
        params: ['res', name]
        async: true
        forwardGroups: true
      , (params) ->
        req = params.res.req
        res = req.res
        data = params[name]
        cb res, data

    wirePatternResFor = (context, name, passCode, passMsg, failCode, failMsg) ->
      wirePatternFor context, name, (res, data) ->
        wiredResponse res, data, passCode, passMsg, failCode, failMsg

    wirePatternsResFor = (context, name, responses) ->
      wirePatternFor context, name, (res, data) ->
        wiredResponses res, data, responses

    wirePatternsResFor(@, 'created', [
      {
        passCond: 'duplicate'
        passCode: 409
        passMsg: 'already exists with that key'
      }
      {
        passCond: true
        passCode: 201
        passMsg: 'created'
        failCond: false
        failCode: 500
        failMessage: 'couldNotCreate'
      }])

    wirePatternResFor @, 'retrieved', 200, 'found', 404, 'not found'
    wirePatternResFor @, 'deleted', 200, 'deleted', 500, 'not able to delete'
    wirePatternResFor @, 'updated', 200, 'updated', 500, 'not updated'
    wirePatternResFor @, 'monthly', 302, 'found', 404, 'not found (month & yr)'
    wirePatternResFor @, 'trend', 200, 'found', 404, 'not found'

exports.getComponent = -> new Response
