#!/bin/bash

# Desktop Preview Script - No X11 Required
# Works in headless/container environments

echo "=========================================="
echo "Desktop Preview - Web Interface"
echo "=========================================="
echo ""

# Check if running in container without X11
if [ -z "$DISPLAY" ] || [ ! -e /tmp/.X11-unix ]; then
    echo "No X11 display detected. Running in headless mode."
    echo ""
    echo "OPTIONS:"
    echo ""
    echo "1. DOCKER with X11 (if you have X11 on host):"
    echo "   docker build -t my-desktop-image ."
    echo "   docker run -e DISPLAY=\$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -it my-desktop-image"
    echo ""
    echo "2. DIRECT BUILD (faster testing):"
    echo "   cd /workspaces/web-pc/desktop"
    echo "   make run"
    echo ""
    echo "3. VIEW SOURCE CODE:"
    echo "   cat /workspaces/web-pc/desktop/src/window-manager.c"
    echo ""
    exit 0
fi

echo "X11 display found: $DISPLAY"
echo ""
echo "Starting window manager..."
echo ""

# Run the window manager
cd /workspaces/web-pc/desktop
./bin/window-manager

echo ""
echo "Window manager stopped."
