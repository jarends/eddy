DOM = require '../core/tree-one'


class Toolbar extends DOM.Base


    constructor: () ->


    render: () ->
        type: 'div'
        props:
            className: 'toolbar'
            tabindex:  0
            children:  [
                'toolbar'
            ]




module.exports = Toolbar
