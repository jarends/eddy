mods =
    Shift:   '⇧'
    Control: '^'
    Alt:     '⌥'
    Meta:    '⌘'
    Dead:    true


keyInfo = (event) ->
    key    = event.key
    shift  = event.shiftKey
    ctrl   = event.ctrlKey
    alt    = event.altKey
    cmd    = event.metaKey
    isChar = key.length == 1 and not (ctrl or cmd)
    char   = if isChar then key else ''
    code   = event.code
    code   = if key.length == 1 and /^Key/.test(code) then code.slice(-1).toLowerCase() else ''
    mod    = ''

    if not mods[key] and not isChar
        mod += 'Shift+' if shift
        mod += 'Ctrl+'  if ctrl
        mod += 'Alt+'   if alt
        mod += 'Cmd+'   if cmd
        mod += code or key

    isChar: isChar
    char:   char
    isMod:  mod.length > 0
    mod:    mod
    key:    key
    code:   code
    shift:  shift
    ctrl:   ctrl
    alt:    alt
    cmd:    cmd
    event:  event


module.exports = keyInfo
