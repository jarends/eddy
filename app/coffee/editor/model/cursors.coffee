immutable = require 'immutable'
events    = require '../events'
Map       = immutable.Map
List      = immutable.List


class Cursors


    constructor: (@editor) ->
        console.log 'Cursors.constructor'
        @state  = @editor.state
        @buffer = @editor.buffer




    getSize: () ->
        @state.get('cursors').size or 0




    getMain: () ->
        @getCursor @state.get('mainCursor')




    setMain: (col, row) ->
        @removeAll() if @getSize() > 1
        main = @state.get 'mainCursor'
        @state.setIn ['cursors', main, 'col'], col
        @state.setIn ['cursors', main, 'row'], row
        @




    getCursor: (index) ->
        return null if index < 0 or index >= @getSize()
        cursor = @state.getIn(['cursors', index]).toJS()
        cursor.isMain = index == @state.get 'mainCursor'
        cursor




    addCursor: (col, row) ->
        @




    removeCursor: (index) ->
        @




    removeCursorsBetween: (row0, col0, row1, col1) ->
        @




    removeAll: (exceptMain = true) ->
        cursors = if exceptMain then [Map @getMain()] else []
        @state.set 'cursors', List cursors
        @




    move: (dx, dy) ->
        maxCols = @buffer.getMaxCols()
        maxRows = @buffer.getSize()
        cursors = @state.get 'cursors'
        @forEach (cursor, index) =>
            col = cursor.col + dx
            row = cursor.row + dy
            if col > maxCols
                ++row
                col = 0
            if col < 0
                --row
                col = @buffer.getLineLength(row)
            row = Math.min Math.max(0, row), maxRows

            @state.setIn ['cursors', index], @create(col, row)
        @removeEqual()
        @editor.renderer.cursorsDirty = true
        @editor.blinker.show()
        @








    create: (col, row) ->
        Map
            col: col
            row: row




    forEach: (callback) ->
        cursors = @state.get 'cursors'
        for index in [0...cursors.size]
            callback cursors.get(index).toJS(), index
        null




    removeEqual: () ->
        main    = @state.get 'mainCursor'
        map     = {}
        result  = List()
        @forEach (cursor, index) ->
            key = cursor.col + '_' + cursor.row
            if not map[key]
                main     = result.length if index == main
                cursor   = Map cursor
                map[key] = cursor
                result   = result.push cursor
            else
                if index == main
                    main = result.indexOf map[key]
        @state.set 'cursors', result
        @




module.exports = Cursors
