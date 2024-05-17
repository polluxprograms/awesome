local gears = require('gears')
local cairo = require('lgi').cairo

local color = {}

color.new_rgba = function (r, g, b, a)

  local c = {r, g, b, a}

  return setmetatable({
    r = r,
    g = g,
    b = b,
    a = a,
  },{
    __index = c,
    __add = function (x, y)
      return color.new_rgba(
        x.r + y.r,
        x.g + y.g,
        x.b + y.b,
        x.a + y.a
      )
    end,
    __mul = function (x, y)
      if type(x) == "table" then
        return color.new_rgba(
          x.r * y,
          x.g * y,
          x.b * y,
          x.a * y
        )
      else
        return color.new_rgba(
          y.r * x,
          y.g * x,
          y.b * x,
          y.a * x
        )
      end
    end,
    __sub = function (x, y)
      return x + y * -1
    end
  })
end

color.new = function (html)
  local r, g, b, a = gears.color.parse_color(html)
  return color.new_rgba(r, g, b, a)
end

color.to_pattern = function(col)
  return cairo.Pattern.create_rgba(col.r, col.g, col.b, col.a)
end

return color
