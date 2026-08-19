#!/bin/bash

# --- SETUP ---

# 1. Unload the existing bell module (silences the error you saw)
# We ignore errors here in case it wasn't loaded.
pactl unload-module module-x11-bell > /dev/null 2>&1

# 2. Remove any old sample named 'lock-fail' to avoid conflicts
pactl remove-sample lock-fail > /dev/null 2>&1

# 3. Upload your sound
# Note: If this fails silently, convert your MP3 to WAV. 
# PulseAudio is sometimes picky about MP3s.
pactl upload-sample "/home/sec/Music/vine-boom.wav" lock-fail

# 4. Load the module pointing to your sound
pactl load-module module-x11-bell sample=lock-fail display=$DISPLAY > /dev/null

# 5. Force X11 bell to be ON
xset b 100     # Set volume to 100%
xset b on      # Ensure it is enabled

# --- EXECUTE ---

# Run i3lock with --beep
# The script waits here until you unlock
i3lock \
  -ef \
  -i '/home/sec/wallpapers/keys.png' \
  --nofork \
  --beep

# --- CLEANUP ---

# Unload our custom bell module
pactl unload-module module-x11-bell > /dev/null 2>&1

# Remove the sample from memory
pactl remove-sample lock-fail > /dev/null 2>&1

# (Optional) Reload the default bell if you want standard beeps back
# pactl load-module module-x11-bell > /dev/null 2>&1
