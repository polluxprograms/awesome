#!/bin/sh

run() {
  if ! pgrep -f "$1"; then
    "$@" &
  fi
}


# Lock stuff
run xss-lock -- betterlockscreen -l
betterlockscreen -u $HOME/Wallpapers &
xset s on
xset s 300

# Misc Daemons
run gentoo-pipewire-launcher
run playerctld daemon
# run gammastep
run mpd
run mpDris2

run keepassxc
run pomo.sh notify

run syncthing
