Emitter = require 'events'


class Blinker extends Emitter


    @BLINK     = 'blink'
    @VISIBLE   = 'visible'
    @INVISIBLE = 'invisible'


    constructor: () ->
        super()
        @visible = true
        @start()


    start: () ->
        return @ if @running
        @running = true
        @visible = true
        @frames  = 0
        @rafTimeout = window.requestAnimationFrame @tick
        @blink()
        @


    stop: () ->
        return if not @running
        @running = false
        @visible = true
        @frames  = 0
        window.cancelAnimationFrame @rafTimeout
        @blink()
        @


    show: () ->
        return @ if @visible
        @visible = true
        @frames  = 0
        @blink()
        @


    hide: () ->
        return @ if not @visible
        @visible = false
        @frames  = 0
        @blink()
        @


    toggle: () ->
        if @visible then @hide() else @show()
        @


    blink: () ->
        if @visible then @emit(Blinker.VISIBLE) else @emit(Blinker.INVISIBLE)
        @emit Blinker.BLINK, @visible
        @


    tick: () =>
        @rafTimeout = window.requestAnimationFrame @tick
        if ++@frames == 30
            @toggle()
        @


module.exports = Blinker

