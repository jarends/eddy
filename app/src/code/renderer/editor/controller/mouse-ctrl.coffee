class MouseCtrl


    constructor: (@editor) ->
        @editor.view.addEventListener 'keydown', @keyDownHandler
        @editor.view.addEventListener 'keyup',   @keyUpHandler


    mouseDown: () ->


module.exports = MouseCtrl