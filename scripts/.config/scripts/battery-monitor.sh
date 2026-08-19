#!/bin/bash

WARN_LEVEL=15
CRITICAL_LEVEL=5
EMERGENCY_LEVEL=3

POLL_INTERVAL=60
POLL_FAST=10

warned=0
critical=0

while true; do
    level=$(cat /sys/class/power_supply/BAT0/capacity)
    status=$(cat /sys/class/power_supply/BAT0/status)

    if [ "$status" = "Charging" ]; then
        warned=0
        critical=0
        sleep "$POLL_INTERVAL"
        continue
    fi

    if [ "$level" -le "$EMERGENCY_LEVEL" ] && [ "$critical" -lt 2 ]; then
        critical=2
        notify-send -u critical -t 0 "BATTERY EMERGENCY" "Battery at ${level}%. Saving tmux and shutting down now." -i battery-caution
        tmux run-shell '~/.tmux/plugins/tmux-resurrect/scripts/save.sh' 2>/dev/null
        sleep 2
        systemctl poweroff
        break
    fi

    if [ "$level" -le "$CRITICAL_LEVEL" ] && [ "$critical" -lt 1 ]; then
        critical=1
        notify-send -u critical -t 0 "BATTERY CRITICAL" "Battery at ${level}%. Plug in NOW!" -i battery-caution
        poll=$POLL_FAST
    else
        poll=$POLL_INTERVAL
    fi

    if [ "$level" -le "$WARN_LEVEL" ] && [ "$warned" -eq 0 ]; then
        warned=1
        notify-send -u normal -t 10000 "Low Battery" "Battery at ${level}%. Plug in soon." -i battery-low
    fi

    sleep "$poll"
done
