
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
    draw_function: function(p_str, len) {
      const utf8decoder = new TextDecoder();
      const options = JSON.parse(utf8decoder.decode(Module.HEAP8.slice(p_str, p_str + len)));
      plotter('plot-canvas', options);
    }
  });

  function text_changed() {
    const input = editor.getValue();
    console.time('compute');
    Module.ccall("run_lua", 'number', ['string'], [input]);
    console.timeEnd('compute');
  };

  editor.on('change', () => {
    text_changed();
  });
}