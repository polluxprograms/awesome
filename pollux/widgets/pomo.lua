local awful = require('awful')
local wibox = require('wibox')
local timer = require('gears.timer')
local gtable = require('gears.table')

local pomo_widget = wibox.widget({
  widget = wibox.widget.textbox
})

pomo_widget:buttons(
  gtable.join(
    awful.button({}, 1, function ()
      awful.spawn.with_shell('pomo.sh start')
    end),
    awful.button({}, 3, function ()
      awful.spawn.with_shell('pomo.sh stop')
    end)
  )
)

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
