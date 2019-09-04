utils = require "modules/utils"

function main()
  local function besselj0(x)
    return BesselJ(0, x)
  end
  local function besselj1(x)
    return BesselJ(1, x)
  end
  local options = {
    xmin=0,
    xmax=20
  }
  local functions = {}
  functions[1] = {name=besselj0, color="red", width=2}
  functions[2] = {name=besselj1, color="blue", width=2}
  utils.plot(functions, options)
end

main()
