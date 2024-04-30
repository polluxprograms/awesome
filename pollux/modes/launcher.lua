local awful = require("awful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local launcher_commands = {
  {
    description = "show help",
    pattern = {'h'},
    handler = function() hotkeys_popup.show_help() end
  },
  {
    description = "reload awesome",
    pattern = {'r'},
    handler = function() 
      require('pollux.awetags').save()
      awesome.restart()
    end
  },
  {
    description = "quit awesome",
    pattern = {'Q'},
    handler = function() awesome.quit() end
  },
  {
    description = "open a terminal",
    pattern = {'t'},
    handler = function() awful.spawn('/home/pollux/.config/awesome/open_terminal.sh') end
  },
  {
    description = "open a browser",
    pattern = {'b'},
    handler = function() awful.spawn('librewolf') end
  },
  {
    description = "show the menubar",
    pattern = {'m'},
    handler = function() menubar.show() end
  },
  {
    description = "enter client mode",
    pattern = {'i'},
    handler = function(mode) mode.stop() end
  },
}

return launcher_commands
