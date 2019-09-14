-- We import Ariana's tools
local ariana = require "ariana"

-- We can create a slider!
local a = ariana.Slider(1, 0, 50, 'a')

-- Define the function we want to draw
local function sinc(x)
  return math.sin(a*x)/x
end

-- some options 
local options = {
  xmin=-20,
  xmax=20
}
local functions = {
  {name=sinc, color="red", width=1},
}
ariana.plot(functions, options)