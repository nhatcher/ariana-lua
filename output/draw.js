function draw(plot_area, options) {
  const canvas = plot_area.getElementsByTagName('canvas')[0];
  const datax = options.datax;
  const datay = options.datay;
  const xmin = options.xrange[0];
  const xmax = options.xrange[1];

  const width = canvas.width;
  const height = canvas.height;
  const ctx = canvas.getContext('2d');
  ctx.clearRect(0, 0, canvas.width, canvas.height);


  let yheight = ymax - ymin,
  plotheight = height - options.padding.top - options.padding.bottom;
  yscale = plotheight/yheight;

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
    var label = getSafeLabel(yticks[i], ymax-ymin);
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
}