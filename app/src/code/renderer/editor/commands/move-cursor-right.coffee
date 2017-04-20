class Cmd

    execute: () ->
        console.log 'execute: ', @event
        @ctx.cursors.move 1, 0
        @

module.exports = Cmd