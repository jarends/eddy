class Cursors


    constructor: (@editor) ->
        console.log 'Cursors.constructor'
        @state = @editor.state




    getSize: () ->
        @state.get('cursors').size or 0




    getMain: () ->
        @getCursor @state.get('mainCursor')




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
        cursors = if exceptMain then [@getMain()] else []
        @state.set 'cursors', List cursors
        @




    move: (dx, dy) ->
        maxCols = @state.get 'maxCols'
        for index in [0...@getSize()]
            cursor = @state.getIn ['cursors', index]
            col    = cursor.col
            row    = cursor.row





module.exports = Cursors
