__id__ = 0


#    000000000  000   000  00000000   00000000   0000000
#       000      000 000   000   000  000       000     
#       000       00000    00000000   0000000   0000000 
#       000        000     000        000            000
#       000        000     000        00000000  0000000 

#TODO: remove func type
#TODO: enable comp instances inclusive own view???

TEXT  = 0
TAG   = 1
FUNC  = 2
CLASS = 3




#    000   000  00000000  000      00000000   00000000  00000000    0000000
#    000   000  000       000      000   000  000       000   000  000     
#    000000000  0000000   000      00000000   0000000   0000000    0000000 
#    000   000  000       000      000        000       000   000       000
#    000   000  00000000  0000000  000        00000000  000   000  0000000 

isBool   = (value) -> typeof value == 'boolean'
isNumber = (value) -> typeof value == 'number'
isString = (value) -> typeof value == 'string' or value == value + ''
isNull   = (value) -> value == null or value == undefined
isObject = (value) -> value != null and typeof value == 'object'
isFunc   = (value) -> value != null and typeof value == 'function'
isClass  = (value) -> value != null and value.prototype and !!value.prototype.render
isHTML   = (value) -> value instanceof HTMLElement
isNode   = (value) -> value and value.root and value.root.children and value.root.children[0] == value
isComp   = (value) -> value instanceof BaseComponent
isSimple = (value) -> typeof value == 'string' or typeof value == 'number' or typeof value == 'boolean'


normalizeName = (name) ->
    name.replace /[A-Z]/g, (name) ->
        '-' + name.toLowerCase()


normalizeEvent = (type) ->
    type = type.slice 2
    type.charAt(0).toLowerCase() + normalizeName type.slice(1)




makeCfg = (cfg) ->
    return cfg if not isNull cfg.kind
    if isSimple cfg
        cfg =
            type:  null
            props: cfg + ''
            kind:  TEXT
        return cfg
    props = cfg.props
    type  = cfg.type
    if isSimple props
        props =
            children:[props + '']
    switch true
        when isString type then kind = TAG
        when isClass  type then kind = CLASS
        when isFunc   type then kind = FUNC
        else
            throw new Error 'DOM ERROR: unknown node kind for cfg: ' + cfg
    cfg.kind = kind
    cfg


createTextView = (node, cfg) ->
    node.attrs = cfg.props
    node.view  = document.createTextNode cfg.props
    cfg


createTagView = (node, cfg) ->
    node.tag  = cfg.type
    node.view = document.createElement cfg.type
    cfg


createFuncView = (node, cfg) ->
    createTagView node, cfg.type(cfg.props)


createClassView = (node, cfg) ->
    comp      = new cfg.type(cfg.props)
    comp.id   = node.id
    node.comp = comp # sets a new comp for all none comp children
    cfg       = comp.render()
    #TODO: Maybe this is wrong? We allow components to be text nodes??? Maybe this must be handled elsewhere
    if isSimple cfg
        node.attrs = cfg + ''
        node.view  = document.createTextNode cfg + ''
    else
        createTagView node, cfg
        comp.view = node.view
    cfg


factory = [
    createTextView
    createTagView
    createFuncView
    createClassView
]


createView = (node, cfg) ->
    factory[cfg.kind] node, cfg








#    0000000     0000000    0000000  00000000
#    000   000  000   000  000       000     
#    0000000    000000000  0000000   0000000 
#    000   000  000   000       000  000     
#    0000000    000   000  0000000   00000000

class BaseComponent

    constructor: (@props) ->
        #console.log 'comp.constructor : ', @

    update: () ->
        #console.log 'comp.update: ', @
        DOM.update @id

    render: () ->
        #console.log 'comp.render: ', @

    # if it returns true, the dom will keep the node and will call render
    # return true, if you can update your props (if appropriate) and let the dom render the component again
    # return false, if the dom should decide, if it replaces the node or does nothing
    updateProps: (props) -> false

    onMount: () ->

    onWillUnmount: () ->

    onRender: () ->
        console.log 'comp.onRender: ', @








#    000   000        0000000     0000000   00     00
#    000   000        000   000  000   000  000   000
#     000 000         000   000  000   000  000000000
#       000           000   000  000   000  000 0 000
#        0            0000000     0000000   000   000

