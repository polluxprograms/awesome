local beautiful = require('beautiful')
require('awful.autofocus')

local focus_color = beautiful.titlebar_focus['tag']

awesome.connect_signal('mode::changed', function(mode)
  focus_color = beautiful.titlebar_focus[mode] or beautiful.titlebar_normal
  if client.focus then
    client.focus.titlebar.set_col(focus_color)
  end
end)

client.connect_signal("focus", function (c)
  c.titlebar.set_col(focus_color)
end)

client.connect_signal("unfocus", function (c)
  c.titlebar.set_col(beautiful.titlebar_normal)
end)

client.connect_signal('mouse::enter', function(c)
  c:emit_signal('request::activate', 'mouse_enter', {raise = false})
end)
