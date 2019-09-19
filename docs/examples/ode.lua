local ariana = require "ariana"

-- We want to solve {y''(x) = x^2*y(x), y'(c) = yp_0, y(c) = y_0}

local function DSolveEuler(opt)
  local h = 0.001
  local last_x = opt['x0']
  local last_y = opt['y']
  local last_yp = opt['yp']
  local x0, y, yp
  return function(x)
    if math.abs(last_x - x) < math.abs(x-opt['x0']) then
      x0 = last_x
      y = last_y
      yp = last_yp
    else
      yp = opt.yp
      y = opt.y
      x0 = opt['x0']
    end
    if x < x0 then
      delta = -h
    else
      delta = h
    end
    local steps = math.ceil((x-x0)/delta)
    
    x = x0
    for i=0, steps do
      x = x + delta
      ypp = opt.ypp(x, y, yp)
      y = y + yp*delta + ypp*delta*delta/2
      yp = yp + ypp*delta
    end
    last_x = x;
    last_y = y;
    last_yp = yp;
    return y
  end
end

-- double try_with_energy(double _E) {
--   E = _E;
--   double x0 = 0;
--   double y0 = 1;
--   double h = 0.00001;
--   double x=x0, y=y0, yp=0;
--   double k1, k2, k3, k4;
--   double h2, h3, h4;
--   while (x<10) {
--     k1 = f(x, y);
--     k2 = f(x+h/2, y+h*k1/2);
--     k3 = f(x+h/2, y+h*k2/2);
--     k4 = f(x+h, y+h*k3);
--     h2 = h*h;
--     h3 = h2*h;
--     h4 = h3*h;
--     y += h*yp + h2*yp*0.5 + h3*yp*0.25 + h4*yp/24;
--     yp += h*(k1+2*k2+2*k3+k4)/6;
--     x += h;
--     if (std::abs(y)> big_number) break;
--   }
--   return (y>0 ? 1: -1);
-- }


local function DSolveRK4(opt)
  local h = 0.001
  local last_x = opt['x0']
  local last_y = opt['y']
  local last_yp = opt['yp']
  local x0, y0, yp0
  return function(x)
    if math.abs(last_x - x) < math.abs(x-opt['x0']) then
      x0 = last_x
      y0 = last_y
      yp0 = last_yp
    else
      yp0 = opt['yp0']
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
    local m1, m2, m3, m4
    local f = opt.ypp -- f(x, y, yp)
    -- ypp = f(x, y, yp)
    -- y2'(x) = f(x, y1, y2)
    -- y1'(x) = y2

    x = x0
    y1 = y0
    y2 = yp0
    for i=0, steps do
      k1 = y2
      m1 = f(x, y1, y2)
      k2 = y2 + delta*k1/2
      m2 = f(x + delta/2, y1 + delta*k1/2, y2 + delta*m1/2)
      k3 = y2 + delta*k2/2
      m3 = f(x + delta/2, y1 + delta*k2/2, y2 + delta*m2/2)
      k4 = y2 + delta*k3
      m4 = f(x + delta, y1 + delta*k3, y2 + delta*m3)

      x = x + delta
      y1 = y1 + delta*(k1 + 2*k2 + 2*k3 + k4)/6
      y2 = y2 + delta*(m1 + 2*m2 + 2*m3 + m4)/6
      -- y = y + yp*delta + ypp*delta*delta/2
      -- yp = yp + ypp*delta
    end
    last_x = x;
    last_y = y1;
    last_yp = y2;
    return y1
  end
end



-- y''(x) = -4*y(x) --> y(x) = sin(2*x)
local y = DSolveRK4({
  x0=0,
  yp0=2,
  y0=0,
  ypp=function(x, y, yp)
    return -4*y -- BesselJ(0, x)*math.sin(x);
  end
})


local options = {
    xmin=-5,
    xmax=5
}
local functions= {{name=y, color="red", width=1}}

ariana.plot(functions, options)

