#!/bin/sh

run() {
  if ! pgrep -f "$1"; then
    "$@" &
  fi
}

# Graphics Daemons
run picom --config $HOME/.config/awesome/picom.conf

# Lock
run xss-lock -- betterlockscreen -l -- -n
betterlockscreen -u $HOME/Wallpapers &
xset s on
xset s 300

# Audio/Music Daemons
run gentoo-pipewire-launcher
run playerctld daemon
run mpd
run mpDris2

# Background Programs
run keepassxc
run pomo.sh notify
run syncthing
