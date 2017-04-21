class Cursor


    constructor: (@renderer) ->
        console.log 'Cursor.constructor'
        @height            = @renderer.letter.h
        @view              = document.createElement 'span'
        @view.className    = 'cursor'
        @view.style.height = @height + 'px'




    update: (data) ->
        if not @data or @data and @data.col != data.col
            @x = data.col * @renderer.letter.w
            @view.style.left = @x + 'px'

        if not @data or @data and @data.row != data.row
            @y = data.row * @renderer.letter.h
            @view.style.top = @y + 'px'

        if @height != @renderer.letter.h
            @height            = @renderer.letter.h
            @view.style.height = @height + 'px'

        @used = true
        @data = data
        @




module.exports = Cursor
