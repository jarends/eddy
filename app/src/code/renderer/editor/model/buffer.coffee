immutable = require 'immutable'
events    = require '../events'
Record    = immutable.Record
List      = immutable.List


Line = Record
    text:  ''
    index: -1


class Buffer


    constructor: (@editor) ->
        console.log 'Buffer.constructor: ', @getSize()




    updateText: (text) ->
        state = @editor.state
        text  = (text or '').replace /\t/g, '    '
        text  = text.split /\r\n|\r|\n/
        lines = []
        max   = 0

        for t, i in text
            l   = t.length
            max = l if l > max
            lines.push new Line
                text:  t
                index: i

        state.set 'lines',   List lines
        state.set 'maxCols', max
        @editor.emit events.TEXT_UPDATED
        @



    getSize: () ->
        @editor.state.record.get('lines').size




    getMaxCols: () ->
        @editor.state.get('maxCols')




    getLine: (index) ->
        text:  @editor.state.record.getIn ['lines', index, 'text']
        index: @editor.state.record.getIn ['lines', index, 'index']




    getLines: () ->
        @



    addLines: (index, text) ->
        @




module.exports = Buffer
