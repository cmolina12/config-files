#!/bin/bash

if [ "${1:-}" = "--open" ] || [ "$SENDER" = "mouse.clicked" ]; then
  if osascript -e 'application "Spotify" is running' >/dev/null 2>&1; then
    open -a "Spotify"
    exit 0
  fi
  if osascript -e 'application "Music" is running' >/dev/null 2>&1; then
    open -a "Music"
    exit 0
  fi
  open -a "Music"
  exit 0
fi

artist=""
title=""

# Try Spotify first for better desktop media support.
if osascript -e 'application "Spotify" is running' >/dev/null 2>&1; then
  state="$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)"
  if [ "$state" = "playing" ] || [ "$state" = "paused" ]; then
    artist="$(osascript -e 'tell application "Spotify" to artist of current track as string' 2>/dev/null)"
    title="$(osascript -e 'tell application "Spotify" to name of current track as string' 2>/dev/null)"
  fi
fi

# Fallback to Apple Music.
if [ -z "$title" ] && osascript -e 'application "Music" is running' >/dev/null 2>&1; then
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
