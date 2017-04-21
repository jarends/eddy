events    = require '../events'
Blinker   = require '../service/blinker'
Cursor    = require '../views/cursor'
Line      = require '../views/line'
Meta      = require '../views/meta'
Minimap   = require '../views/minimap'
utils     = require '../../utils/utils'
getBounds = utils.getBounds




class Renderer


    constructor: (@editor) ->
        console.log 'Renderer.constructor'
        @view            = @editor.view
        @blinker         = @editor.blinker
        @mainCursor      = null
        @lines           = {}
        @cursors         = {}
        @lineCache       = []
        @cursorCache     = []
        @linesDirty      = false
        @cursorsDirty    = false
        @selectionsDirty = false
        @enabled         = false
        @bounds          = null
        @letter          = null
        @firstLine       = -1
        @rafTimeout      = null
        @opts            =
            metaWidth:    60
            minimapWidth: 120

        @createView()
        @enable()

        @textView.addEventListener 'scroll',   @onScroll
        @textView.addEventListener 'focus',    @onFocus, true
        @editor.on  events.TEXT_UPDATED,       @onTextUpdated
        @editor.on  events.CURSORS_CHANGED,    @onCursorsChanged
        @editor.on  events.SELECTIONS_CHANGED, @onSelectionsChanged
        @blinker.on Blinker.BLINK,             @onBlink




    createView: () ->
        @linesDirty = true
        @taView     = document.createElement 'textarea'
        @metaView   = document.createElement 'div'
        @textView   = document.createElement 'div'
        @scrollView = document.createElement 'div'
        @preView    = document.createElement 'pre'
        @codeView   = document.createElement 'code'
        @cursorView = document.createElement 'div'
        @minimap    = new Minimap @editor

        @metaView.className   = 'meta-view'
        @textView.className   = 'text-view'
        @scrollView.className = 'scroll-view'
        @cursorView.className = 'cursor-view'

        @taView.style.display = 'none'

        @view.      appendChild @taView
        @preView.   appendChild @codeView
        @scrollView.appendChild @preView
        @scrollView.appendChild @cursorView
        @textView.  appendChild @scrollView
        @view.      appendChild @metaView
        @view.      appendChild @textView
        @view.      appendChild @minimap.view




    enable: (value = true) ->
        @enabled = value
        @rafTimeout = window.requestAnimationFrame(@tick) if @enabled
        @




    disable: () ->
        @enabled = false
        window.cancelAnimationFrame @rafTimeout
        @




    getPos: (event) ->
        @updateFontSize() if not @letter
        x = event.clientX
        y = event.clientY + @textView.scrollTop

        x:   x
        y:   y
        w:   @letter.w
        h:   @letter.h
        col: Math.floor x / @letter.w
        row: Math.floor y / @letter.h




    updateBounds: () ->
        @linesDirty = true
        @bounds     = getBounds @textView, @bounds
        @




    updateFontSize: () ->
        #TODO: correct cursor height if cursors already created
        @linesDirty = true
        span   = document.createElement 'span'
        span.textContent = '0'
        @codeView.appendChild span
        bounds  = getBounds span
        @letter =
            w: bounds.width
            h: bounds.height
        @codeView.removeChild span
        @




    drawLines: () ->
        @updateBounds()   if not @bounds
        @updateFontSize() if not @letter

        @linesDirty = false
        totalCols   = @editor.buffer.getMaxCols()
        totalLines  = @editor.buffer.getSize()

        @scrollView.style.width  = (totalCols  * @letter.w) + 'px'
        @scrollView.style.height = (totalLines * @letter.h) + 'px'

        visibleLines = Math.round(@bounds.height / @letter.h) + 1
        firstLine    = Math.floor @textView.scrollTop / @letter.h

        line.used = false for i, line of @lines

        for i in [0...visibleLines]
            index = firstLine + i
            line  = @lines[index]
            data  = @editor.buffer.getLine index

            if index >= totalLines
                continue

            if not line
                line = @lines[index] = @lineCache.pop() or new Line(@editor)

            line.used = true
            line.update data
            if not line.view.parentElement
                line.view.style.top = (@letter.h * index) + 'px'
                @codeView.appendChild line.view

        for i, line of @lines
            if not line.used
                delete @lines[i]
                @codeView.removeChild line.view
                @lineCache.push line
        @




    drawCursors: () ->
        @updateFontSize() if not @letter

        @cursorsDirty = false
        cursor.used   = false for i, cursor of @cursors
        numCursors    = @editor.cursors.getSize()

        for i in [0...numCursors]
            data   = @editor.cursors.getCursor i
            cursor = @cursors[i]
            if not cursor
                cursor = @cursors[i] = @cursorCache.pop() or new Cursor(@)
                @cursorView.appendChild cursor.view
            cursor.update data
            if data.isMain
                @mainCursor = cursor
                @scrollTo cursor

        for i, cursor of @cursors
            if not cursor.used
                delete @cursors[i]
                @cursorView.removeChild cursor.view
                @cursorCache.push cursor
        @




    scrollTo: (cursor) ->
        sx = @textView.scrollLeft
        sy = @textView.scrollTop

        if cursor.x < sx
            @textView.scrollLeft = cursor.x
        else if cursor.x > sx + @bounds.width - 19
            @textView.scrollLeft = cursor.x - @bounds.width + 19

        if cursor.y < sy
            @textView.scrollTop = cursor.y
        else if cursor.y > sy + @bounds.height - 17 - cursor.height
            @textView.scrollTop = cursor.y - @bounds.height + 17 + cursor.height
        @



    drawSelections: () ->
        @selectionsDirty = false
        @




    tick: () =>
        @rafTimeout = window.requestAnimationFrame(@tick) if @enabled
        @drawLines()      if @linesDirty
        @drawCursors()    if @cursorsDirty
        @drawSelections() if @selectionsDirty
        @




    onScroll: () =>
        @linesDirty = true
        @




    onFocus: () =>
        console.log 'onFocus!!!'
        @taView.focus()
        @




    onBlink: () =>
        display = if @blinker.visible then 'block' else 'none'
        cursor.view.style.display = display for i, cursor of @cursors
        @




    onTextUpdated: () =>
        @linesDirty = true
        @




    onCursorsChanged: () =>
        console.log 'Renderer.onCursorsChanged'
        @cursorsDirty = true
        @




    onSelectionsChanged: () =>
        @selectionsDirty = true
        @




module.exports = Renderer
