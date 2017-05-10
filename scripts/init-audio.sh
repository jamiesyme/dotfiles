#!/bin/bash

# Set the default output port to the rear jack
pacmd set-sink-port alsa_output.pci-0000_00_14.2.analog-stereo analog-output-lineout

# Set the audio level to something reasonable
# Without this, alsa can't seem to figure out any sort of default volume level
amixer -c 0 set Master 85%
amixer -D pulse set Master 85%

# Initialize maudio
# This will restore last-known volume levels and muted devices
maudio sync
