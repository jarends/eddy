// Generated by CoffeeScript 1.11.1
(function() {
  var Line;

  Line = (function() {
    function Line(editor) {
      this.editor = editor;
      this.view = document.createElement('span');
      this.view.className = 'line';
    }

    Line.prototype.update = function(data) {
      if (this.text !== data.text) {
        this.text = this.view.innerHTML = data.text;
      }
      return null;
    };

    return Line;

  })();

  module.exports = Line;

}).call(this);

//# sourceMappingURL=line.js.map