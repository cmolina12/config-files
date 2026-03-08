#!/bin/bash

# Use airport for SSID and quality, fallback to icon-only if unavailable.
airport_bin="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

if [ -x "$airport_bin" ]; then
  info="$($airport_bin -I 2>/dev/null)"
  ssid="$(echo "$info" | awk -F': ' '/ SSID/ {print $2}' | head -n1)"
  rssi="$(echo "$info" | awk -F': ' '/ agrCtlRSSI/ {print $2}' | head -n1)"

  if [ -n "$ssid" ]; then
    if [ -n "$rssi" ] && [ "$rssi" -ge -60 ] 2>/dev/null; then
      icon="􀙇"
    elif [ -n "$rssi" ] && [ "$rssi" -ge -75 ] 2>/dev/null; then
      icon="􀙅"
    else
      icon="􀙄"
    fi
    sketchybar --set "$NAME" icon="$icon" label="$ssid"
    exit 0
  fi
fi

sketchybar --set "$NAME" icon="􀙈" label="Offline"
