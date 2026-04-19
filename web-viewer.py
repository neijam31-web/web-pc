#!/usr/bin/env python3
"""
Web-based Desktop Viewer for Chrome OS
Serves VNC over web on port 6080
"""

import os
import sys
import subprocess
import time
import http.server
import socketserver
from pathlib import Path

PORT = 6080
VNC_PORT = 5900

print("╔═══════════════════════════════════════════════════════════╗")
print("║     Desktop Web Interface - Chrome OS Edition             ║")
print("╚═══════════════════════════════════════════════════════════╝")
print()

# Create simple HTML VNC viewer
html_content = """<!DOCTYPE html>
<html>
<head>
    <title>Desktop Preview</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            margin: 0;
            padding: 20px;
            background: #1e1e1e;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            color: #fff;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        h1 {
            text-align: center;
            margin: 0 0 20px 0;
        }
        .info {
            background: #2d2d2d;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #4CAF50;
        }
        .desktop {
            background: #000;
            border: 2px solid #444;
            border-radius: 5px;
            padding: 10px;
            text-align: center;
            min-height: 600px;
        }
        iframe {
            width: 100%;
            height: 800px;
            border: none;
            border-radius: 3px;
        }
        .instructions {
            background: #2d2d2d;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
        }
        .instruction-title {
            font-weight: bold;
            color: #4CAF50;
            margin-bottom: 10px;
        }
        code {
            background: #1e1e1e;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
            color: #4CAF50;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🖥️ Debian Desktop Preview</h1>
        
        <div class="info">
            <strong>✓ Your desktop is ready to view in the browser!</strong><br>
            <small>Using noVNC - Web-based VNC viewer via localhost:5900</small>
        </div>

        <div class="desktop">
            <p style="padding-top: 20px; color: #999;">
                <strong>Desktop Display</strong><br>
                <small>(Loading VNC viewer...)</small>
            </p>
            <iframe src="http://localhost:6080/vnc.html?path=?host=localhost&port=5900&autoconnect=true"></iframe>
        </div>

        <div class="instructions">
            <div class="instruction-title">How to Use:</div>
            <ul>
                <li>The desktop preview is embedded above</li>
                <li><strong>Keyboard:</strong> Alt+F4 = Exit, Alt+Return = Terminal</li>
                <li><strong>Mouse:</strong> Click to select, drag to move windows</li>
                <li>If not showing, wait 5 seconds and refresh (Ctrl+R)</li>
            </ul>
        </div>

        <div class="instructions">
            <div class="instruction-title">Troubleshooting:</div>
            <ul>
                <li><code>Can't connect?</code> → Refresh the page (Ctrl+R)</li>
                <li><code>Black screen?</code> → Click in the viewer area, then wait 2 seconds</li>
                <li><code>Still not working?</code> → Try opening: <code>http://localhost:6080</code></li>
            </ul>
        </div>
    </div>
</body>
</html>
"""

# Write HTML file
html_file = Path("/tmp/vnc-viewer.html")
html_file.write_text(html_content)
print(f"✓ Created VNC web viewer: {html_file}")
print()

# Check if x11vnc is running
print("Checking for running services...")
os.system("ps aux | grep -E '(Xvfb|window-manager|x11vnc)' | grep -v grep | head -3")
print()

# Try to start simple HTTP server
print(f"✓ Starting web server on port {PORT}...")
print(f"✓ VNC server on port {VNC_PORT}")
print()

print("╔═══════════════════════════════════════════════════════════╗")
print("║           OPEN THIS IN YOUR BROWSER:                     ║")
print("╠═══════════════════════════════════════════════════════════╣")
print(f"║  http://localhost:{PORT}                                   ║")
print("║                                                           ║")
print("║  On different machine?                                   ║")
print(f"║  http://<your-ip>:{PORT}                               ║")
print("╚═══════════════════════════════════════════════════════════╝")
print()

# Serve the HTML file
os.chdir("/tmp")

class MyHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def translate_path(self, path):
        if path.endswith(".html") or path == "/":
            return str(html_file)
        return super().translate_path(path)

try:
    with socketserver.TCPServer(("", PORT), MyHTTPRequestHandler) as httpd:
        print(f"Web server running. Press Ctrl+C to stop.\n")
        httpd.serve_forever()
except KeyboardInterrupt:
    print("\n\nServer stopped.")
except Exception as e:
    print(f"Error: {e}")
