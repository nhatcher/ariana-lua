utils = require "modules/utils"

function main()
  local function besselj0(x)
    return BesselJ(0, x)
  end
  local function bsum(x)
    s = 0
    for i=1,5 do
      s = s + BesselJ(i, x)
    end
    return s
  end
  local options = {
    xmin=-5,
    xmax=20
  }
  local functions = {}
  functions = {
    {name=besselj0, color="red", width=1}, 
    {name=bsum, color="blue", width=5}
  }
  utils.plot(functions, options)
end

main()
