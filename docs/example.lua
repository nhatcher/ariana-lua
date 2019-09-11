-- We import the ariana's tools
local ariana = require "ariana"

-- We create a slider!
local a = ariana.Slider(1, 0, 5, 'a')

-- Define the function we want to draw
local function besselj0(x)
  return BesselJ(0, a*x)
end

-- some options 
local options = {
  xmin=-5,
  xmax=20
}
local functions = {{name=besselj0, color="red", width=1}}

-- And plot it
local ctx = ariana.plot(functions, options)

-- We get back a handle to the canvas
-- We can get the width and height of the canvas
width = ctx.width()
height = ctx.height()

ctx.fillStyle = 'green'
ctx.fillRect(width/2 - 10, height/2 - 10, 10*a, 10*a)


