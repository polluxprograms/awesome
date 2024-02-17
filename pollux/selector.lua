local keygrabber = require('awful.keygrabber')
local wibox = require('wibox')

local selector = wibox.widget({
  widget = wibox.widget.textbox
})

local get_match = function (options, input)
  for _, v in pairs(options) do
    if string.find(v, input) then
      return v
    end
  end
  return nil
end

local draw = function (prompt, options, input)
  local match = get_match(options, input) or input
  selector.text = prompt .. ' ' .. match
end


selector.query = function(prompt, options, callback)
  selector.text = prompt

  local input = ''

  local grabber
  grabber = keygrabber.run(function (mod, key, event)
    if event == 'release' then return end

    if key == 'BackSpace' then
      if input ~= '' then
        input = string.sub(input, 1, #input - 1)
      end
    elseif key == 'Escape' or key == 'Return' then
      if key == 'Return' then
        local selection = get_match(options, input) or input
        callback(selection)
      end
      keygrabber.stop(grabber)
      selector.text = ''
      return
    elseif #key == 1 and (string.lower(key) >= 'a' or string.lower(key) <= 'z') then
      input = input .. key
    end
    draw(prompt, options, input)
  end)

  draw(prompt, options, input)
end

return selector
