mergeInto(LibraryManager.library, {
  set_point: function(x, y) {
    Module.print(`x=${x}, y=${y}`);
  },
  draw_function: function(str, len) {
    Module.draw_function(str, len);
  },
  newCanvas: function(str, len) {
    Module.newCanvas(str, len);
  },
  slider: function(str, len) {
    Module.slider(str, len);
  },
  checkbox: function(str, len) {
    Module.checkbox(str, len);
  },
  set: function(canvasID, property, plen, value, vlen) {
    Module.canvas_set(canvasID, property, plen, value, vlen);
  },
  call: function(canvasID, name, nlen, values, vlen) {
    Module.canvas_call(canvasID, name, nlen, values, vlen);
  },
  canvasWidth: function(canvasID, p_result) {
    Module.canvas_width(canvasID, p_result);
  },
  canvasHeight: function(canvasID, p_result) {
    Module.canvas_height(canvasID, p_result);
  }
});