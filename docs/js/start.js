
function start(event) {
    const plot_area = document.getElementById('plot-area');
    const script_area = document.getElementById('script-area');
    const output_area = document.getElementById('output-area');
    const editor = CodeMirror.fromTextArea(document.getElementById('script-area-edit'), {
      // matchBrackets: true,
      // theme: "neat"
      lineNumbers: true
    });
  
    const Module = luaWASM({
      // onRuntimeInitialized: refresh,
      postRun: [
        init
      ],
      // instantiateWasm: function(imports, callback) {
  
      // },
      print: function () {
        console.log(...arguments);
        for (let i=0; i<arguments.length; i++) {
          const el = document.createElement('div');
          el.innerText = arguments[i];
  
          output_area.appendChild(el);
        }
      },
      printErr: function () {
        console.error(...arguments);
      },
      draw_function: function(p_str, len) {
        const utf8decoder = new TextDecoder();
        const options = JSON.parse(utf8decoder.decode(Module.HEAP8.slice(p_str, p_str + len)));
        const div = document.createElement('div');
        div.style.position = "relative";
        div.style.height = "100%";
        const canvas = document.createElement('canvas');
        const plot_arena = plot_area.querySelector('.arena');
        plot_arena.appendChild(div);
        const horizontal_hint = document.createElement('div');
        horizontal_hint.classList.add('horizontal-hint');
        const vertical_hint = document.createElement('div');
        vertical_hint.classList.add('vertical-hint');
        div.appendChild(horizontal_hint);
        div.appendChild(vertical_hint);
        div.appendChild(canvas);
        const width = div.clientWidth;
        const height = div.clientHeight;
        const pixelRatio = window.devicePixelRatio;
        canvas.setAttribute('width', pixelRatio*width);
        canvas.setAttribute('height', pixelRatio*height);
        canvas.style.width = width + 'px';
        canvas.style.height = height + 'px';
        plotter(div, options);
      },
      newCanvas: function(p_str, len) {
        const utf8decoder = new TextDecoder();
        const options = JSON.parse(utf8decoder.decode(Module.HEAP8.slice(p_str, p_str + len)));
        const canvas = document.createElement('canvas');
        const div = document.createElement('div');
        const plot_arena = plot_area.querySelector('.arena');
        plot_arena.appendChild(div);
        div.appendChild(canvas);
        const width = (options.width === 'auto') ? div.clientWidth : parseFloat(options.width);
        const height = (options.height === 'auto') ? div.clientHeight: parseFloat(options.height);
        canvas.setAttribute('width', width);
        canvas.setAttribute('height', height);        
        const ctx = canvas.getContext('2d');
        ctx.clearRect(0, 0, width, height);
      },
      slider: function(p_str, len) {
        const utf8decoder = new TextDecoder();
        const options = JSON.parse(utf8decoder.decode(Module.HEAP8.slice(p_str, p_str + len)));
        const plot_arena = plot_area.querySelector('.arena');
        const wrapper = document.createElement('div');
        wrapper.classList.add('slider-wrapper');
        plot_arena.appendChild(wrapper);
        const span = document.createElement('span');
        wrapper.appendChild(span);
        wrapper.innerText = options['name'] + ' = ';
        const el = document.createElement('input');
        el.setAttribute('type', 'range');
        el.setAttribute('min', options['min']);
        el.setAttribute('max', options['max']);
        el.setAttribute('step', options['step']);
        el.setAttribute('name', options['name']);
        el.setAttribute('value', options['value']);
        el.classList.add('slider');
        wrapper.appendChild(el);
      },
      checkbox: function(p_str, len) {
        const utf8decoder = new TextDecoder();
        const options = JSON.parse(utf8decoder.decode(Module.HEAP8.slice(p_str, p_str + len)));
        console.log('checkbox', options);
      },
      canvas_set: function(canvasID, p_property, plen, p_value, vlen) {
        const utf8decoder = new TextDecoder();
        const property = utf8decoder.decode(Module.HEAP8.slice(p_property, p_property + plen));
        const value = utf8decoder.decode(Module.HEAP8.slice(p_value, p_value + vlen));
        const cnv = plot_area.querySelectorAll('canvas')[canvasID-1];
        const ctx = cnv.getContext('2d');
        ctx[property] = value;
      },
      canvas_call: function(canvasID, p_name, plen, p_values, vlen) {
        const utf8decoder = new TextDecoder();
        const name = utf8decoder.decode(Module.HEAP8.slice(p_name, p_name + plen));
        const values = JSON.parse(utf8decoder.decode(Module.HEAP8.slice(p_values, p_values + vlen)));
        const cnv = plot_area.querySelectorAll('canvas')[canvasID-1];
        const ctx = cnv.getContext('2d');
        if (name === 'putImageData') {
          const imageData = ctx.getImageData(0, 0, cnv.width, cnv.height);
          console.log(imageData.data.length, values[0].length);
          imageData.data = values[0];
          ctx.putImageData(imageData, 0, 0);
        } else {
          ctx[name](...values);
        }
      },
      fillRect: function(canvasID, x, y, dx, dy) {
        const cnv = plot_area.querySelectorAll('canvas')[canvasID-1];
        const ctx = cnv.getContext('2d');
        ctx.fillRect(x, y, dx, dy);
      },
      canvas_width: function(canvasID, p_width) {
        const cnv = plot_area.querySelectorAll('canvas')[canvasID-1];
        Module.HEAP32[p_width/4] = cnv.width;
      },
      canvas_height: function(canvasID, p_height) {
        const cnv = plot_area.querySelectorAll('canvas')[canvasID-1];
        Module.HEAP32[p_height/4] = cnv.height;
      }
    });
    function getPanelFromValue(panel_value) {
      switch(panel_value) {
        case 'script':
          return script_area;
        case 'plots':
          return plot_area;
        case 'output':
          return output_area;
        default:
          throw Error(`Invalid value: ${panel_value}`);
      }
    }
    function init() {
      function reset_geometry() {
        const panels = document.querySelectorAll('#selection li');
        let left = 0;
        let panel_count = document.querySelectorAll('#selection li.selected').length;
        const width = Math.floor(window.innerWidth/panel_count);
        panels.forEach(element => {
          const panel_value = element.getAttribute('value');
          let panel = getPanelFromValue(panel_value);
          if (element.classList.contains('selected')) {
            panel.style.display = 'block';
            panel.style.left = left + 'px';
            panel.style.width = width + 'px';
            left += width;
          } else {
            panel.style.display = 'none';
          }
        });
        resize();
      }
  
      function resize() {
        const script_arena = script_area.querySelector('.arena');
        editor.setSize(script_area.clientWidth, script_arena.clientHeight);
        refresh();
      }
  
      function getState(bKeepParameters) {
        const inputs = plot_area.querySelectorAll('input');
        sKeep = !!bKeepParameters ? 'True' : 'False';
        let state = 'plot.state = {}\n';
        state += `plot["keep_parameters"]=${!!bKeepParameters}\n`;
        for (let i=0; i<inputs.length; i++) {
          const input = inputs[i];
          const type = input.getAttribute('type');
          if (type === 'range') {
            const name = input.getAttribute('name');
            const value = input.value;
            state += `plot.state['${name}'] = ${value}\n`;
          }
        }
        return state.trim();
      }
  
      window.addEventListener('resize', resize, true);
      function refresh(bKeepParameters) {
        const input = getState(bKeepParameters) + '\n' + editor.getValue();
        console.time('compute');
        output_area.innerHTML = '';
        if (!bKeepParameters) {
          // plot_area.innerHTML = '';
        }
        plot_area.querySelector('.arena').innerHTML = '';
        Module.ccall("run_lua", 'number', ['string'], [input]);
        const first_canvas = plot_area.querySelector('canvas');
        if (first_canvas !== null) {
          first_canvas.classList.add('selected');
        }
        if (!bKeepParameters) {
          plot_area.addEventListener('input', () => {
            refresh(true);
          });
        }
        console.timeEnd('compute');
      };
  
      editor.on('change', () => {
        if (document.getElementById('script-life-checkbox').checked) {
          refresh();
        }
      });
      resize();
      /*dragElement(document.getElementById('script-area-handle'), (left) => {
        script_area.style.width = left + 'px';
        plot_area.style.left = left + 'px';
      }, () => {
        resize();
      });*/
      document.querySelector('#run-script-button').addEventListener('click', (e) => {
        refresh();
      });
      document.querySelector('#selection').addEventListener('click', (e) => {
        const target = e.target;
        if(target.classList.contains('button')) {
          target.classList.toggle('selected');
          reset_geometry();
        }
      });
    }
    const select = document.querySelector('#examples select');
    const examples_list = ['simple', 'bessel', 'canvas', 'mandelbrot', 'ode', 'odesol'];
    for (let i=0; i<examples_list.length; i++) {
      const el = document.createElement('option');
      const example_name = examples_list[i];
      el.setAttribute('value', example_name)
      el.innerText = example_name;
      select.appendChild(el);
    }
    function getExample(name, callback) {
      const file = `examples/${name}.lua`;
      fetch(file, {
        method: 'GET',
        headers: {
          'Content-Type': 'text/plain; charset=UTF-8',
        }
      }).then(response => {
        if (response.ok) {
          response.text().then(txt => {
            editor.setValue(txt);
            callback && callback();
          });
        }
      });
    }
    select.addEventListener('change', (_event) => {
      getExample(select.value, () => {
        // TODO: HACK!
        const run = document.getElementById('run-script-button');
        const event = new MouseEvent('click', {
          view: window,
          bubbles: true,
          cancelable: true
        });
        run.dispatchEvent(event);
      });
    });
    getExample(examples_list[0]); 
  };
  