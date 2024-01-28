local awful = require('awful')
local wibox = require('wibox')
local timer = require('gears.timer')

local pomo_widget = wibox.widget({
  widget = wibox.widget.textbox
})

timer({
  timeout = 1,
  call_now = true,
  autostart = true,
  callback = function()
    awful.spawn.easy_async('pomo.sh clock', function(stdout)
      pomo_widget:set_text(stdout)
    end)
  end
})

return pomo_widget
