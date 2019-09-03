utils = require "modules/utils"

function main()
  local function f(x)
    return BesselJ(1, x);
  end
  utils.plot(f, -5, 5, "red")
end

main();
