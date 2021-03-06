-- We import Ariana's tools
local ariana = require "ariana"

-- We can create a slider!
local a = ariana.Slider(1, 0, 50, 'a')

-- Define the function we want to draw
local function besselj0(x)
  return BesselJ(0, a*x)
end

-- some options 
local options = {
  padding= {
    top=100,
    bottom=10,
    left=10,
    right=10
  },
  xmin=-20,
  xmax=20
}
local functions = {{name=besselj0, color="red", width=1}}

-- And plot it
local ctx = ariana.plot(functions, options)

-- We get back a handle to the canvas
-- We can get the width and height of the canvas
width = ctx.width()
height = ctx.height()

ctx.font = '48px serif'
ctx.fillText('A Bessel function!', width/2 - 100, 50)



