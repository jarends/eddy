FS          = require 'fs'
Path        = require 'path'
Emitter     = require 'events'
Coffee      = require "coffee-script"
State       = require './model/state'
Buffer      = require './model/buffer'
Cursors     = require './model/cursors'
Selection   = require './model/selection'
KeyCtrl     = require './controller/key-ctrl'
MouseCtrl   = require './controller/mouse-ctrl'
Blinker     = require './service/blinker'
Indexer     = require './service/indexer'
Completion  = require './service/completion'
Highlighter = require './service/highlighter'
Renderer    = require './service/renderer'
CmdMap      = require '../utils/cmd-map'

TEST = Path.join __dirname, '../../test'
CODE = FS.readFileSync(Path.join(TEST, 'dom.coffee')).toString()




class Editor extends Emitter


    constructor: (@view) ->
        console.log 'Editor.constructor: ', @view
        @init()

        #console.log Coffee.nodes(CODE).toString()
        setTimeout () => @setText 'coffeescript', CODE




    init: () ->
        return if @initialized
        @initialized = true
        @blinker     = new Blinker()
        @cmdMap      = new CmdMap      @
        @state       = new State       @
        @buffer      = new Buffer      @
        @cursors     = new Cursors     @
        @selection   = new Selection   @
        @renderer    = new Renderer    @
        @indexer     = new Indexer     @
        @completion  = new Completion  @
        @highlighter = new Highlighter @
        @keyCtrl     = new KeyCtrl     @
        @mouseCtrl   = new MouseCtrl   @

        @cmdMap.mapDir Path.join __dirname, 'commands'
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