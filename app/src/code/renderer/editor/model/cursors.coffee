class Cursors


    constructor: (@editor) ->
        console.log 'Cursors.constructor'


    getSize: () ->
        @editor.state.record.get('cursors').size


    getCursor: (index) ->
        col:  @editor.state.record.getIn ['cursors', index, 'col']
        line: @editor.state.record.getIn ['cursors', index, 'line']




module.exports = Cursors
