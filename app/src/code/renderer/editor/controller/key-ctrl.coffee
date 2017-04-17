events  = require '../events'
keyInfo = require '../../../both/key-info'


MAP =
    'Enter':                events.ENTER
    'Backspace':            events.BACKSPACE
    'Delete':               events.DELETE

    'Cmd+z':                events.UNDO
    'Cmd+y':                events.REDO

    'Cmd+c':                events.COPY
    'Cmd+v':                events.PASTE
    'Cmd+x':                events.CUT
    'Cmd+a':                events.SELECT_ALL
    'Cmd+f':                events.FIND_IN_FILE
    'Shift+Cmd+r':          events.REPLACE_IN_FILE
    'Cmd+d':                events.DELETE_LINE
    'Cmd+j':                events.MERGE_LINES

    'ArrowLeft':            events.MOVE_CURSOR_LEFT
    'ArrowRight':           events.MOVE_CURSOR_RIGHT
    'ArrowUp':              events.MOVE_CURSOR_UP
    'ArrowDown':            events.MOVE_CURSOR_DOWN
    'Cmd+ArrowLeft':        events.MOVE_CURSOR_TO_LINE_START
    'Cmd+ArrowRight':       events.MOVE_CURSOR_TO_LINE_END
    'Cmd+ArrowUp':          events.MOVE_CURSOR_TO_TOP
    'Cmd+ArrowDown':        events.MOVE_CURSOR_TO_BOTTOM

    'Shift+ArrowLeft':      events.SELECT_LEFT
    'Shift+ArrowRight':     events.SELECT_RIGHT
    'Shift+ArrowUp':        events.SELECT_UP
    'Shift+ArrowDown':      events.SELECT_DOWN
    'Shift+Cmd+ArrowLeft':  events.SELECT_TO_LINE_START
    'Shift+Cmd+ArrowRight': events.SELECT_TO_LINE_END
    'Shift+Cmd+ArrowUp':    events.SELECT_TO_TOP
    'Shift+Cmd+ArrowDown':  events.SELECT_TO_BOTTOM

    'Alt+ArrowUp':          events.MOVE_LINE_UP
    'Alt+ArrowDown':        events.MOVE_LINE_UP

    'Alt+ArrowUp':          events.ADD_CURSOR_IN_PREVIOUS_LINE
    'Alt+ArrowDown':        events.ADD_CURSOR_IN_NEXT_LINE

    'Alt+Cmd+r':            events.RELOAD_FILE




class KeyCtrl


    constructor: (@editor) ->
        @info = null
        @editor.view.addEventListener 'keydown',  @keyDownHandler
        @editor.view.addEventListener 'keyup',    @keyUpHandler




    keyDownHandler: (event) =>
        info  = keyInfo event
        @info = info if info.isChar or info.isMod

        #console.log 'keyDownHandler: ', info

        if info.isChar
            @editor.emit events.INSERT_TEXT, info.char
            @stopEvent event

        else if info.isMod
            type = MAP[info.mod]
            if type
                @editor.emit type
                @stopEvent event
        @




    keyUpHandler: (event) =>
        #console.log 'up:', event
        @




    stopEvent: (event) ->
        event.preventDefault()
        event.stopImmediatePropagation()




module.exports = KeyCtrl