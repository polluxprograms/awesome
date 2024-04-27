#!/bin/sh

if pgrep alacritty ; then
	alacritty msg create-window "$@"
else
	alacritty "$@"
fi
