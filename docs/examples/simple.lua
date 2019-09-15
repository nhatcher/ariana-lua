-- We import Ariana's tools
local ariana = require "ariana"

-- We can create a slider!
local a = ariana.Slider(1, 0, 5, 'a')

-- Define the function we want to draw
local function sinc(x)
  return math.sin(a*x)/x
end

-- We define options and the functions we want to plot
local options = {
  xmin=-20,
  xmax=20
}
local functions = {
  {name=sinc, color="red", width=1},
}

-- And plot them
ariana.plot(functions, options)