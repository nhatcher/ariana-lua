local ariana = require "ariana"

local function DSolveRK4(opt)
  local h = 0.001
  local last_x = opt['x0']
  local last_y = opt['y0']
  local x0, y0
  return function(x)
    if math.abs(last_x - x) < math.abs(x-opt['x0']) then
      x0 = last_x
      y0 = last_y
    else
      y0 = opt['y0']
      x0 = opt['x0']
    end
    if x < x0 then
      delta = -h
    else
      delta = h
    end
    local steps = math.ceil((x-x0)/delta)

    local k1, k2, k3, k4
    local h2, h3, h4
    local f = opt.yp

    x = x0
    y = y0
    for i=0, steps do
      k1 = f(x, y)
      k2 = f(x + delta/2, y + delta*k1/2)
      k3 = f(x + delta/2, y + delta*k2/2)
      k4 = f(x + delta, y + delta*k3)
      h2 = delta*delta
      h3 = h2*delta
      h4 = h3*delta
      y = y + delta*(k1 + 2*k2 + 2*k3 + k4)/6
      x = x + delta
    end
    last_x = x
    last_y = y
    return y
  end
end

local y = DSolveRK4({
  x0=0,
  y0=1,
  yp=function(x, y)
    return -x*x*math.abs(y) --BesselJ(0, x)*math.sin(x);
  end
})

local options = {
    xmin=-2,
    xmax=2
}

local functions= {{name=y, color="red", width=1}}
ariana.plot(functions, options)