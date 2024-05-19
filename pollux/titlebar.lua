local wibox = require('wibox')
local awful = require('awful')
local slick = require('slick')
local beautiful = require('beautiful')

local color = require('pollux.color')

local titlebar_size = 24

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

  local ret = c.titlebar or nil

  if not ret then

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

    local anim = slick(
      color.new(beautiful.titlebar_normal),
      {
        callback = function (value)
          ret:set_bg(color.to_pattern(value))
        end,
        stop = stop_anim
      }
    )

    ret.set_col = function(col)
      anim:set(color.new(col))
    end

    c.titlebar = ret
  end

  return ret
end

-- Signals
client.connect_signal("request::titlebars", function(c)
  add_titlebar(c):setup {
    nil,
    {
        halign = "center",
        widget = awful.titlebar.widget.titlewidget(c)
    },
    nil,
    layout  = wibox.layout.align.horizontal,
    expand = 'outside'
  }
end)

client.connect_signal("request::unmanage", function(c)
  c.titlebar:_inform_visible(false)
end)
