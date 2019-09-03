
function entry(event, plot_area, editor) {
  const Module = luaWASM({
    // onRuntimeInitialized: text_changed,
    postRun: [
      text_changed
    ],
    // instantiateWasm: function(inports, callback) {

    // },
    print: function () {
      console.log(...arguments);
    },
    printErr: function () {
      console.error(...arguments);
    },
    draw_function: function(p_datax, p_datay, len, min, max, xmin, xmax, p_color, len_color) {
      const utf8decoder = new TextDecoder();
      const datax = Module.HEAPF64.slice(p_datax/8, p_datax/8 + len);
      const datay = Module.HEAPF64.slice(p_datay/8, p_datay/8 + len);
      const color = utf8decoder.decode(Module.HEAP8.slice(p_color, p_color + len_color));
      console.log(color, p_color, len_color);
      plotter('plot-canvas', {
        data: [{
          datax: datax, 
          datay: datay,
          options: {
            color: color,
            width: 2
          }
        }],
        ymin: min,
        ymax: max,
        xrange: [xmin, xmax],
        padding: {
          left: 10,
          right: 10,
          top: 10,
          bottom: 10
        },
        gridcolor: '#ccc',
        gridwidth: 1,
        axiscolor: 'blue',
        axiswidth: 1
      });
    }
  });

  function text_changed() {
    const input = editor.getValue();
    console.time('compute');
    Module.ccall("run_lua", 'number', ['string'], [input]);
    console.timeEnd('compute');
  }
  editor.on('change', () => {
    text_changed();
  })
  window.__ww = Module
}