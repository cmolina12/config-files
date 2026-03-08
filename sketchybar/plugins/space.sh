#!/bin/bash

if [ "$SELECTED" = "true" ]; then
	sketchybar --set "$NAME" background.drawing=on background.color=0xff4b5563 icon.color=0xffe5e7eb
else
	sketchybar --set "$NAME" background.drawing=on background.color=0xff2a2d34 icon.color=0xff9ca3af
fi
