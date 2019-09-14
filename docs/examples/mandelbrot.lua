local ariana = require "ariana"

local function mandelbrot(x, y, maxiter)
  local cx = x
  local cy = y
  for n = 0, maxiter do
    if x*x + y*y > 10 then
      return n
    end
    local xtemp = x*x - y*y + cx
    y = 2*x*y + cy
    x = xtemp

  end
  return maxiter
end

local function draw_set()
  local xmin = -2.5
  local xmax = 2
  local ymin = -2
  local ymax = 2
  local maxiter = 25
  local options = {
    width=400,
    height=400
  }
  ctx = ariana.canvas(options)
  ctx.fillStyle = 'red'
  local width = ctx.width()+0
  local height = ctx.height()+0
  local x = xmin
  local y = ymin
  local xstep = (xmax - xmin)/width
  local ystep = (ymax - ymin)/height
  for i=0,width do
    x = xmin + xstep*i
    for j=0,height do
      y = ymin + ystep*j
      local iter = mandelbrot(x, y, maxiter)
      if iter == maxiter then
        ctx.fillRect(i, height - j, 1, 1)
      end
    end
  end
end

draw_set()
