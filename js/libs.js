mergeInto(LibraryManager.library, {
  set_point: function(x, y) {
    Module.print(`x=${x}, y=${y}`);
  },
  draw_function: function(str, len) {
    Module.draw_function(str, len);
  },
  slider: function(str, len) {
    Module.slider(str, len);
  },
  checkbox: function(str, len) {
    Module.checkbox(str, len);
  }
});