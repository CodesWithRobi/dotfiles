#!/bin/bash

DEVICE_ID=13
STATE=$(xinput list-props "$DEVICE_ID" | grep "Device Enabled" | awk '{print $4}')

if [ "$STATE" -eq 1 ]; then
    xinput disable "$DEVICE_ID"
    notify-send "Trackpad Disabled"
else
    xinput enable "$DEVICE_ID"
    notify-send "Trackpad Enabled"
fi
