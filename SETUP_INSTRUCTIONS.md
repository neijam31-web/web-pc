#!/bin/bash
# Desktop Preview - Complete Setup Guide

cat << 'EOF'

╔═══════════════════════════════════════════════════════════════════╗
║          DESKTOP PREVIEW - COMPLETE SETUP GUIDE                  ║
╚═══════════════════════════════════════════════════════════════════╝

YOUR DESKTOP IS READY! ✓

Status:
  ✓ Window Manager: Running (PID: Check with 'ps aux | grep window-manager')
  ✓ Virtual Display: :99 (1024x768)
  ✓ VNC Server: Running on localhost:5900
  ✓ Connection: Ready for VNC Viewer

═══════════════════════════════════════════════════════════════════

STEP-BY-STEP INSTRUCTIONS:

1. DOWNLOAD VNC VIEWER
   ─────────────────────────────────────────────────────────────
   
   Choose FOR YOUR OPERATING SYSTEM:
   
   📍 WINDOWS:
      • RealVNC Viewer: https://www.realvnc.com/download/viewer/
      • Or TightVNC: https://www.tightvnc.com/download.php
      
   📍 MAC:
      • RealVNC Viewer: https://www.realvnc.com/download/viewer/
      • Or use built-in: Open "Screen Sharing" app
      
   📍 LINUX:
      • Remmina: sudo apt-get install remmina
      • Or VNC Viewer: https://www.realvnc.com/download/viewer/

2. INSTALL THE VNC VIEWER
   ─────────────────────────────────────────────────────────────
   
   Run the installer you downloaded
   Follow the on-screen prompts
   (Usually just click "Next" → "Install" → "Finish")

3. OPEN VNC VIEWER
   ─────────────────────────────────────────────────────────────
   
   Launch the application
   You'll see an address bar or connection dialog

4. ENTER CONNECTION ADDRESS
   ─────────────────────────────────────────────────────────────
   
   Type this address:
   
        localhost:5900
   
   (Or alternatively: 127.0.0.1:5900)

5. CLICK CONNECT
   ─────────────────────────────────────────────────────────────
   
   Press Enter or click "Connect" button
   No password needed
   Wait 1-2 seconds for connection

6. SEE YOUR DESKTOP!
   ─────────────────────────────────────────────────────────────
   
   You'll see:
   • A 1024×768 pixel window
   • Your Debian-styled Window Manager
   • Ready for interaction

═══════════════════════════════════════════════════════════════════

ONCE CONNECTED - HOW TO USE:

Keyboard Shortcuts:
  • Alt+F4      → Exit window manager
  • Alt+Return  → Open terminal
  • Click       → Select windows
  • Drag        → Move windows

Mouse:
  • Left click  → Select/interact
  • Right click → Context menu
  • Scroll      → Scroll content

═══════════════════════════════════════════════════════════════════

TROUBLESHOOTING:

❌ "Cannot connect to localhost:5900"
   → Make sure you downloaded and opened a VNC VIEWER
   → Check firewall settings (port 5900 should be allowed)
   → Try 127.0.0.1 instead of localhost

❌ "Connection refused"
   → VNC server might not be running
   → Run: DISPLAY=:99 x11vnc -forever -nopw &

❌ "Black screen"
   → Give it 2-3 seconds to render
   → Try moving your mouse to wake it up
   → Resize the window

═══════════════════════════════════════════════════════════════════

QUICK LINKS:

RealVNC Download: https://www.realvnc.com/en/connect/download/viewer/
TightVNC Download: https://www.tightvnc.com/download.php
Remmina (Linux): https://remmina.org/

═══════════════════════════════════════════════════════════════════

NEED HELP?

Desktop files location:
  /workspaces/web-pc/desktop/bin/window-manager

Documentation:
  /workspaces/web-pc/PREVIEW_GUIDE.md
  /workspaces/web-pc/complete-setup.sh
  /workspaces/web-pc/access-desktop.sh

Processes running:
  Xvfb :99          → Virtual display
  window-manager    → Your desktop app
  x11vnc -port 5900 → VNC server

═══════════════════════════════════════════════════════════════════

✅ YOU'RE ALL SET! 

Your desktop is running and waiting for you to connect via VNC.

Next: Download VNC Viewer → Connect to localhost:5900 → Enjoy! 🎉

═══════════════════════════════════════════════════════════════════

EOF
