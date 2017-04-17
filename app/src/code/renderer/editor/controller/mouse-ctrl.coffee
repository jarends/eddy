class MouseCtrl


    constructor: (@editor) ->
        @dragging     = false
        @dragStartPos = null
        @lastDragPos  = null
        @editor.view.addEventListener 'mousedown', @onMouseDown
        @editor.view.addEventListener 'mousemove', @onMouseMove
        @editor.view.addEventListener 'click',     @onClick
        @editor.view.addEventListener 'dblclick',  @onDoubleClick


    getPos: (event) ->
        @editor.renderer.getPos event


    onMouseDown: (event) =>
        #console.log 'onMouseDown: ', @renderer.getPos event
        @dragStartPos = @getPos event
        window.addEventListener 'mousemove',  @onDragMove
        window.addEventListener 'mouseup',    @onDragEnd
        @


    onDragMove: (event) =>
        pos = @getPos event
        if not @dragging
            dx        = Math.abs(pos.x - @dragStartPos.x0)
            dy        = Math.abs(pos.y - @dragStartPos.y0)
            @dragging = Math.abs(dx) > pos.w * 0.5 or Math.abs(dy) > pos.h


        if @dragging
            if @lastDragPos
                dx  = pos.col - @lastDragPos.col
                dy  = pos.row - @lastDragPos.row
                if dx or dy
                    dx = pos.col - @dragStartPos.col
                    dy = pos.row - @dragStartPos.row
                    @lastDragPos = pos
                    console.log 'changeSelection: ', dx, dy
            else
                @lastDragPos = pos
                console.log 'startChangingSelection: ', pos.col, pos.row
        @




    onDragEnd: (event) =>
        #console.log 'onDragEnd: ', event
        @dragging = false
        window.removeEventListener 'mousemove',  @onDragMove
        window.removeEventListener 'mouseup',    @onDragEnd
        @


    onMouseMove: (event) =>
        #if event.metaKey
            #console.log 'onMouseMove: ', event
        @


    onClick: (event) =>
        #console.log 'onClick: ', event
        @


    onDoubleClick: (event) =>
        #console.log 'onDoubleClick: ', event
        @




module.exports = MouseCtrl