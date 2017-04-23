class Cursor


    constructor: (@renderer) ->
        console.log 'Cursor.constructor'
        @visible        = true
        @view           = document.createElement 'span'
        @view.className = 'cursor'




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

        @blink()

        @used = true
        @data = data
        @




    blink: () ->
        visible = @renderer.blinker.visible
        if @visible != visible
            @visible = visible
            @view.style.display = if visible then 'block' else 'none'
        @



module.exports = Cursor
