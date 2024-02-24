local base = require('wibox.widget.base')
local gears = require('gears')
local cairo = require('lgi').cairo

local clock = {}

function clock:draw(_, cr, width, height)

  local time = os.date('*t')

  local sec_angle = time.sec * math.pi/30
  local minute_angle = (time.min + time.sec/60) * math.pi/30
  local hour_angle = (time.hour + time.min/60 + time.sec/3600) * math.pi/6

  cr:set_source_rgba(1, 1, 1, 1)
  cr:set_line_cap(cairo.LineCap.ROUND)

  -- Hour hand
  cr:move_to(width/2, height/2)
  cr:line_to(
    width/2 + math.sin(hour_angle) * self._private.hour_length,
    height/2 - math.cos(hour_angle) * self._private.hour_length
  )
  cr:set_line_width(self._private.hour_width)
  cr:stroke()

  -- Minute hand
  cr:move_to(width/2, height/2)
  cr:line_to(
    width/2 + math.sin(minute_angle) * self._private.minute_length,
    height/2 - math.cos(minute_angle) * self._private.minute_length
  )
  cr:set_line_width(self._private.minute_width)
  cr:stroke()

  -- Second hand
  cr:move_to(width/2, height/2)
  cr:line_to(
    width/2 + math.sin(sec_angle) * self._private.second_length,
    height/2 - math.cos(sec_angle) * self._private.second_length
  )
  cr:set_line_width(self._private.second_width)
  cr:stroke()

end

function clock:fit(_, width, height)
  return width, height
end

local function new(args)

  local ret = base.make_widget(nil, nil, {
    enable_properties = true
  })

  gears.table.crush(ret, clock)

  gears.timer({
    timeout = 1,
    call_now = true,
    autostart = true,
    callback = function ()
      ret:emit_signal('widget::redraw_needed')
    end
  })

  gears.table.crush(ret._private, args)

  return ret
end

return new
