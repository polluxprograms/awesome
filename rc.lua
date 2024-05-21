pcall(require, 'luarocks.loader')

local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')

HOME_DIR = os.getenv('HOME') .. '/'
AWESOME_DIR = HOME_DIR .. '.config/awesome/'
WALLPAPER_DIR = HOME_DIR .. 'Wallpapers/'
THEMES_DIR = AWESOME_DIR .. 'themes/'

beautiful.init(THEMES_DIR .. 'custom/theme.lua')

local modalawesome = require('modalawesome')
modalawesome.init{
  modkey       = 'Mod4',
  default_mode = 'tag',
  modes        = require('pollux.modes'),
  stop_name    = 'client',
  keybindings  = {}
}

local awetags = require('pollux.awetags')

if not awetags.restore() then
  gears.timer.delayed_call(function()
    local default_tag = awetags.create_tag('default', screen.primary)
    default_tag.selected = true
  end)
else
  gears.timer.delayed_call(function()
    screen.primary:emit_signal('tag::changed')
  end)
end

local naughtier = require('naughtier')
naughtier.setup({
  filters = {
    -- Enable dnd
    naughtier.default.dnd,
    -- Don't log MPD notifications
    function (notification)
      if notification.freedesktop_hints and notification.freedesktop_hints['desktop-entry'] == 'mpdris2' then
        notification.log = false
      end
      return notification
    end
  }
})

require('pollux.errors')
require('pollux.wibar')
require('pollux.floating')
require('pollux.titlebar')
require('pollux.focus')

local set_wallpaper = function (s)
  gears.wallpaper.maximized(WALLPAPER_DIR .. beautiful.wallpaper, s, false)
end

screen.connect_signal('property::geometry', function (s)
  set_wallpaper(s)
end)

awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)
end)

awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  awful.layout.suit.max.fullscreen,
}

awful.rules.add_rule_source('default', function(_, properties)
  properties.focus = awful.client.focus.filter
  properties.raise = true
  properties.screen = awful.screen.preferred
  properties.titlebars_enabled = true
  properties.placement = awful.placement.no_overlap+awful.placement.no_offscreen
end)

awful.spawn.with_shell('~/.config/awesome/autostart.sh')
