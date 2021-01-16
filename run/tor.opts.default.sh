#!/usr/bin/env bash

# PulseAudio process file location
PA_PID="$HOME/.config/pulse/`hostname`-runtime/pid"

# VNC port exposed
EXTERNAL_PORT_VNC=5801

# PulseAudio port exposed
EXTERNAL_PORT_PULASE_AUDIO=4000

# Width of display
DISPLAY_WIDTH=1426

# Height of display
DISPLAY_HEIGHT=897

# Local folder to map inside VM, appears as /app/host
SHARED_LOCAL_FOLDER="$HOME/tmp"

# Docker Image
DOCKER_IMAGE_TAG="domistyle/tor-browser"

# PulseAudio needs the IP of your host to connect
HOST_IP=$(ip)

