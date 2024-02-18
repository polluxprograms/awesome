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

local modalawesome = require('modalawesome')
modalawesome.init{
  modkey       = "Mod4",
  default_mode = "tag",
  modes        = require("pollux.modes"),
  stop_name    = "client",
  keybindings  = {}
}

local awetags = require('pollux.awetags')

local mypomowidget = require('pollux.widgets.pomo')
local myplayerwidget = require('pollux.widgets.playerctl').setup({
  format = '{{ artist }} - {{ title }}'
})
local myselector = require('pollux.widgets.selector')
local mymodewidget = modalawesome.active_mode

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

  -- Hidden wibar
  s.wibar = awful.wibar({
    position = 'top',
    screen = s,
    width = 16,
    height = 16,
    widget = wibox.widget({})
  })
  s.wibar.x = s.geometry.x

  s.wibox_left = awful.popup({
    screen = s,
    placement = awful.placement.top_left,
    minimum_height = 16,
    maximum_height = 16,
    shape = function (cr, width, height)
      return gears.shape.partially_rounded_rect(cr, width, height, false, false, true, false, 8)
    end,
    widget = wibox.widget({
      mytextclock,
      mymodewidget,
      s.mytag,
      myselector,
      layout = wibox.layout.fixed.horizontal,
      spacing = 8
    })
  })

  s.wibox_right = awful.popup({
    screen = s,
    placement = awful.placement.top_right,
    minimum_height = 16,
    maximum_height = 16,
    shape = function (cr, width, height)
      return gears.shape.partially_rounded_rect(cr, width, height, false, false, false, true, 8)
    end,
     widget = wibox.widget({
      mypomowidget,
      myplayerwidget,
      s.mylayoutbox,
      layout = wibox.layout.fixed.horizontal,
      spacing = 8
    })
  })

end)

if not awetags.restore() then
  local default_tag = awetags.create_tag('default', screen.primary)
  default_tag.selected = true
end

awful.rules.rules = {
  {
    rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen
    }
  },
  {
    rule_any = {
      instance = { 'pinentry' },
      name = { 'Event Tester' }
    },
    properties = { floating = true }
  },
}

client.connect_signal('manage', function (c)
  if awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position then
     -- awful.placement.no_offscreen(c)
  end
end)