class VirtualDOM


    constructor: () ->
        @nodeMap  = {}
        @dirtyMap = {}
        @rootMap  = {}
        window.requestAnimationFrame(@tick) if typeof window != 'undefined'








    #    00000000   000   000  0000000    000      000   0000000
    #    000   000  000   000  000   000  000      000  000     
    #    00000000   000   000  0000000    000      000  000     
    #    000        000   000  000   000  000      000  000     
    #    000         0000000   0000000    0000000  000   0000000
    



    #     0000000  00000000   00000000   0000000   000000000  00000000
    #    000       000   000  000       000   000     000     000     
    #    000       0000000    0000000   000000000     000     0000000 
    #    000       000   000  000       000   000     000     000     
    #     0000000  000   000  00000000  000   000     000     00000000

    create: (type, props, kind) ->
        type:  type
        props: props
        kind:  kind




    #    00000000   00000000  000   000  0000000    00000000  00000000 
    #    000   000  000       0000  000  000   000  000       000   000
    #    0000000    0000000   000 0 000  000   000  0000000   0000000  
    #    000   000  000       000  0000  000   000  000       000   000
    #    000   000  00000000  000   000  0000000    00000000  000   000

    render: (cfg, host, ctx) ->
        root =
            kind:  TAG
            view:  host
            depth: -1
            ctx:   ctx

        t = Date.now()
        root.root         = root
        node              = @createNode cfg, root
        root.id           = node.id
        root.children     = [node]
        @rootMap[node.id] = root
        host.appendChild node.view
        node.comp.onMount() if node.comp
        console.log 'render tooks: ', (Date.now() - t)
        node

                


    #    00000000   00000000  00     00   0000000   000   000  00000000
    #    000   000  000       000   000  000   000  000   000  000     
    #    0000000    0000000   000000000  000   000   000 000   0000000 
    #    000   000  000       000 0 000  000   000     000     000     
    #    000   000  00000000  000   000   0000000       0      00000000

    remove: (hostOrRootOrNodeOrComp) ->
        host = hostOrRootOrNodeOrComp
        root = hostOrRootOrNodeOrComp
        node = hostOrRootOrNodeOrComp
        comp = hostOrRootOrNodeOrComp

        if isHTML host
            for id, root of @rootMap
                break if root.view == host
        else if isNode node
            root = @rootMap[node.id]
        else if isComp comp
            root = @rootMap[comp.id]

        return false if not root

        host = root.view
        node = root.children[0]

        @disposeNode node
        host.removeChild node.view
        delete @rootMap[node.id]
        true




    #    000   000  00000000   0000000     0000000   000000000  00000000
    #    000   000  000   000  000   000  000   000     000     000     
    #    000   000  00000000   000   000  000000000     000     0000000 
    #    000   000  000        000   000  000   000     000     000     
    #     0000000   000        0000000    000   000     000     00000000

    update: (id) ->
        if not @nodeMap[id]
            #throw new Error "DOM ERROR: can't update node with id = #{id}. Node doesn't exist."
            return
        @dirtyMap[id] = true
        @dirty        = true
        null




    #     0000000   00000000  000000000        000   000  000  00000000  000   000
    #    000        000          000           000   000  000  000       000 0 000
    #    000  0000  0000000      000            000 000   000  0000000   000000000
    #    000   000  000          000              000     000  000       000   000
    #     0000000   00000000     000               0      000  00000000  00     00

    getView: (id) ->
        node = @nodeMap[id]
        return node.view if node
        null








    #    00000000   00000000   000  000   000   0000000   000000000  00000000
    #    000   000  000   000  000  000   000  000   000     000     000     
    #    00000000   0000000    000   000 000   000000000     000     0000000 
    #    000        000   000  000     000     000   000     000     000     
    #    000        000   000  000      0      000   000     000     00000000




    #     0000000  00000000   00000000   0000000   000000000  00000000
    #    000       000   000  000       000   000     000     000
    #    000       0000000    0000000   000000000     000     0000000
    #    000       000   000  000       000   000     000     000
    #     0000000  000   000  00000000  000   000     000     00000000


    createNode: (cfg, parent) ->
        cfg  = makeCfg cfg
        node =
            id:         ++__id__ #Date.now() + '_' + Math.random()
            kind:       cfg.kind
            type:       cfg.type
            parent:     parent
            root:       parent.root
            depth:      parent.depth + 1
            parentComp: parent.comp  # sets the host comp for all none comp children. will be overridden if node has its own comp
            #tag:        null
            #attrs:      {}
            #events:     []
            #children:   []
            #view:       null
            #comp:       null

        #console.log 'create node: ', node.depth

        cfg          = createView node, cfg
        id           = node.id
        @nodeMap[id] = node
        @updateProperties(node, cfg.props) if node.tag # excludes text nodes
        node




    #    000   000  00000000   0000000     0000000   000000000  00000000        00000000   00000000    0000000   00000000    0000000
    #    000   000  000   000  000   000  000   000     000     000             000   000  000   000  000   000  000   000  000
    #    000   000  00000000   000   000  000000000     000     0000000         00000000   0000000    000   000  00000000   0000000
    #    000   000  000        000   000  000   000     000     000             000        000   000  000   000  000             000
    #     0000000   000        0000000    000   000     000     00000000        000        000   000   0000000   000        0000000

    updateProperties: (node, props) ->

        return null if node.kind == TEXT

        if isString props
            props = children:[props]

        attrs   = node.attrs or node.attrs = {}
        propMap = Object.assign {}, node.attrs, props or {}, node.events or {}
        for name of propMap
            attr  = attrs[name]
            value = props[name]
            bool  = isBool(attr) or isBool(value)
            switch true
                when bool                then @updateBool     node, value, name
                when name == 'children'  then @updateChildren node, value
                when name == 'style'     then @updateStyle    node, value
                when name == 'className' then @updateClass    node, value
                when /^on/.test name     then @updateEvent    node, value, name
                else
                    @updateAttr node, value, name
        null




    #     0000000   000000000  000000000  00000000    0000000
    #    000   000     000        000     000   000  000
    #    000000000     000        000     0000000    0000000
    #    000   000     000        000     000   000       000
    #    000   000     000        000     000   000  0000000

    updateAttr: (node, value, name) ->
        return if node.attrs[name] == value
        if value != null and value != undefined
            node.view.setAttribute name, value
            node.view[name]  = value
            node.attrs[name] = value
        else
            node.view.removeAttribute name
            delete node.view[name]
            delete node.attrs[name]
        null




    #     0000000  000       0000000    0000000   0000000
    #    000       000      000   000  000       000
    #    000       000      000000000  0000000   0000000
    #    000       000      000   000       000       000
    #     0000000  0000000  000   000  0000000   0000000

    updateClass: (node, value) ->
        return if node.attrs.className == value
        if value
            node.view.setAttribute 'class', value
            node.attrs.className = value
        else
            node.view.removeAttribute 'class'
            delete node.attrs.className
        null




    #     0000000  000000000  000   000  000      00000000
    #    000          000      000 000   000      000
    #    0000000      000       00000    000      0000000
    #         000     000        000     000      000
    #    0000000      000        000     0000000  00000000

    updateStyle: (node, style) ->
        view  = node.view
        attrs = node.attrs
        sobj  = attrs.style
        return null if style == sobj

        if isNull style
            view.style.cssText = null
            delete attrs.style

        else if isString style
            view.style.cssText = style
            attrs.style        = style
        else
            css     = ''
            sobj    = if isObject(sobj) then sobj else {}
            changed = false
            propMap = Object.assign {}, style, sobj
            for name of propMap
                value = style[name]
                if value != sobj[name]
                    changed = true
                sobj[name] = value
                if isNull value
                    delete sobj[name]
                else
                    prop  = normalizeName name
                    css  += prop + ': ' + value + '; '

            if changed
                if css.length
                    css                = css.slice 0, -1
                    view.style.cssText = css
                    attrs.style        = sobj
                else
                    view.style.cssText = null
                    delete attrs.style
        null




    #    0000000     0000000    0000000   000
    #    000   000  000   000  000   000  000
    #    0000000    000   000  000   000  000
    #    000   000  000   000  000   000  000
    #    0000000     0000000    0000000   0000000

    updateBool: (node, value, name) ->
        return if node.attrs[name] == value
        view = node.view
        if isNull value
            view.removeAttribute name
            delete node.attrs[name]
        else
            node.attrs[name] = value
            if value
                view.setAttribute name, ''
                view[name] = true
            else
                view.removeAttribute name
                view[name] = false
        null




    #    00000000  000   000  00000000  000   000  000000000   0000000
    #    000       000   000  000       0000  000     000     000
    #    0000000    000 000   0000000   000 0 000     000     0000000
    #    000          000     000       000  0000     000          000
    #    00000000      0      00000000  000   000     000     0000000

    updateEvent: (node, callback, name) ->
        events    = node.events or node.events = {}
        view      = node.view
        type      = normalizeEvent name
        listener  = events[name]
        if listener != callback
            if listener
                view.removeEventListener(type, listener)
                delete events[name]
            if callback
                view.addEventListener(type, callback)
                events[name] = callback
        null


    removeEvents: (node) ->
        events = node.events
        return null if not events

        view = node.view
        for name, listener of events
            type = normalizeEvent name
            view.removeEventListener(type, listener) if listener
            delete events[name]
        node.events = null
        null




    #     0000000  000   000  000  000      0000000    00000000   00000000  000   000
    #    000       000   000  000  000      000   000  000   000  000       0000  000
    #    000       000000000  000  000      000   000  0000000    0000000   000 0 000
    #    000       000   000  000  000      000   000  000   000  000       000  0000
    #     0000000  000   000  000  0000000  0000000    000   000  00000000  000   000

    updateChildren: (node, cfgs) ->
        children = node.children or node.children = []
        cfgs     = cfgs or []
        l        = if children.length > cfgs.length then children.length else cfgs.length
        for i in [0...l]
            child = children[i]
            cfg   = cfgs[i]

            if not child and isNull cfg
                throw new Error "DOM ERROR: either child or cfg at index #{i} must be defined. Got " + child + ', ' + cfg
            if not child
                @addChild node, cfg
            else if isNull cfg
                @removeChild child
            else
                @change child, makeCfg cfg
        children.length = cfgs.length
        null




    #     0000000  000   000   0000000   000   000   0000000   00000000  0000000
    #    000       000   000  000   000  0000  000  000        000       000   000
    #    000       000000000  000000000  000 0 000  000  0000  0000000   000   000
    #    000       000   000  000   000  000  0000  000   000  000       000   000
    #     0000000  000   000  000   000  000   000   0000000   00000000  0000000

    change: (node, cfg) ->

        if node.kind != cfg.kind or node.type != cfg.type
            @replaceChild node, cfg

        else if node.kind == TEXT
            if node.attrs          != cfg.props
                node.attrs          = cfg.props
                node.view.nodeValue = cfg.props

        else if node.kind == TAG
            if node.tag != cfg.type
                @replaceChild node, cfg
            else
                @updateProperties node, cfg.props

            ###
            else if node.kind == FUNC
                funcCfg = makeCfg cfg.type(cfg.props)
                if node.tag != funcCfg.type
                    @replaceChild node, cfg
                else
                    @updateProperties node, funcCfg.props
            ###
        else if node.kind == CLASS
            if node.comp.updateProps cfg.props # if true is returned we try updating properties and keep the node
                cfg = makeCfg node.comp.render()
                @updateProperties node, cfg.props
            else
                #TODO: maybe replace without further checks
                compProps = node.comp.props
                cfgProps  = cfg.props or {}
                return false if compProps == cfgProps # props are equal so a property update should be sufficient
                propMap = Object.assign {}, compProps, cfgProps
                #TODO: provide a optional deeper compare somehow
                for name of propMap
                    if compProps[name] != cfgProps[name]
                        @replaceChild node, cfg
                        break
        false




    #     0000000   0000000    0000000
    #    000   000  000   000  000   000
    #    000000000  000   000  000   000
    #    000   000  000   000  000   000
    #    000   000  0000000    0000000

    addChild: (node, cfg) ->
        #console.log 'addChild: ', cfg
        child = @createNode cfg, node
        node.children.push child
        node.view.appendChild child.view
        child.comp.onMount() if child.comp
        null




    #    00000000   00000000  00     00   0000000   000   000  00000000
    #    000   000  000       000   000  000   000  000   000  000
    #    0000000    0000000   000000000  000   000   000 000   0000000
    #    000   000  000       000 0 000  000   000     000     000
    #    000   000  00000000  000   000   0000000       0      00000000

    removeChild: (child) ->
        node = child.parent
        @disposeNode child
        node.view.removeChild child.view
        null




    #    00000000   00000000  00000000   000       0000000    0000000  00000000
    #    000   000  000       000   000  000      000   000  000       000
    #    0000000    0000000   00000000   000      000000000  000       0000000
    #    000   000  000       000        000      000   000  000       000
    #    000   000  00000000  000        0000000  000   000   0000000  00000000

    replaceChild: (child, cfg) ->
        #console.log 'DOM.replaceChild: ', child, cfg
        node     = child.parent
        children = node.children
        i        = children.indexOf child
        view     = child.view
        #console.log 'DOM.replaceChild: remove = ', i, child, cfg, children
        @disposeNode child

        child        = @createNode cfg, node
        children[i]  = child
        node.view.replaceChild child.view, view
        child.comp.onMount() if child.comp
        #console.log 'DOM.replaceChild: create = ', child, cfg
        null




    #    0000000    000   0000000  00000000    0000000    0000000  00000000
    #    000   000  000  000       000   000  000   000  000       000
    #    000   000  000  0000000   00000000   000   000  0000000   0000000
    #    000   000  000       000  000        000   000       000  000
    #    0000000    000  0000000   000         0000000   0000000   00000000

    disposeNode: (node) ->
        delete @nodeMap[node.id]
        return null if node.kind == TEXT

        if node.kind == CLASS
            node.comp.onWillUnmount()
            #console.log 'remove comp: ', node.comp

        @removeEvents node

        children = node.children
        if children
            for child in children
                @disposeNode child
        null




    #    00000000   00000000  00000000   00000000   0000000   00000000   00     00
    #    000   000  000       000   000  000       000   000  000   000  000   000
    #    00000000   0000000   0000000    000000    000   000  0000000    000000000
    #    000        000       000   000  000       000   000  000   000  000 0 000
    #    000        00000000  000   000  000        0000000   000   000  000   000

    performUpdate: () ->
        @dirty = false
        #TODO: sort by depth to update top down
        nodes = []
        #t = Date.now()
        nodes.push(@nodeMap[id]) for id of @dirtyMap
        nodes.sort (a, b) -> a.depth - b.depth
        #console.log 'performeUpdate: ', nodes
        for node in nodes
            continue if not node
            comp = node.comp
            if not comp
                console.error s = "DOM ERROR: only component nodes can update. Node with id = #{id} hasn't a component. ", node
                throw new Error s

            delete @dirtyMap[node.id]
            cfg = makeCfg comp.render()
            #TODO: This removes a component if the kind swaps between text and tag or between different tags. Maybe we can keep the component somehow!!!
            #TODO: Maybe ask the component, if it wants to be updated or replaced (like change method does)
            #TODO: We definitly want to keep the component!!!
            if node.tag != cfg.type
                @replaceChild node,
                    type:  node.type
                    props: node.comp.props
            else
                @updateProperties node, cfg.props
        #console.log 'performUpdate tooks: ', (Date.now() - t)
        null




    #    000000000  000   0000000  000   000
    #       000     000  000       000  000 
    #       000     000  000       0000000  
    #       000     000  000       000  000 
    #       000     000   0000000  000   000

    tick: () =>
        window.requestAnimationFrame @tick
        @performUpdate() if @dirty
        null








