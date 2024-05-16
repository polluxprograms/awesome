local wibox = require('wibox')
local awful = require('awful')

local titlebar_size = 24

local all_titlebars = {}

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
    }
  else
    ret = all_titlebars[c].drawable
  end

  return ret
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

client.connect_signal("request::unmanage", function(c)
  all_titlebars[c].drawable:_inform_visible(false)
  all_titlebars[c] = nil
end)
