(function() {
  var BaseComponent, CLASS, DOM, FUNC, TAG, TEXT, VirtualDOM, __id__, createClassView, createFuncView, createTagView, createTextView, createView, dom, factory, isBool, isClass, isComp, isFunc, isHTML, isNode, isNull, isNumber, isObject, isSimple, isString, j, lastTime, len, makeCfg, normalizeEvent, normalizeName, vendor, vendors,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  __id__ = 0;

  TEXT = 0;

  TAG = 1;

  FUNC = 2;

  CLASS = 3;

  isBool = function(value) {
    return typeof value === 'boolean';
  };

  isNumber = function(value) {
    return typeof value === 'number';
  };

  isString = function(value) {
    return typeof value === 'string' || value === value + '';
  };

  isNull = function(value) {
    return value === null || value === void 0;
  };

  isObject = function(value) {
    return value !== null && typeof value === 'object';
  };

  isFunc = function(value) {
    return value !== null && typeof value === 'function';
  };

  isClass = function(value) {
    return value !== null && value.prototype && !!value.prototype.render;
  };

  isHTML = function(value) {
    return value instanceof HTMLElement;
  };

  isNode = function(value) {
    return value && value.root && value.root.children && value.root.children[0] === value;
  };

  isComp = function(value) {
    return value instanceof BaseComponent;
  };

  isSimple = function(value) {
    return typeof value === 'string' || typeof value === 'number' || typeof value === 'boolean';
  };

  normalizeName = function(name) {
    return name.replace(/[A-Z]/g, function(name) {
      return '-' + name.toLowerCase();
    });
  };

  normalizeEvent = function(type) {
    type = type.slice(2);
    return type.charAt(0).toLowerCase() + normalizeName(type.slice(1));
  };

  makeCfg = function(cfg) {
    var kind, props, type;
    if (!isNull(cfg.kind)) {
      return cfg;
    }
    if (isSimple(cfg)) {
      cfg = {
        type: null,
        props: cfg + '',
        kind: TEXT
      };
      return cfg;
    }
    props = cfg.props;
    type = cfg.type;
    if (isSimple(props)) {
      props = {
        children: [props + '']
      };
    }
    switch (true) {
      case isString(type):
        kind = TAG;
        break;
      case isClass(type):
        kind = CLASS;
        break;
      case isFunc(type):
        kind = FUNC;
        break;
      default:
        throw new Error('DOM ERROR: unknown node kind for cfg: ' + cfg);
    }
    cfg.kind = kind;
    return cfg;
  };

  createTextView = function(node, cfg) {
    node.attrs = cfg.props;
    node.view = document.createTextNode(cfg.props);
    return cfg;
  };

  createTagView = function(node, cfg) {
    node.tag = cfg.type;
    node.view = document.createElement(cfg.type);
    return cfg;
  };

  createFuncView = function(node, cfg) {
    return createTagView(node, cfg.type(cfg.props));
  };

  createClassView = function(node, cfg) {
    var comp;
    comp = new cfg.type(cfg.props);
    comp.id = node.id;
    node.comp = comp;
    cfg = comp.render();
    if (isSimple(cfg)) {
      node.attrs = cfg + '';
      node.view = document.createTextNode(cfg + '');
    } else {
      createTagView(node, cfg);
      comp.view = node.view;
    }
    return cfg;
  };

  factory = [createTextView, createTagView, createFuncView, createClassView];

  createView = function(node, cfg) {
    return factory[cfg.kind](node, cfg);
  };

  BaseComponent = (function() {
    function BaseComponent(props1) {
      this.props = props1;
    }

    BaseComponent.prototype.update = function() {
      return DOM.update(this.id);
    };

    BaseComponent.prototype.render = function() {};

    BaseComponent.prototype.updateProps = function(props) {
      return false;
    };

    BaseComponent.prototype.onMount = function() {};

    BaseComponent.prototype.onWillUnmount = function() {};

    BaseComponent.prototype.onRender = function() {
      return console.log('comp.onRender: ', this);
    };

    return BaseComponent;

  })();

  VirtualDOM = (function() {
    function VirtualDOM() {
      this.tick = bind(this.tick, this);
      this.nodeMap = {};
      this.dirtyMap = {};
      this.rootMap = {};
      if (typeof window !== 'undefined') {
        window.requestAnimationFrame(this.tick);
      }
    }

    VirtualDOM.prototype.create = function(type, props, kind) {
      return {
        type: type,
        props: props,
        kind: kind
      };
    };

    VirtualDOM.prototype.render = function(cfg, host, ctx) {
      var node, root, t;
      root = {
        kind: TAG,
        view: host,
        depth: -1,
        ctx: ctx
      };
      t = Date.now();
      root.root = root;
      node = this.createNode(cfg, root);
      root.id = node.id;
      root.children = [node];
      this.rootMap[node.id] = root;
      host.appendChild(node.view);
      if (node.comp) {
        node.comp.onMount();
      }
      console.log('render tooks: ', Date.now() - t);
      return node;
    };

    VirtualDOM.prototype.remove = function(hostOrRootOrNodeOrComp) {
      var comp, host, id, node, ref, root;
      host = hostOrRootOrNodeOrComp;
      root = hostOrRootOrNodeOrComp;
      node = hostOrRootOrNodeOrComp;
      comp = hostOrRootOrNodeOrComp;
      if (isHTML(host)) {
        ref = this.rootMap;
        for (id in ref) {
          root = ref[id];
          if (root.view === host) {
            break;
          }
        }
      } else if (isNode(node)) {
        root = this.rootMap[node.id];
      } else if (isComp(comp)) {
        root = this.rootMap[comp.id];
      }
      if (!root) {
        return false;
      }
      host = root.view;
      node = root.children[0];
      this.disposeNode(node);
      host.removeChild(node.view);
      delete this.rootMap[node.id];
      return true;
    };

    VirtualDOM.prototype.update = function(id) {
      if (!this.nodeMap[id]) {
        return;
      }
      this.dirtyMap[id] = true;
      this.dirty = true;
      return null;
    };

    VirtualDOM.prototype.getView = function(id) {
      var node;
      node = this.nodeMap[id];
      if (node) {
        return node.view;
      }
      return null;
    };

    VirtualDOM.prototype.createNode = function(cfg, parent) {
      var id, node;
      cfg = makeCfg(cfg);
      node = {
        id: ++__id__,
        kind: cfg.kind,
        type: cfg.type,
        parent: parent,
        root: parent.root,
        depth: parent.depth + 1,
        parentComp: parent.comp
      };
      cfg = createView(node, cfg);
      id = node.id;
      this.nodeMap[id] = node;
      if (node.tag) {
        this.updateProperties(node, cfg.props);
      }
      return node;
    };

    VirtualDOM.prototype.updateProperties = function(node, props) {
      var attr, attrs, bool, name, propMap, value;
      if (node.kind === TEXT) {
        return null;
      }
      if (isString(props)) {
        props = {
          children: [props]
        };
      }
      attrs = node.attrs || (node.attrs = {});
      propMap = Object.assign({}, node.attrs, props || {}, node.events || {});
      for (name in propMap) {
        attr = attrs[name];
        value = props[name];
        bool = isBool(attr) || isBool(value);
        switch (true) {
          case bool:
            this.updateBool(node, value, name);
            break;
          case name === 'children':
            this.updateChildren(node, value);
            break;
          case name === 'style':
            this.updateStyle(node, value);
            break;
          case name === 'className':
            this.updateClass(node, value);
            break;
          case /^on/.test(name):
            this.updateEvent(node, value, name);
            break;
          default:
            this.updateAttr(node, value, name);
        }
      }
      return null;
    };

    VirtualDOM.prototype.updateAttr = function(node, value, name) {
      if (node.attrs[name] === value) {
        return;
      }
      if (value !== null && value !== void 0) {
        node.view.setAttribute(name, value);
        node.view[name] = value;
        node.attrs[name] = value;
      } else {
        node.view.removeAttribute(name);
        delete node.view[name];
        delete node.attrs[name];
      }
      return null;
    };

    VirtualDOM.prototype.updateClass = function(node, value) {
      if (node.attrs.className === value) {
        return;
      }
      if (value) {
        node.view.setAttribute('class', value);
        node.attrs.className = value;
      } else {
        node.view.removeAttribute('class');
        delete node.attrs.className;
      }
      return null;
    };

    VirtualDOM.prototype.updateStyle = function(node, style) {
      var attrs, changed, css, name, prop, propMap, sobj, value, view;
      view = node.view;
      attrs = node.attrs;
      sobj = attrs.style;
      if (style === sobj) {
        return null;
      }
      if (isNull(style)) {
        view.style.cssText = null;
        delete attrs.style;
      } else if (isString(style)) {
        view.style.cssText = style;
        attrs.style = style;
      } else {
        css = '';
        sobj = isObject(sobj) ? sobj : {};
        changed = false;
        propMap = Object.assign({}, style, sobj);
        for (name in propMap) {
          value = style[name];
          if (value !== sobj[name]) {
            changed = true;
          }
          sobj[name] = value;
          if (isNull(value)) {
            delete sobj[name];
          } else {
            prop = normalizeName(name);
            css += prop + ': ' + value + '; ';
          }
        }
        if (changed) {
          if (css.length) {
            css = css.slice(0, -1);
            view.style.cssText = css;
            attrs.style = sobj;
          } else {
            view.style.cssText = null;
            delete attrs.style;
          }
        }
      }
      return null;
    };

    VirtualDOM.prototype.updateBool = function(node, value, name) {
      var view;
      if (node.attrs[name] === value) {
        return;
      }
      view = node.view;
      if (isNull(value)) {
        view.removeAttribute(name);
        delete node.attrs[name];
      } else {
        node.attrs[name] = value;
        if (value) {
          view.setAttribute(name, '');
          view[name] = true;
        } else {
          view.removeAttribute(name);
          view[name] = false;
        }
      }
      return null;
    };

    VirtualDOM.prototype.updateEvent = function(node, callback, name) {
      var events, listener, type, view;
      events = node.events || (node.events = {});
      view = node.view;
      type = normalizeEvent(name);
      listener = events[name];
      if (listener !== callback) {
        if (listener) {
          view.removeEventListener(type, listener);
          delete events[name];
        }
        if (callback) {
          view.addEventListener(type, callback);
          events[name] = callback;
        }
      }
      return null;
    };

    VirtualDOM.prototype.removeEvents = function(node) {
      var events, listener, name, type, view;
      events = node.events;
      if (!events) {
        return null;
      }
      view = node.view;
      for (name in events) {
        listener = events[name];
        type = normalizeEvent(name);
        if (listener) {
          view.removeEventListener(type, listener);
        }
        delete events[name];
      }
      node.events = null;
      return null;
    };

    VirtualDOM.prototype.updateChildren = function(node, cfgs) {
      var cfg, child, children, i, j, l, ref;
      children = node.children || (node.children = []);
      cfgs = cfgs || [];
      l = children.length > cfgs.length ? children.length : cfgs.length;
      for (i = j = 0, ref = l; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
        child = children[i];
        cfg = cfgs[i];
        if (!child && isNull(cfg)) {
          throw new Error(("DOM ERROR: either child or cfg at index " + i + " must be defined. Got ") + child + ', ' + cfg);
        }
        if (!child) {
          this.addChild(node, cfg);
        } else if (isNull(cfg)) {
          this.removeChild(child);
        } else {
          this.change(child, makeCfg(cfg));
        }
      }
      children.length = cfgs.length;
      return null;
    };

    VirtualDOM.prototype.change = function(node, cfg) {
      var cfgProps, compProps, name, propMap;
      if (node.kind !== cfg.kind || node.type !== cfg.type) {
        this.replaceChild(node, cfg);
      } else if (node.kind === TEXT) {
        if (node.attrs !== cfg.props) {
          node.attrs = cfg.props;
          node.view.nodeValue = cfg.props;
        }
      } else if (node.kind === TAG) {
        if (node.tag !== cfg.type) {
          this.replaceChild(node, cfg);
        } else {
          this.updateProperties(node, cfg.props);
        }

        /*
        else if node.kind == FUNC
            funcCfg = makeCfg cfg.type(cfg.props)
            if node.tag != funcCfg.type
                @replaceChild node, cfg
            else
                @updateProperties node, funcCfg.props
         */
      } else if (node.kind === CLASS) {
        if (node.comp.updateProps(cfg.props)) {
          cfg = makeCfg(node.comp.render());
          this.updateProperties(node, cfg.props);
        } else {
          compProps = node.comp.props;
          cfgProps = cfg.props || {};
          if (compProps === cfgProps) {
            return false;
          }
          propMap = Object.assign({}, compProps, cfgProps);
          for (name in propMap) {
            if (compProps[name] !== cfgProps[name]) {
              this.replaceChild(node, cfg);
              break;
            }
          }
        }
      }
      return false;
    };

    VirtualDOM.prototype.addChild = function(node, cfg) {
      var child;
      child = this.createNode(cfg, node);
      node.children.push(child);
      node.view.appendChild(child.view);
      if (child.comp) {
        child.comp.onMount();
      }
      return null;
    };

    VirtualDOM.prototype.removeChild = function(child) {
      var node;
      node = child.parent;
      this.disposeNode(child);
      node.view.removeChild(child.view);
      return null;
    };

    VirtualDOM.prototype.replaceChild = function(child, cfg) {
      var children, i, node, view;
      node = child.parent;
      children = node.children;
      i = children.indexOf(child);
      view = child.view;
      this.disposeNode(child);
      child = this.createNode(cfg, node);
      children[i] = child;
      node.view.replaceChild(child.view, view);
      if (child.comp) {
        child.comp.onMount();
      }
      return null;
    };

    VirtualDOM.prototype.disposeNode = function(node) {
      var child, children, j, len;
      delete this.nodeMap[node.id];
      if (node.kind === TEXT) {
        return null;
      }
      if (node.kind === CLASS) {
        node.comp.onWillUnmount();
      }
      this.removeEvents(node);
      children = node.children;
      if (children) {
        for (j = 0, len = children.length; j < len; j++) {
          child = children[j];
          this.disposeNode(child);
        }
      }
      return null;
    };

    VirtualDOM.prototype.performUpdate = function() {
      var cfg, comp, id, j, len, node, nodes, s;
      this.dirty = false;
      nodes = [];
      for (id in this.dirtyMap) {
        nodes.push(this.nodeMap[id]);
      }
      nodes.sort(function(a, b) {
        return a.depth - b.depth;
      });
      for (j = 0, len = nodes.length; j < len; j++) {
        node = nodes[j];
        if (!node) {
          continue;
        }
        comp = node.comp;
        if (!comp) {
          console.error(s = "DOM ERROR: only component nodes can update. Node with id = " + id + " hasn't a component. ", node);
          throw new Error(s);
        }
        delete this.dirtyMap[node.id];
        cfg = makeCfg(comp.render());
        if (node.tag !== cfg.type) {
          this.replaceChild(node, {
            type: node.type,
            props: node.comp.props
          });
        } else {
          this.updateProperties(node, cfg.props);
        }
      }
      return null;
    };

    VirtualDOM.prototype.tick = function() {
      window.requestAnimationFrame(this.tick);
      if (this.dirty) {
        this.performUpdate();
      }
      return null;
    };

    return VirtualDOM;

  })();

  if (typeof window !== 'undefined') {
    lastTime = 0;
    vendors = ['webkit', 'moz'];
    for (j = 0, len = vendors.length; j < len; j++) {
      vendor = vendors[j];
      if (window.requestAnimationFrame) {
        break;
      }
      window.requestAnimationFrame = window[vendor + 'RequestAnimationFrame'];
      window.cancelAnimationFrame = window[vendor + 'CancelAnimationFrame'] || window[vendor + 'CancelRequestAnimationFrame'];
    }
    if (!window.requestAnimationFrame) {
      window.requestAnimationFrame = function(callback) {
        var currTime, id, rAF, timeToCall;
        currTime = new Date().getTime();
        timeToCall = Math.max(0, 16 - currTime + lastTime);
        rAF = function() {
          return callback(currTime + timeToCall);
        };
        id = window.setTimeout(rAF, timeToCall);
        lastTime = currTime + timeToCall;
        return id;
      };
    }
    if (!window.cancelAnimationFrame) {
      window.cancelAnimationFrame = function(id) {
        clearTimeout(id);
        return null;
      };
    }
  }

  if (typeof Object.assign === 'undefined') {
    Object.assign = function() {
      var args, k, key, len1, src, target;
      target = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      for (k = 0, len1 = args.length; k < len1; k++) {
        src = args[k];
        for (key in src) {
          target[key] = src[key];
        }
      }
      return target;
    };
  }

  dom = new VirtualDOM();

  DOM = {
    Base: BaseComponent,
    TEXT: TEXT,
    TAG: TAG,
    FUNC: FUNC,
    CLASS: CLASS,
    tree: null,
    TreeComponent: null,
    isBool: isBool,
    isString: isString,
    isNull: isNull,
    isObject: isObject,
    isFunc: isFunc,
    isClass: isClass,
    isHTML: isHTML,
    isNode: isNode,
    isComp: isComp,
    create: function(type, props, kind) {
      return dom.create(type, props, kind);
    },
    render: function(cfg, host) {
      return dom.render(cfg, host);
    },
    remove: function(host) {
      return dom.remove(host);
    },
    update: function(id) {
      return dom.update(id);
    },
    getView: function(id) {
      return dom.getView(id);
    }
  };

  if (typeof module !== 'undefined') {
    module.exports = DOM;
  }

  if (typeof window !== 'undefined') {
    window.DOM = DOM;
  } else {
    this.DOM = DOM;
  }

}).call(this);

//# sourceMappingURL=dom.js.map
