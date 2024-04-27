local awful = require('awful')
local gears = require('gears')
local modalawesome = require('modalawesome')

client_buttons = gears.table.join(
  awful.button({}, 1, function (c)
    if modalawesome.active_mode.text == 'layout' then
      c:emit_signal('request::activate', 'mouse_click', {raise = true})
      awful.mouse.client.move(c)
    end
  end),
  awful.button({}, 3, function (c)
    if modalawesome.active_mode.text == 'layout' then
      c:emit_signal('request::activate', 'mouse_click', {raise = true})
      awful.mouse.client.resize(c)
    end
  end)
)

awful.rules.add_rule_source('floating_controls', function(c, properties)
  properties.buttons = client_buttons
end)
