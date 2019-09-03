json = require "modules/json"

local utils = { _version = "0.1.0"}

local function isNaN(x)
  if type(x) == 'number' then
    return false
  else
    return true
  end
end

local function getDataPoints(g, xmin, xmax)
  local N = 1000;
  local ymin;
  local ymax;
  local step = (xmax-xmin)/N;
  local datax = {};
  local datay = {};
  local x, y;

  local i = 1;
  for x=xmin, xmax+step, step do
      y = g(x);
      if type(y) == 'number' then
        if isNaN(ymin) or y < ymin then
            ymin = y;
        end
        if isNaN(ymax) or y > ymax then
            ymax = y;
        end
        datax[i] = x;
        datay[i] = y;
        i = i + 1;
      end
  end
  return {
      ymax=ymax,
      ymin=ymin,
      datax=datax,
      datay=datay
  }
end

function utils.plot(fun, options)
  local w = getDataPoints(fun.f, options.xmin, options.xmax);
  data = {} 
  data[1] = {
    datax = w.datax;
    datay = w.datay;
    options={
      color=fun.color,
      width=fun.width
    }
  }
  options.data=data;
  options.ymin = w.ymin;
  options.ymax = w.ymax;
  plot.plot_function(json.encode(options));
end

return utils;