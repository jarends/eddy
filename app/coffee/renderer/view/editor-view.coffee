DOM    = require '../core/tree-one'
Editor = require '../../editor/context'


class EditorView extends DOM.Base


    constructor: (props) ->
        super props


    onMount: () ->
        super()
        @editor = new Editor @view
        window.addEventListener 'resize', @updateBounds
        @


    onWillUnmount: () ->
        super()
        @editor.dispose()
        @editor = null
        window.removeEventListener 'resize', @updateBounds
        @


    updateBounds: () =>
        @editor.renderer.updateBounds()
        @


    render: () ->
        type: 'div'
        props:
            tabindex:  0
            className: 'editor'




module.exports = EditorView
