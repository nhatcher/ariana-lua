mergeInto(LibraryManager.library, {
  set_point: function(x, y) {
    Module.print(`x=${x}, y=${y}`);
  },
  draw_function: function(p_datax, p_datay, len, min, max) {
    Module.draw_function(p_datax, p_datay, len, min, max);
  }
});