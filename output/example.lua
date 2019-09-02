function isNaN(x)
  if type(x) == 'number' then
    return false
  else
    return true
  end
end

function getDataPoints(g, xmin, xmax)
  local N = 1000;
  local ymin;
  local ymax;
  local step = (xmax-xmin)/N;
  local datax = {};
  local datay = {};
  local x, y;

  local i = 1;
  for x=xmin, xmax+step, step do
      y = g(x);
      if type(y) == 'number' then
        if isNaN(ymin) or y < ymin then
            ymin = y;
        end
        if isNaN(ymax) or y > ymax then
            ymax = y;
        end
        datax[i] = x;
        datay[i] = y;
        i = i + 1;
      end
  end
  return {
      ymax=ymax,
      ymin=ymin,
      datax=datax,
      datay=datay
  }
end

-----------

function main()
  local function f(x)
    return tfunc.j0(x)*2;
  end

  -- Plot(f, -5, 5)
  local w = getDataPoints(f, -5, 5);
  print(w.datax[1]);
  plot.set_function(w);
end

main();
