local naughty = require('naughty')
local awful = require('awful')

naughty.config.notify_callback = function(args)

  -- Play default notification sound
  awful.spawn({'paplay', '/usr/share/sounds/freedesktop/stereo/message.oga'})

  -- TODO: 
  -- Notification toggle
  -- Filter notifications
  -- Notification settings
  -- Different sounds for applications

  -- Return notifications
  return args
end
