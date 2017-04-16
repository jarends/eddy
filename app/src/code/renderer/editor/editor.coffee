FS          = require 'fs'
Path        = require 'path'
Emitter     = require 'events'
State       = require './model/state'
Buffer      = require './model/buffer'
Cursors     = require './model/cursors'
Selection   = require './model/selection'
Indexer     = require './service/indexer'
Completion  = require './service/completion'
Highlighter = require './service/highlighter'
Keys        = require './service/keys'
Mouse       = require './service/mouse'
Renderer    = require './service/renderer'


TEST = Path.join __dirname, '../../../../test'
CODE = FS.readFileSync(Path.join(TEST, 'dom.coffee')).toString()




class Editor extends Emitter


    constructor: (@view) ->
        console.log 'Editor.constructor: ', @view
        @init()

        start = () =>
            @setText 'coffeescript', CODE
        setTimeout start, 1




    init: () ->
        return if @initialized
        @initialized = true
        @state       = new State       @
        @buffer      = new Buffer      @
        @cursors     = new Cursors     @
        @selection   = new Selection   @
        @indexer     = new Indexer     @
        @completion  = new Completion  @
        @highlighter = new Highlighter @
        @keys        = new Keys        @
        @mouse       = new Mouse       @
        @renderer    = new Renderer    @
        @




    setText: (type, text) ->
        @dispose() if @type and @type != type
        @type = type
        @init() if not @initialized
        @updateText text
        @




    setState: (state) ->
        @dispose() if @state and @state != state
        @




    updateText: (text) ->
        console.log 'Editor.updateText'
        @buffer.updateText text
        @




    dispose: () ->
        console.log 'Editor.updateText'
        @




module.exports = Editor