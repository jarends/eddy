Cursor    = require '../views/cursor'
Line      = require '../views/line'
Meta      = require '../views/meta'
Minimap   = require '../views/minimap'
Rect      = require '../../../both/utils/rect'
getBounds = require '../../../both/utils/bounds'




class Renderer


    constructor: (@editor) ->
        console.log 'Renderer.constructor'
        @view        = @editor.view
        @blinker     = new Blinker @
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




    createView: () ->
        @dirty      = true
        @metaView   = document.createElement 'div'
        @textView   = document.createElement 'div'
        @scrollView = document.createElement 'div'
        @preView    = document.createElement 'pre'
        @codeView   = document.createElement 'code'
        @minimap    = new Minimap @editor


        @metaView.className   = 'meta-view'
        @textView.className   = 'text-view'
        @scrollView.className = 'scroll-view'

        @preView.   appendChild @codeView
        @scrollView.appendChild @preView
        @textView.  appendChild @scrollView
        @view.      appendChild @metaView
        @view.      appendChild @textView
        @view.      appendChild @minimap.view

        @textView.addEventListener 'scroll', @scrollHandler




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




    scrollHandler: () =>
        @dirty = true
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


        cursor.used = false for i, cursor of @cursors
        numCursors = @editor.cursors.getSize()

        for i in [0...numCursors]
            data   = @editor.cursors.getCursor i
            cursor = @cursors[i]
            if not cursor
                cursor = @cursors[i] = @cursorCache.pop() or new Cursor(@editor)
            cursor.used = true
            cursor.update data
            if not cursor.view.parent
                cursor.view.style.left   = (@letter.w * data.col)  + 'px'
                cursor.view.style.top    = (@letter.h * data.line) + 'px'
                cursor.view.style.height = (@letter.h - 1)         + 'px'
                @scrollView.appendChild cursor.view

        for i, cursor of @cursors
            if not cursor.used
                delete @cursors[i]
                @scrollView.removeChild cursor.view
                @cursorCache.push cursor
        @




    tick: () =>
        @rafTimeout = window.requestAnimationFrame(@tick) if @enabled
        @draw() if @dirty
        @blinker.tick()
        @



class Blinker


    constructor: (@renderer) ->
        @start()


    start: () ->
        @frames  = 0
        @visible = true


    show: () ->
        @visible = true
        for i, cursor of @renderer.cursors
            cursor.view.style.display = 'block'


    hide: () ->
        @visible = false
        for i, cursor of @renderer.cursors
            cursor.view.style.display = 'none'


    tick: () ->
        if ++@frames == 30
            @frames = 0
            if @visible then @hide() else @show()
        @



module.exports = Renderer
