immutable = require 'immutable'
Record    = immutable.Record
List      = immutable.List


Cursor = Record
    cold: 0
    line: 0


StateRecord = Record
    lines:     List []
    cursors:   List [new Cursor()]
    selection: List []
    maxCols:    0
    mainCusour: 0




class State


    constructor: (@editor) ->
        @record  = new StateRecord()
        @pointer = 0
        @history = []
        console.log 'State.constructor: ', @


    get: (key) ->
        @record.get key


    set: (key, value) ->
        @record = @record.set key, value


    step: () ->
        @



    undo: () ->
        @



    redo: () ->
        @




module.exports = State
