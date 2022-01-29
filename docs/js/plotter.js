const plotter = (function() {

  function getPrettyTicks(xmin, xmax, width) {
      // This function gives a hint of a good set of marks.
      var spacing = 50; // we guess that a nice spacing is ~ 20px;
      var tick_number = width/spacing; // aprox number of ticks
      var step = (xmax-xmin)/tick_number; // approx size of a step
      var s = step.toExponential();
      var expt = s.split('e')[1];
      // the step is going to be in multiples of 2, 5 or 10
      var firstdigit = parseInt(s[0], 10);
      if (firstdigit<=2) {
          step = parseFloat('2e' + expt);
      } else if(firstdigit<=5) {
          step = parseFloat('5e' + expt);
      } else {
          step = parseFloat('10e' + expt);
      }
      // Now we have the exact step, we look for the first multiple of the step
      var xstart = Math.floor(xmin/step)*(step);
      if (xstart < 0) {
          xstart += step;
      }
      var ticks = [];
      for (var x=xstart; x<xmax; x += step) {
          ticks.push(x);
      }
      return ticks;
  }
  function notifyPosition(x, y) {
      var info = document.getElementById('info');
      x = x.toPrecision(3);
      y = y.toPrecision(3);
      info.textContent = `x: ${x}, y: ${y}`;
  }
  function getSafeLabel(value, scale) {
      // returns a safe label for a number
      // 14.9999999  --> 15
      // If number is really close to zero, we check if the general scale
      // is close to zero
      var s = parseFloat(value.toPrecision(14));
      if (Math.abs(s)<1e-14 && scale>1e-10) {
          s = 0;
      }
      return s + '';
  }
  function plotter(wrapper, options) {
      const canvas = wrapper.getElementsByTagName('canvas')[0];
      const width = canvas.width;
      const height = canvas.height;
      const ctx = canvas.getContext('2d');
              // <div id="horizontal-hint"></div>
        // <div id="vertical-hint"></div>
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      const xmin = options.xmin;
      const xmax = options.xmax;
      const xwidth = xmax - xmin;
      const plotwidth = width - options.padding.left - options.padding.right;
      const xscale = plotwidth/xwidth;

      //let list = context['functions'];
      const data = options.data;
      const ymin = options.ymin;
      const ymax = options.ymax;

      if (options.ysoftmax) {
          ymax = Math.min(options.ysoftmax, ymax);
          ymin = Math.max(ymin, options.ysoftmin);
      }

      const yheight = ymax - ymin;
      const plotheight = height - options.padding.top - options.padding.bottom;
      const yscale = plotheight/yheight;

      function getScreenX(x) {
          return (x - xmin)*xscale + options.padding.left;
      }
      function getScreenY(y) {
          return height - ((y - ymin)*yscale + options.padding.bottom);
      }
      function getPlotX(x) {
          return (x-options.padding.left)/xscale + xmin;
      }
      function getPlotY(y) {
          return (-y+height-options.padding.bottom)/yscale + ymin;
      }
      // grid
      const xticks = getPrettyTicks(xmin, xmax, width);
      const yticks = getPrettyTicks(ymin, ymax, height);
      ctx.strokeStyle = options.gridcolor;
      ctx.lineWidth = options['gridwidth'];
      ctx.beginPath();
      ctx.font = '12px monospace';
      for (let i=0; i<xticks.length; i++) {
          // line
          x = getScreenX(xticks[i]);
          y = getScreenY(0);
          ctx.moveTo(x, 0);
          ctx.lineTo(x, height);
          // label
          const label = getSafeLabel(xticks[i], xmax-xmin);
          ctx.fillText(label, x, y + 12);
          // ticks
          ctx.moveTo(x, y + 10);
          ctx.lineTo(x, y - 10);
      }

      for (let i=0; i<yticks.length; i++) {
          // line
          y = getScreenY(yticks[i]);
          x = getScreenX(0);
          ctx.moveTo(0, y);
          ctx.lineTo(width, y);
          // label
          const label = getSafeLabel(yticks[i], ymax-ymin);
          ctx.fillText(label, x + 2, y - 3);
          // ticks
          ctx.moveTo(x - 10, y);
          ctx.lineTo(x + 10, y);
      }
      ctx.stroke();

      // axes
      var x0 = getScreenX(0);
      var y0 = getScreenY(0);
      ctx.strokeStyle = options.axiscolor;
      ctx.lineWidth = options['axiswidth'];
      ctx.beginPath();
      ctx.moveTo(getScreenX(xmin), y0);
      ctx.lineTo(getScreenX(xmax), y0);
      ctx.moveTo(x0, getScreenY(ymin));
      ctx.lineTo(x0, getScreenY(ymax));
      ctx.stroke();

      // functions
      for (let i=0; i<data.length; i++) {
          let datax = data[i].datax,
              datay = data[i].datay,
              l = datax.length,
              function_opt = data[i].options;
          ctx.strokeStyle = function_opt['color'];
          ctx.lineWidth = function_opt['width'];
          ctx.beginPath();
          ctx.moveTo(getScreenX(datax[0]), getScreenY(datay[0]));
          for (let j=1; j<l; j++) {
              x = getScreenX(datax[j]);
              y = getScreenY(datay[j]);
              ctx.lineTo(x, y);
          }
          ctx.stroke();
      }

      function getMousePos(canvas, evt) {
          var rect = canvas.getBoundingClientRect();
          return {
            x: evt.clientX - rect.left,
            y: evt.clientY - rect.top
          };
        }
      const rect = canvas.getBoundingClientRect();
      const vertical_hint = wrapper.getElementsByClassName('vertical-hint')[0];
      const horizontal_hint = document.getElementsByClassName('horizontal-hint')[0];
      wrapper.addEventListener('mousemove', function(evt) {
          const pixelRatio = window.devicePixelRatio;
          var mouseX = (evt.clientX-rect.left)*canvas.width/((rect.right-rect.left));
          var mouseY = (evt.clientY-rect.top)*canvas.height/((rect.bottom-rect.top));
          var plotX = getPlotX(mouseX);
          var plotY = getPlotY(mouseY);
          vertical_hint.style.left = (mouseX/pixelRatio) + 'px';
          horizontal_hint.style.top = (mouseY/pixelRatio) + 'px';

          notifyPosition(plotX, plotY);
      });
      wrapper.addEventListener('mouseleave', function(evt) {
          vertical_hint.style.left = '-1px';
          horizontal_hint.style.top = '-1px';
      });
  };

  return plotter;

})();
