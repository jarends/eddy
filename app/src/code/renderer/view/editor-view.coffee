DOM    = require '../core/dom'
Editor = require '../editor/editor'


class EditorView extends DOM.Base


    constructor: (props) ->
        super props


    onMount: () ->
        super()
        @editor = new Editor @view
        null


    onWillUnmount: () ->
        super()
        @editor.dispose()
        @editor = null


    render: () ->
        type: 'div'
        props:
            className: 'editor'




module.exports = EditorView
