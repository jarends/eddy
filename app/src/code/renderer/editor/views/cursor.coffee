class Cursor


    constructor: (@editor) ->
        console.log 'Cursor.constructor'
        @view = document.createElement 'span'
        @view.className = 'cursor'




    update: (data) ->
        null




module.exports = Cursor
