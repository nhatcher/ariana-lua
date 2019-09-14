local json = require "json"

local ariana = { _version = "0.1.0"}

local function isNaN(x)
  if type(x) == 'number' then
    return false
  else
    return true
  end
end

local canvasID = 0

local function getDataPoints(g, xmin, xmax, points)
  local ymin;
  local ymax;
  local step = (xmax-xmin)/points;
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
local plot_defaults = {
  points=1000,
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
  axiscolor='#ccc',
  axiswidth=2
}

local canvas_defaults = {
  width='auto',
  height='auto'
}

local function setDefaults(options, defaults)
  for key, value in pairs(defaults) do
    if options[key] == nil then
      options[key] = value
    end
  end
end



function ariana.plot(funtions, options)
  local data = {};
  local ymin, ymax;
  setDefaults(options, plot_defaults)
  local xmin = options.xmin
  local xmax = options.xmax
  for i, fun in ipairs(funtions) do
    local w = getDataPoints(fun.name, xmin, xmax, options.points)
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
  canvasID = canvasID + 1;

  local mt = {
    __newindex=function(_, property, value)
      canvas.set(canvasID, property, value)
    end,
    __index=function(_, property)
      return function(...)
        canvas.call(canvasID, property, json.encode({...}))
      end
    end
  }
  local proxy = {
    canvasID=canvasID,
    width=function()
      return canvas.width(canvasID)
    end,
    height=function()
      return canvas.height(canvasID)
    end
  }
  setmetatable(proxy, mt)
  return proxy
end

function ariana.Slider(value, min, max, name)
  options = {}
  if plot.state[name] == nil then
    options['value'] = value
  else
    options['value'] = plot.state[name]
  end
  options['min'] = min
  options['max'] = max
  options['step'] = (max-min)/100
  options.name = name
  if not plot['keep_parameters'] then
    plot.slider(json.encode(options))
  end
  return options['value']
end

function ariana.Checkbox(value, name)
  options = {}
  if plot.state[name] == nil then
    options['value'] = value
  else
    options['value'] = plot.state[name]
  end
  options.name = name
  plot.chekbox(json.encode(options))
  return options['value']
end

function ariana.canvas(options)
  canvasID = canvasID + 1
  setDefaults(options, canvas_defaults)
  plot.new_canvas(json.encode(options))
  local mt = {
    __newindex=function(_, property, value)
      canvas.set(canvasID, property, value)
    end,
    __index=function(_, property)
      return function(...)
        canvas.call(canvasID, property, json.encode({...}))
      end
    end
  }
  local proxy = {
    canvasID=canvasID,
    width=function()
      return canvas.width(canvasID)
    end,
    height=function()
      return canvas.height(canvasID)
    end
  }
  setmetatable(proxy, mt)
  return proxy
end

return ariana;