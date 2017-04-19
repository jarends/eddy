immutable = require 'immutable'
events    = require '../events'
Map       = immutable.Map
List      = immutable.List


class Buffer


    constructor: (@editor) ->
        console.log 'Buffer.constructor: '
        @state = @editor.state




    updateText: (text) ->
        text  = (text or '').replace /\t/g, '    '
        text  = text.split /\r\n|\r|\n/
        lines = []
        max   = 0

        for t, i in text
            l   = t.length
            max = l if l > max
            lines.push Map
                text:  t
                index: i

        @state.set 'lines',   List lines
        @state.set 'maxCols', max
        @editor.emit events.TEXT_UPDATED
        @



    getSize: () ->
        @state.get('lines').size or 0




    getMaxCols: () ->
        @state.get 'maxCols'




    getLine: (index) ->
        return null if index < 0 or index >= @getSize()
        @state.getIn(['lines', index]).toJS()




    insertTextAt: (row, col, text) ->
        @




    removeText: (row0, col0, row1, col1) ->

        @




    removeCharAt: (row, col) ->

        @




module.exports = Buffer
