class Meta


    constructor: (@line) ->
        @view           = document.createElement 'span'
        @view.className = 'meta'




    update: (data) ->
        if @index != data.index
            @index = data.index
            @view.textContent = @index

        if @height != @line.renderer.letter.h
            @height                = @line.renderer.letter.h
            @view.style.lineHeight = @height + 'px'

        if @indexCols != @line.renderer.indexCols
            @indexCols        = @line.renderer.indexCols
            @view.style.width = (@indexCols * @line.renderer.metaLetter.w) + 'px'
        @




module.exports = Meta
