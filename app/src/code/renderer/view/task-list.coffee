DOM = require '../core/dom'




class TaskList extends DOM.Base


    constructor: (@props) ->


    onMount: () ->


    onWillUnmount: () ->


    render: () ->
        type: 'div'
        props:
            className: 'task-list split split-horizontal'
            children:  ['task-list']



module.exports = TaskList