class MouseCtrl


    constructor: (@editor) ->
        @lastPos      = null
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
        if not @lastDragPos
            dx = Math.abs(pos.x - @dragStartPos.x)
            dy = Math.abs(pos.y - @dragStartPos.y)
            if Math.abs(dx) > pos.w * 0.5 or Math.abs(dy) > pos.h
                @lastDragPos = pos
                console.log 'startChangingSelection: ', pos.col, pos.row

        if @lastDragPos
            dx = pos.col - @lastDragPos.col
            dy = pos.row - @lastDragPos.row
            if dx or dy
                dx = pos.col - @dragStartPos.col
                dy = pos.row - @dragStartPos.row
                @lastDragPos = pos
                console.log 'changeSelection: ', dx, dy
        @




    onDragEnd: () =>
        window.removeEventListener 'mousemove',  @onDragMove
        window.removeEventListener 'mouseup',    @onDragEnd
        @


    onMouseMove: (event) =>
        if not @lastDragPos and event.metaKey
            pos = @getPos event
            if @lastPos
                dx = pos.col - @lastPos.col
                dy = pos.row - @lastPos.row
                if dx or dy
                    console.log 'current pos changed: ', pos.col, pos.row
            @lastPos = pos
        @


    onClick: (event) =>
        if not @lastDragPos
            console.log 'onClick: ', event
        @lastDragPos = null
        @


    onDoubleClick: (event) =>
        if not event.altKey
            console.log 'onDoubleClick: ', event
        @




module.exports = MouseCtrl