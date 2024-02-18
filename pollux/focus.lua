local beautiful = require('beautiful')
require('awful.autofocus')

local focus = {}

local unfocus_color = beautiful.border_unfocus
local focus_color = beautiful.border_focus['tag']

client.connect_signal('mouse::enter', function(c)
  c:emit_signal('request::activate', 'mouse_enter', {raise = false})
end)

client.connect_signal('focus', function(c) c.border_color = focus_color end)
client.connect_signal('unfocus', function(c) c.border_color = unfocus_color end)

awesome.connect_signal('mode::changed', function (mode)
  focus.set_focus_color(beautiful.border_focus[mode] or beautiful.border_unfocus)
end)

focus.set_focus_color = function(col)
  focus_color = col
  if client.focus then
    client.focus.border_color =  col
  end
end

focus.set_unfocus_color = function(col)
  -- Not Implemented
end

return focus
