
function entry(event, editor) {
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
    draw_function: function(p_datax, p_datay, len, min, max) {
      const datax = Module.HEAPF64.slice(p_datax/8, p_datax/8 + len);
      const datay = Module.HEAPF64.slice(p_datay/8, p_datay/8 + len);
      console.log(datax);
      console.log(datay);
    }
  });

  function text_changed() {
    const input = editor.getValue();
    console.time('compute');
    Module.ccall("run_lua", 'number', ['string'], [input]);
    console.timeEnd('compute');
  }
}