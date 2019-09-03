utils = require "modules/utils"

function main()
  local function f(x)
    return BesselJ(1, x);
  end
  local options = {
    xmin=-5,
    xmax=5,
    padding={
      left=10,
      right=10,
      top=10,
      bottom=10
    },
    gridcolor='#ccc',
    gridwidth=1,
    axiscolor='blue',
    axiswidth=1
  }
  utils.plot({f=f, color="red", width=2}, options)
end

main();
