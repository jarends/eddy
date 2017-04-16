class Minimap


    constructor: (@editor) ->
        console.log 'Minimap.constructor'
        @view = document.createElement 'div'
        @view.className = 'minimap'




module.exports = Minimap
