mergeInto(LibraryManager.library, {
  set_point: function(x, y) {
    Module.print(`x=${x}, y=${y}`);
  },
  draw_function: function(p_datax, p_datay, len, ymin, ymax, xmin, xmax, p_color, len_color) {
    Module.draw_function(p_datax, p_datay, len, ymin, ymax, xmin, xmax, p_color, len_color);
  }
});