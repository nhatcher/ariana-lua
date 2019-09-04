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
local defaults = {
  xmin=-5,
  xmax=5,
  padding={
    left=10,
    right=10,
    top=10,
    bottom=10
  },
  gridcolor='#ccc',
  gridwidth=1,
  axiscolor='blue',
  axiswidth=1
}

local function setDefaults(options)
  for key, value in pairs(defaults) do
    if options[key] == nil then
      options[key] = value
    end
  end
end

function utils.plot(funtions, options)
  local data = {};
  local ymin, ymax;
  setDefaults(options)
  local xmin = options.xmin
  local xmax = options.xmax
  for i, fun in ipairs(funtions) do
    local w = getDataPoints(fun.name, xmin, xmax)
    data[i] = {
      datax = w.datax;
      datay = w.datay;
      options={
        color=fun.color,
        width=fun.width
      }
    }
    if i == 1 then
      ymin=w.ymin
      ymax=w.ymax
    end
    ymin = math.min(ymin, w.ymin)
    ymax = math.max(ymax, w.ymax)
  end
  options.data=data
  options.ymin = ymin
  options.ymax = ymax
  plot.plot_function(json.encode(options))
end

return utils;