DOM = require '../core/dom'


class Toolbar extends DOM.Base


    constructor: () ->


    render: () ->
        type: 'div'
        props:
            className: 'toolbar'
            children: [
                'toolbar'
            ]




module.exports = Toolbar
