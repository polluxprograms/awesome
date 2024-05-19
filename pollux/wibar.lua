local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')

local mypomowidget = require('pollux.widgets.pomo')
local myplayerwidget = require('pollux.widgets.playerctl')
local myselector = require('pollux.widgets.selector')
local mymodewidget = require('modalawesome').active_mode
local myclock = require('pollux.widgets.clock')({
  hour_length = 6,
  hour_width = 2,
  minute_length = 12,
  minute_width = 2,
  second_length = 12,
  second_width = 1,
  forced_width = 32,
  forced_height = 32
})

awful.screen.connect_for_each_screen(function(s)

  s.mypromptbox = awful.widget.prompt()

  s.mytag = wibox.widget({
    text = '',
    widget = wibox.widget.textbox
  })


  s:connect_signal('tag::changed', function ()
    if s.selected_tag then
      s.mytag.text = s.selected_tag.name
    else
      s.mytag.text = 'none'
    end
  end)

  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end)
  ))

  s.wibar = awful.wibar({
    position = 'top',
    screen = s,
    height = beautiful.bar_height,
    bg = "#0000",
    widget = wibox.widget({
      {
        myclock,
        mymodewidget,
        s.mytag,
        myselector,
        layout = wibox.layout.fixed.horizontal,
        spacing = 8
      },
      nil,
      {
        mypomowidget,
        myplayerwidget,
        s.mylayoutbox,
        layout = wibox.layout.fixed.horizontal,
        spacing = 8
      },
      layout = wibox.layout.align.horizontal
   })
  })
end)

