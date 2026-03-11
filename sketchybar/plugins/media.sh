#!/bin/bash

is_running() {
  [ "$(osascript -e "application \"$1\" is running" 2>/dev/null)" = "true" ]
}

if [ "${1:-}" = "--open" ]; then
  if is_running "Spotify"; then
    open -a "Spotify"
    exit 0
  fi
  if is_running "Music"; then
    open -a "Music"
    exit 0
  fi
  exit 0
fi

artist=""
title=""

# Try Spotify first for better desktop media support.
if is_running "Spotify"; then
  state="$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)"
  if [ "$state" = "playing" ] || [ "$state" = "paused" ]; then
    artist="$(osascript -e 'tell application "Spotify" to artist of current track as string' 2>/dev/null)"
    title="$(osascript -e 'tell application "Spotify" to name of current track as string' 2>/dev/null)"
  fi
fi

# Fallback to Apple Music.
if [ -z "$title" ] && is_running "Music"; then
  state="$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null)"
  if [ "$state" = "playing" ] || [ "$state" = "paused" ]; then
    artist="$(osascript -e 'tell application "Music" to artist of current track as string' 2>/dev/null)"
    title="$(osascript -e 'tell application "Music" to name of current track as string' 2>/dev/null)"
  fi
fi

if [ -n "$title" ]; then
  if [ -n "$artist" ]; then
    label="$artist - $title"
  else
    label="$title"
  fi

  sketchybar --set "$NAME" drawing=on label="$label" icon="􀑪"
else
  sketchybar --set "$NAME" drawing=on label="No media" icon="􀑨"
fi
