#!/bin/bash

if [ "$SENDER" = "front_app_switched" ] && [ -n "$INFO" ]; then
  sketchybar --set "$NAME" label="Active: $INFO"
  exit 0
fi

current_app="$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true' 2>/dev/null)"
if [ -n "$current_app" ]; then
  sketchybar --set "$NAME" label="Active: $current_app"
fi
