local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')

local player_widget = wibox.widget({
  widget = wibox.widget.textbox
})

player_widget:buttons(gears.table.join(
  awful.button({ }, 1, function (c)
    awful.spawn({'playerctl', 'play-pause'})
  end)
))

local setup = function(opts)
  opts = opts or {}
  local format = opts.format or {}


  gears.timer({
    timeout = 1,
    call_now = true,
    autostart = true,
    callback = function ()
      awful.spawn.easy_async('playerctl metadata --format "' .. format .. '"', function (stdout)
        player_widget:set_text(stdout)
      end)
    end
  })

  return player_widget
end

return { setup = setup }
