pcall(require, 'luarocks.loader')

local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

HOME_DIR = os.getenv('HOME') .. '/'
AWESOME_DIR = HOME_DIR .. '.config/awesome/'
THEMES_DIR = AWESOME_DIR .. 'themes/'
beautiful.init(THEMES_DIR .. 'custom/theme.lua')

require('pollux.errors')
require('pollux.notifications')
require('pollux.focus')
require('pollux.floating')

local modalawesome = require('modalawesome')
modalawesome.init{
  modkey       = 'Mod4',
  default_mode = 'tag',
  modes        = require('pollux.modes'),
  stop_name    = 'client',
  keybindings  = {}
}

local awetags = require('pollux.awetags')

local mypomowidget = require('pollux.widgets.pomo')
local myplayerwidget = require('pollux.widgets.playerctl')
local myselector = require('pollux.widgets.selector')
local mymodewidget = modalawesome.active_mode
local clock = require('pollux.widgets.clock')

awful.spawn.with_shell('~/.config/awesome/autostart.sh')

modkey = 'Mod4'

awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  awful.layout.suit.max.fullscreen,
}

mytextclock = wibox.widget.textclock()

local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end)
)

local function set_wallpaper(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == 'function' then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, false)
  end
end

screen.connect_signal('property::geometry', set_wallpaper)


awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)

  s.myclock = clock({
    hour_length = 6,
    hour_width = 2,
    minute_length = 12,
    minute_width = 2,
    second_length = 12,
    second_width = 1,
    forced_width = 32
  })

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
        s.myclock,
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

if not awetags.restore() then
  local default_tag = awetags.create_tag('default', screen.primary)
  default_tag.selected = true
end

awful.rules.add_rule_source('default', function(_, properties)
  properties.focus = awful.client.focus.filter
  properties.raise = true
  properties.screen = awful.screen.preferred
  properties.titlebars_enabled = true
  properties.placement = awful.placement.no_overlap+awful.placement.no_offscreen
end)

local titlebar = require('pollux.titlebar')

client.connect_signal("request::titlebars", function(c)
  titlebar.add_titlebar(c):setup {
    nil,
    { -- Title
        halign = "center",
        widget = awful.titlebar.widget.titlewidget(c)
    },
    nil,
    layout  = wibox.layout.align.horizontal,
    expand = 'outside'
  }
end)
