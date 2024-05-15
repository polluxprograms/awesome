#!/bin/sh

if pgrep alacritty ; then
	~/.cargo/bin/alacritty msg create-window "$@"
else
	~/.cargo/bin/alacritty "$@"
fi
