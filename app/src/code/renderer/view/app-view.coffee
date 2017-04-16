DOM        = require '../core/tree-one'
Toolbar    = require './toolbar'
EditorView = require './editor-view'


class AppView extends DOM.Base


    constructor: () ->


    onMount: () ->
        console.log 'AppView.onMount: ', @view
        null


    onWillUnmount: () ->
        null


    render: () ->
        type: 'div'
        props:
            className: 'window'
            children: [
                type: Toolbar
                props: {}
            ,
                type: 'div'
                props:
                    className: 'content'
                    children: [
                        type: EditorView
                        props: {}
                    ]
            ]


module.exports = AppView