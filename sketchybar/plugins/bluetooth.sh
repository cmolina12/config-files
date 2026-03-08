#!/bin/bash

state="$(defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState 2>/dev/null)"

if [ "$state" = "1" ]; then
  label="On"
  icon="􀂯"
else
  label="Off"
  icon="􀂱"
fi

sketchybar --set "$NAME" icon="$icon" label="$label"
