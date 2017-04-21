// Generated by CoffeeScript 1.12.5
(function() {
  var List, Map, State, immutable;

  immutable = require('immutable');

  Map = immutable.Map;

  List = immutable.List;

  State = (function() {
    function State(editor) {
      this.editor = editor;
      this.data = Map({
        mainCursor: 0,
        maxCols: 0,
        lines: List(),
        selections: List(),
        cursors: List([
          Map({
            col: 0,
            row: 0
          })
        ])
      });
      this.pointer = 0;
      this.history = [];
      console.log('State.constructor: ', this, this.getIn(['cursors', 0, 'col']));
    }

    State.prototype.get = function(key) {
      return this.data.get(key);
    };

    State.prototype.getIn = function(keys) {
      return this.data.getIn(keys);
    };

    State.prototype.set = function(key, value) {
      return this.data = this.data.set(key, value);
    };

    State.prototype.setIn = function(keys, value) {
      return this.data = this.data.setIn(keys, value);
    };

    State.prototype.step = function() {
      return this;
    };

    State.prototype.undo = function() {
      return this;
    };

    State.prototype.redo = function() {
      return this;
    };

    return State;

  })();

  module.exports = State;

}).call(this);

//# sourceMappingURL=state.js.map
