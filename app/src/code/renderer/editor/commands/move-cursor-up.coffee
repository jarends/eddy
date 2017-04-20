class Cmd

    execute: () ->
        console.log 'execute: ', @event
        @ctx.cursors.move 0, -1
        @

module.exports = Cmd