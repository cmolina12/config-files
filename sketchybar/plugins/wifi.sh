#!/bin/bash

airport_bin="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

wifi_device="$(networksetup -listallhardwareports 2>/dev/null | awk '/Hardware Port: Wi-Fi/{getline; print $2; exit}')"
ssid=""
rssi=""

if [ -n "$wifi_device" ]; then
  current_network="$(networksetup -getairportnetwork "$wifi_device" 2>/dev/null)"
  if echo "$current_network" | grep -q "Current Wi-Fi Network:"; then
    ssid="$(echo "$current_network" | sed 's/^Current Wi-Fi Network: //')"
  fi
fi

# Use airport only for signal quality when available.
if [ -n "$ssid" ] && [ -x "$airport_bin" ]; then
  info="$($airport_bin -I 2>/dev/null)"
  rssi="$(echo "$info" | awk -F': ' '/ agrCtlRSSI/ {print $2}' | head -n1)"
fi

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

# Fallback: internet may still be reachable even when no Wi-Fi SSID is associated
# (for example, VPN/tunnel/other interface while keeping this item visible).
if scutil --nwi 2>/dev/null | grep -Eq 'REACH : flags .*Reachable'; then
  sketchybar --set "$NAME" icon="􀙇" label="Online"
  exit 0
fi

sketchybar --set "$NAME" icon="􀙈" label="Offline"
