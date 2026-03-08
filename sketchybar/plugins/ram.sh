#!/bin/bash

# vm_stat reports pages; convert active memory footprint to GB.
page_size="$(vm_stat | head -n1 | awk '{print $8}' | tr -d '.')"
active="$(vm_stat | awk '/Pages active/ {gsub("\\.","",$3); print $3}')"
wired="$(vm_stat | awk '/Pages wired down/ {gsub("\\.","",$4); print $4}')"
compressed="$(vm_stat | awk '/Pages occupied by compressor/ {gsub("\\.","",$5); print $5}')"

if [ -z "$page_size" ] || [ -z "$active" ] || [ -z "$wired" ] || [ -z "$compressed" ]; then
  sketchybar --set "$NAME" icon="􀫦" label="--"
  exit 0
fi

bytes=$(( (active + wired + compressed) * page_size ))
gb="$(awk -v b="$bytes" 'BEGIN { printf "%.1f", b/1073741824 }')"

sketchybar --set "$NAME" icon="􀫦" label="${gb}G"
