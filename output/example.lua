function isNaN(x)
  if type(x) == 'number' then
    return false
  else
    return true
  end
end

function getDataPoints(g, xmin, xmax)
  local N = 10;
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


function Plot(g, xmin, xmax)
  local x = xmin;
  local N = 100;
  local xwidth = xmax - xmin;
  local step = (xmax - xmin)/N;
  local data = {};
  local ymax, ymin;
  for x=xmin, xmax, step do
    plot.set_point(x, g(x));
    x = x + step;
  end
end

function main()
  local function f(x)
    return tfunc.j0(x)*2;
  end

  -- Plot(f, -5, 5)
  local w = getDataPoints(f, -5, 5)
  plot.set_function(w);
end

main();
