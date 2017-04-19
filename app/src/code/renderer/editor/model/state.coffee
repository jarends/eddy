immutable = require 'immutable'
Map       = immutable.Map




class State


    constructor: (@editor) ->
        @data = Map
            mainCursor: 0
            maxCols:    0
            lines:      []
            selections: []
            cursors:    [
                col: 0
                row: 0
            ]

        @pointer = 0
        @history = []
        console.log 'State.constructor: ', @




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
