events    = require '../events'
Blinker   = require '../service/blinker'
Cursor    = require '../views/cursor'
Line      = require '../views/line'
Meta      = require '../views/meta'
Minimap   = require '../views/minimap'
utils     = require '../../../both/utils'
getBounds = utils.getBounds




class Renderer


    constructor: (@editor) ->
        console.log 'Renderer.constructor'
        @view        = @editor.view
        @blinker     = new Blinker()
        @lines       = {}
        @cursors     = {}
        @lineCache   = []
        @cursorCache = []
        @dirty       = false
        @enabled     = false
        @bounds      = null
        @letter      = null
        @firstLine   = -1
        @rafTimeout  = null
        @opts        =
            metaWidth:    60
            minimapWidth: 120

        @createView()
        @enable()

        @textView.addEventListener 'scroll', @onScroll
        @editor.on  events.TEXT_UPDATED,     @onTextUpdated
        @blinker.on Blinker.BLINK,           @onBlink




    createView: () ->
        @dirty      = true
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




    updateBounds: () ->
        @dirty  = true
        @bounds = getBounds @view, @bounds
        @



    updateFontSize: () ->
        @dirty = true
        span   = document.createElement 'span'
        span.textContent = '0'
        @codeView.appendChild span
        bounds  = getBounds span
        @letter =
            w: bounds.width
            h: bounds.height
        @codeView.removeChild span
        @




    draw: () ->
        @updateBounds()   if not @bounds
        @updateFontSize() if not @letter

        @dirty     = false
        totalCols  = @editor.buffer.getMaxCols()
        totalLines = @editor.buffer.getSize()

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
            if not line.view.parent
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

        cursor.used = false for i, cursor of @cursors
        numCursors  = @editor.cursors.getSize()

        for i in [0...numCursors]
            data   = @editor.cursors.getCursor i
            cursor = @cursors[i]
            if not cursor
                cursor = @cursors[i] = @cursorCache.pop() or new Cursor(@editor)
            if not cursor.view.parent
                cursor.view.style.left   = (@letter.w * data.col)  + 'px'
                cursor.view.style.top    = (@letter.h * data.line) + 'px'
                cursor.view.style.height = (@letter.h - 0)         + 'px'
                @cursorView.appendChild cursor.view
            cursor.used = true
            cursor.update data

        for i, cursor of @cursors
            if not cursor.used
                delete @cursors[i]
                @cursorView.removeChild cursor.view
                @cursorCache.push cursor
        @




    tick: () =>
        @rafTimeout = window.requestAnimationFrame(@tick) if @enabled
        @draw() if @dirty
        @




    onScroll: () =>
        @dirty = true
        @




    onBlink: () =>
        display = if @blinker.visible then 'none' else 'block'
        cursor.view.style.display = display for i, cursor of @cursors
        @




    onTextUpdated: () =>
        @dirty = true
        @drawCursors()
        @



module.exports = Renderer
