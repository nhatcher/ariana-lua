local ariana = require "ariana"

local a = ariana.Slider(1, 0, 5, 'a')
function main()
  local function besselj0(x)
    return BesselJ(0, a*x)
  end
  local options = {
    xmin=-5,
    xmax=20
  }
  local functions = {}
  functions = {
    {name=besselj0, color="red", width=1}
  }
  local my_canvas = ariana.plot(functions, options)
  my_canvas.set('fillStyle', 'green')
  my_canvas.call('fillRect', {20*a, 20*a, 150*a, 100*a})
end

main()
