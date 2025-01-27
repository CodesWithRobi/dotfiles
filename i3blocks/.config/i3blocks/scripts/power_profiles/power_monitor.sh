#!/usr/bin/env python3

import time
import os

# Path to the power state file
POWER_STATE_FILE = "/sys/class/power_supply/AC/online"

# Custom script to trigger on state change
CUSTOM_SCRIPT = "/home/sec/.config/i3blocks/scripts/power_profiles/power_profile_toggle.sh"

# Polling interval (adjust for your needs)
POLL_INTERVAL = 5.0  # seconds

def read_power_state():
    with open(POWER_STATE_FILE, 'r') as file:
        return file.read()
def monitor_power_state():
    last_state = read_power_state()
    if last_state is None:
        return

    # print(f"Initial power state: {last_state}")

    while True:
        current_state = read_power_state()
        if current_state is None:
            break

        # Trigger action only if the state changes
        if current_state != last_state:
            # print(f"Power state changed: {last_state} -> {current_state}")
            os.system(f"{CUSTOM_SCRIPT} {current_state}")
            last_state = current_state

        # Sleep for the polling interval
        time.sleep(POLL_INTERVAL)

if __name__ == "__main__":
    monitor_power_state()
