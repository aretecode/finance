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

    @outPorts = new noflo.OutPorts
      out:
        datatype: 'object'
        description: 'optional'
      error:
        datatype: 'object'

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
        # data = params.created
        data = params[name]
        cb res, data

    wirePatternFor @, 'created', (res, created) ->
      try
        if created.successful is true
          res.status(201).json JSON.stringify
            message: 'created'
            body: created
        else
          res.status(500).json JSON.stringify
            message: 'could not create'
            body: created
      catch e
        console.log e

    wirePatternFor @, 'retrieved', (res, retrieved) ->
      try
        if retrieved.successful is true
          res.status(200).json JSON.stringify
            message: 'found'
            body: retrieved.data
        else
          res.status(404).json JSON.stringify
            message: 'not found'
            body: retrieved.data
      catch e
        console.log e

    wirePatternFor @, 'deleted', (res, deleted) ->
      try
        if deleted.successful is true
          res.status(200).json JSON.stringify
            message: 'deleted'
            body: deleted.data
        else
          res.status(500).json JSON.stringify
            message: 'not found'
            body: deleted.data
      catch e
        console.log e

    wirePatternFor @, 'updated', (res, updated) ->
      try
        if updated.successful is true
          res.status(200).json JSON.stringify
            message: 'updated'
            body: updated.data
        else
          res.status(500).json JSON.stringify
            message: 'not updated'
            body: updated.data
      catch e
        console.log e


    wirePatternFor @, 'monthly', (res, updated) ->
      try
        if updated.successful is true
          res.status(302).json JSON.stringify
            message: 'updated'
            body: updated.data
        else
          res.status(404).json JSON.stringify
            message: 'not updated'
            body: updated.data
      catch e
        console.log e

exports.getComponent = -> new Response