#!/bin/bash

# Argument to determine charging or discharging state
STATE=$1

if [ "$STATE" == "1" ]; then
    # Set to performance profile when charging
    powerprofilesctl set performance
    cat /home/sec/.config/picom/picom_performance > /home/sec/.config/picom/picom.conf
    pkill -SIGRTMIN+15 i3blocks
    # notify-send "Power Profile" "Switched to Performance mode (Charging)" -u low
elif [ "$STATE" == "0" ]; then
    # Set to power-saving profile when on battery
    powerprofilesctl set power-saver
    cat /home/sec/.config/picom/picom_power_saver > /home/sec/.config/picom/picom.conf
    pkill -SIGRTMIN+15 i3blocks
    # notify-send "Power Profile" "Switched to Power-Saving mode (Battery)" -u low
else
    echo "Unknown state: $STATE" >> /tmp/power_profile_errors.log
fi
