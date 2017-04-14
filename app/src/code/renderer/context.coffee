Post    = require 'ppost'
DOM     = require './core/dom'
AppView = require './view/app-view'
events  = require '../both/events'




class Context


    constructor: () ->
        @startup()




    startup: () ->
        document.body.style.backgroundColor = '#222222'
        DOM.render DOM.create(AppView, {}), document.querySelector('.app'), @
        null




module.exports = new Context()