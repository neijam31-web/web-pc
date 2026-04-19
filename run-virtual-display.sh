#!/bin/bash
# Virtual Display Setup - All in one

echo "Starting Virtual Display Setup..."
echo ""

# Start Xvfb in background
echo "1. Starting virtual display server..."
Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
XVFB_PID=$!
echo "   ✓ Xvfb running (PID: $XVFB_PID)"

# Give it a moment to start
sleep 2

# Set display and run window manager
echo ""
echo "2. Setting DISPLAY=:99..."
export DISPLAY=:99
echo "   ✓ DISPLAY set"

echo ""
echo "3. Starting window manager..."
cd /workspaces/web-pc/desktop
./bin/window-manager &
WM_PID=$!
echo "   ✓ Window manager running (PID: $WM_PID)"

echo ""
echo "════════════════════════════════════════════"
echo "✓ DESKTOP IS RUNNING ON VIRTUAL DISPLAY :99"
echo "════════════════════════════════════════════"
echo ""
echo "Display: $DISPLAY"
echo "Xvfb (PID $XVFB_PID): Running"
echo "Window Manager (PID $WM_PID): Running"
echo ""
echo "To connect to the desktop:"
echo "  • Option 1: Connect via VNC client to :99"
echo "  • Option 2: Use x11vnc: x11vnc -display :99"
echo "  • Option 3: Use xwdtopnm to capture screen"
echo ""
echo "Press Ctrl+C to stop"
echo ""

# Keep processes running
wait $WM_PID
