t = Date.now()
Prism = require 'prismjs'
require 'prismjs/components/prism-coffeescript'
console.log 'prisom require: ', Date.now() - t


class Highlighter


    constructor: (@editor) ->
        console.log 'Highlighter.constructor'


    highlight: (text) ->
        Prism.highlight text, Prism.languages.coffeescript


module.exports = Highlighter
