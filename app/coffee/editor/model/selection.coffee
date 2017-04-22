immutable = require 'immutable'
events    = require '../events'
Map       = immutable.Map
List      = immutable.List




class Selection


    constructor: (@editor) ->
        console.log 'Selection.constructor'
        @state = @editor.state




    getSize: () ->
        @state.get('selections').size or 0




    getSelection: (index) ->
        return null if index < 0 or index >= @getSize()
        selection = @state.getIn(['selections', index]).toJS()
        cursor




module.exports = Selection
