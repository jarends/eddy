class Editor


    constructor: (@view) ->
        console.log 'Editor.constructor: ', @view
        @createView()




    createView: () ->
        console.log 'Editor.createView: '
        @
        null




    dispose: () ->
        null




module.exports = Editor