#    00000000    0000000   00000000
#    000   000  000   000  000     
#    0000000    000000000  000000  
#    000   000  000   000  000     
#    000   000  000   000  000     

if typeof window != 'undefined'
    lastTime = 0
    vendors  = ['webkit', 'moz']
    for vendor in vendors
        break if window.requestAnimationFrame
        window.requestAnimationFrame = window[vendor + 'RequestAnimationFrame']
        window.cancelAnimationFrame  = window[vendor + 'CancelAnimationFrame' ] || window[vendor + 'CancelRequestAnimationFrame']


    if not window.requestAnimationFrame
        window.requestAnimationFrame = (callback) ->
            currTime   = new Date().getTime()
            timeToCall = Math.max 0, 16 - currTime + lastTime
            rAF        = () -> callback currTime + timeToCall
            id         = window.setTimeout rAF, timeToCall
            lastTime   = currTime + timeToCall
            id


    if not window.cancelAnimationFrame
        window.cancelAnimationFrame = (id) ->
            clearTimeout id
            null




#     0000000    0000000   0000000  000   0000000   000   000
#    000   000  000       000       000  000        0000  000
#    000000000  0000000   0000000   000  000  0000  000 0 000
#    000   000       000       000  000  000   000  000  0000
#    000   000  0000000   0000000   000   0000000   000   000

if typeof Object.assign == 'undefined'
    Object.assign = (target, args...) ->
        for src in args
            for key of src
                target[key] = src[key];
        target








#    0000000     0000000   00     00
#    000   000  000   000  000   000
#    000   000  000   000  000000000
#    000   000  000   000  000 0 000
#    0000000     0000000   000   000

dom = new VirtualDOM()
DOM =
    Base:   BaseComponent
    TEXT:   TEXT
    TAG:    TAG
    FUNC:   FUNC
    CLASS:  CLASS

    tree:          null
    TreeComponent: null

    isBool:   isBool
    isString: isString
    isNull:   isNull
    isObject: isObject
    isFunc:   isFunc
    isClass:  isClass
    isHTML:   isHTML
    isNode:   isNode
    isComp:   isComp

    create:  (type, props, kind) -> dom.create  type, props, kind
    render:  (cfg, host)         -> dom.render  cfg, host
    remove:  (host)              -> dom.remove  host
    update:  (id)                -> dom.update  id
    getView: (id)                -> dom.getView id


if typeof module != 'undefined'
    module.exports = DOM
if typeof window != 'undefined'
    window.DOM = DOM
else
    this.DOM = DOM