Split      = require 'split.js'
DOM        = require '../core/dom'
Toolbar    = require './toolbar'
TaskList   = require './task-list'
EditorView = require './editor-view'


class AppView extends DOM.Base


    constructor: () ->


    onMount: () ->
        console.log 'AppView.onMount: ', @view
        child0  = @view.childNodes[1].childNodes[0]
        child1  = @view.childNodes[1].childNodes[1]
        @splitH = Split [child0, child1], { sizes: [20, 80], cursor: 'col-resize', gutterSize: 1}
        null


    onWillUnmount: () ->
        @splitH.destroy()
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
                        type: TaskList
                        props: {}
                    ,
                        type: EditorView
                        props: {}
                    ]
            ]


module.exports = AppView