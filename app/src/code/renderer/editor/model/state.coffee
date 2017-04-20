immutable = require 'immutable'
Map       = immutable.Map
List      = immutable.List




class State


    constructor: (@editor) ->
        @data = Map
            mainCursor: 0
            maxCols:    0
            lines:      List()
            selections: List()
            cursors:    List [
                Map {col: 0, row: 0}
            ]

        @pointer = 0
        @history = []
        console.log 'State.constructor: ', @, @getIn ['cursors', 0, 'col']




    get:   (key)         -> @data.get   key
    getIn: (keys)        -> @data.getIn keys
    set:   (key,  value) -> @data = @data.set   key,  value
    setIn: (keys, value) -> @data = @data.setIn keys, value




    step: () ->
        @




    undo: () ->
        @




    redo: () ->
        @




module.exports = State
