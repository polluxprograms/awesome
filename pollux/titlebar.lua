local wibox = require('wibox')

local titlebar_size = 24

local titlebar = {}

local all_titlebars = {}

titlebar.add_titlebar = function(c)
  local drawable = c.titlebar_top(c, titlebar_size)

  local context = {
    client = c,
    position = 'top'
  }

  local ret

  if not all_titlebars[c] then

    ret = wibox.drawable(drawable, context, 'pollux.titlebar')
    ret:_inform_visible(true)
    ret:set_bg('#0000')

    ret.setup = wibox.widget.base.widget.setup
    ret.get_children_by_id = function (self, name)
      if self._drawable._widget
        and self._drawable._widget._private
        and self._drawable._widget._private.by_id then
            return self._drawable.widget._private.by_id[name]
      end

      return {}
    end
    
    c:connect_signal("request::unmanage", function()
            ret:_inform_visible(false)
    end)

  else
    ret = all_titlebars[c]
  end

  return ret
end

client.connect_signal("request::unmanage", function(c)
    all_titlebars[c] = nil
end)

return titlebar
