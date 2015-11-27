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
          res.status(passCode).json JSON.stringify
           #  success: data.data.success
            message: passMsg
            body: data.data
        else
          res.status(failCode).json JSON.stringify
            # success: data.data.success
            message: failMsg
            body: data.data
      catch e
        console.log e

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

    wirePatternResFor @, 'created', 201, 'created', 500, 'could not create'
    wirePatternResFor @, 'retrieved', 200, 'found', 404, 'not found'
    wirePatternResFor @, 'deleted', 200, 'deleted', 500, 'not able to delete'
    wirePatternResFor @, 'updated', 200, 'updated', 500, 'not updated'
    wirePatternResFor @, 'monthly', 302, 'found', 404, 'not found (month & yr)'
    wirePatternResFor @, 'trend', 200, 'found', 404, 'not found'

exports.getComponent = -> new Response
