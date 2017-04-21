class Line


    constructor: (@editor) ->
        @view = document.createElement 'span'
        @view.className = 'line'




    update: (data) ->
        if @text != data.text
            @text = @view.innerHTML = data.text
        null




module.exports = Line
