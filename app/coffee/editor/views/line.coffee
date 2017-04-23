Meta = require './meta'


class Line


    constructor: (@renderer) ->
        @meta           = new Meta(@)
        @view           = document.createElement 'span'
        @view.className = 'line'




    update: (data) ->
        if @text != data.text
            @text = @view.innerHTML = data.text
        if not @view.parentNode
            @meta.update data
            y = @renderer.letter.h * data.index
            @view.style.top      = y + 'px'
            @meta.view.style.top = y + 'px'
            @renderer.codeView.appendChild @view
            @renderer.metaScrollView.appendChild @meta.view
        @meta.update data
        null




    remove: () ->
        @renderer.codeView.removeChild @view
        @renderer.metaScrollView.removeChild @meta.view




module.exports = Line
