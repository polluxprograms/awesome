local wibox = require('wibox')
local awful = require('awful')
local slick = require('slick')
local beautiful = require('beautiful')

local color = require('pollux.color')

local titlebar_size = 24
local focus_color = beautiful.titlebar_focus['tag']

local all_titlebars = {}

local stop_anim = function(value, target)
  return (
    (value.r - target.r) ^ 2 +
    (value.g - target.g) ^ 2 +
    (value.b - target.b) ^ 2 +
    (value.a - target.a) ^ 2
  ) < 0.01
end

local add_titlebar = function(c)
  local drawable = c.titlebar_top(c, titlebar_size)

  local context = {
    client = c,
    position = 'top'
  }

  local ret

  if not all_titlebars[c] then

    ret = wibox.drawable(drawable, context, 'pollux.titlebar')

    ret:_inform_visible(true)

    ret.setup = wibox.widget.base.widget.setup
    ret.get_children_by_id = function (self, name)
      if self._drawable._widget
        and self._drawable._widget._private
        and self._drawable._widget._private.by_id then
            return self._drawable.widget._private.by_id[name]
      end

      return {}
    end

    -- Add an animation
    all_titlebars[c] = {
      drawable = ret,
      animation = slick(
        color.new(beautiful.titlebar_normal),
        {
          callback = function (value)
            ret:set_bg(color.to_pattern(value))
          end,
          stop = stop_anim
        }
      )
    }
  else
    ret = all_titlebars[c].drawable
  end

  return ret
end

local set_titlebar_color = function(c, col)
  all_titlebars[c].animation:set(color.new(col))
end

-- Signals
client.connect_signal("request::titlebars", function(c)
  add_titlebar(c):setup {
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

awesome.connect_signal('mode::changed', function(mode)
  focus_color = beautiful.titlebar_focus[mode] or beautiful.titlebar_normal
  if client.focus then
    set_titlebar_color(client.focus, focus_color)
  end
end)

client.connect_signal("focus", function (c)
  set_titlebar_color(c, focus_color)
end)

client.connect_signal("unfocus", function (c)
  set_titlebar_color(c, beautiful.titlebar_normal)
end)

client.connect_signal("request::unmanage", function(c)
  all_titlebars[c].drawable:_inform_visible(false)
  all_titlebars[c] = nil
end)
