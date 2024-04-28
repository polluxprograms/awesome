local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')

local player_widget = wibox.widget({
  widget = wibox.widget.imagebox,
  resize = true
})

player_widget:buttons(gears.table.join(
  awful.button({ }, 1, function (c)
    awful.spawn({'playerctl', 'play-pause'})
  end)
))

gears.timer({
  timeout = 1,
  call_now = true,
  autostart = true,
  callback = function ()
    awful.spawn.easy_async('playerctl metadata mpris:artUrl', function (stdout)

      local cover_path = string.sub(stdout, 8, -2)
      local surface = gears.surface.load(cover_path)
      player_widget.image = surface
    end)
  end
})

return player_widget
