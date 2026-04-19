# Desktop Environment Development Guide

Building a lightweight X11-based window manager and desktop environment.

## Overview

The desktop environment includes:
- Window manager for window management
- Widget system for UI components
- Input handling for keyboard/mouse
- Basic graphics and rendering
- Application launcher

## Architecture

```
Desktop Environment
├── Window Manager (X11)
│   ├── Event handling
│   ├── Window decoration
│   └── Input focus
├── Widget System
│   ├── Buttons
│   ├── Text fields
│   └── Menus
├── Graphics
│   ├── OpenGL rendering
│   ├── Font rendering
│   └── Image handling
└── Applications
    ├── Terminal emulator
    ├── File manager
    └── App launcher
```

## Building

### Prerequisites

```bash
sudo apt-get install -y libx11-dev libgl1-mesa-dev
sudo apt-get install -y x11-apps x11-utils
sudo apt-get install -y xterm fluxbox # For testing
```

### Build window manager

```bash
cd desktop
make build
```

Compiles `bin/window-manager`.

## Window Manager Implementation

### Starting the WM

```bash
# Set as your window manager
echo "exec /path/to/bin/window-manager" > ~/.xinitrc
startx
```

### Key Features

1. **Event Loop** - Handles X11 events
2. **Window Decoration** - Adds title bars and borders
3. **Input Focus** - manages keyboard/mouse focus
4. **Key Bindings** - Configurable shortcuts

### keybindings

```
Alt+F4        - Close window
Alt+Return     - Spawn terminal
Alt+Tab        - Switch windows
Alt+Click      - Move window
```

## Extending the WM

### Add new keybinding

In `src/window-manager.c`:

```c
if ((event->state & Mod1Mask) && keysym == XK_e) {
    printf("Running command...\n");
    system("application &");
}
```

### Handle new window events

```c
case ConfigureNotify:
    handle_configure_notify(&event.xconfigure);
    break;
```

## Widget System

Basic widget types to implement:

### Button Widget

```c
typedef struct {
    Window window;
    char label[256];
    int x, y, width, height;
    void (*callback)(void);
} Button;

Button *button_create(int x, int y, int w, int h, 
                     const char *label, void (*cb)(void));
void button_draw(Button *btn);
void button_click(Button *btn, int mx, int my);
void button_destroy(Button *btn);
```

### Text Input

```c
typedef struct {
    Window window;
    char buffer[512];
    int cursor_pos;
    int x, y, width, height;
} TextInput;

TextInput *text_input_create(int x, int y, int w, int h);
void text_input_key_press(TextInput *input, KeySym sym, char c);
void text_input_draw(TextInput *input);
```

## Graphics Rendering

### OpenGL Context

```c
#include <GL/gl.h>
#include <GL/glx.h>

typedef struct {
    Display *display;
    GLXContext glx_context;
    Window window;
} GLContext;

GLContext *gl_context_create(Display *display, Window window);
void gl_clear(void);
void gl_render_frame(void);
```

### TTF Font Rendering

Using FreeType:

```bash
sudo apt-get install libfreetype6-dev libfreetype6
```

## Terminal Emulator Widget

Basic terminal widget:

```c
typedef struct {
    Window window;
    char buffer[10000];
    int width, height;        // Terminal size in chars
    int rows, cols;
    char *command;
    pid_t child_pid;
} TerminalWidget;

TerminalWidget *terminal_create(int x, int y, int rows, int cols);
void terminal_write(TerminalWidget *term, const char *text);
void terminal_key_input(TerminalWidget *term, char c);
void terminal_render(TerminalWidget *term);
```

## Application Launcher

Create a simple application menu:

```c
// ~/.desk/applications.conf
[Application]
Name=Text Editor
Exec=gedit
Icon=text-editor

[Application]
Name=File Manager
Exec=pcmanfm
Icon=folder
```

## Theming

Create theme configuration:

```ini
# ~/.desk/theme.conf
[Colors]
bg_color = #1a1a1a
fg_color = #ffffff
accent_color = #0066cc

[Fonts]
default_font = DejaVu Sans
default_size = 11

[Decorations]
window_border_width = 2
title_bar_height = 25
```

## Testing

### Build and run

```bash
make run
```

### Debug with gdb

```bash
gdb ./bin/window-manager
(gdb) run
```

### X11 debugging

```bash
# Monitor X11 events
xev

# List open windows
xdotool search --onlyvisible --class .

# Get window info
xdotool getactivewindow getwindowgeometry
```

## Performance Optimization

1. **Double Buffering** - Reduce flicker
2. **Lazy Rendering** - Only redraw changed areas
3. **Event Coalescing** - Batch similar events
4. **Caching** - Cache font glyphs and images

## Advanced Features

### Workspace Management

```c
typedef struct {
    Window *windows;
    int num_windows;
    int visible;
} Workspace;

Workspace workspaces[4];
int current_workspace = 0;

void switch_workspace(int ws) {
    // Hide current workspace windows
    // Show new workspace windows
}
```

### Window Compositing

Implement transparency and effects:

```c
void apply_shadow(Window window);
void apply_opacity(Window window, double opacity);
void apply_blur(Window window, int radius);
```

## Troubleshooting

### X11 connection refused

```bash
export DISPLAY=:0
# Or use SSH X forwarding: ssh -X user@host
```

### Window manager not starting

```bash
# Check X11 logs
cat ~/.X11-errors

# Verify X11 display
echo $DISPLAY
```

### Input events not working

Check event mask in `XSelectInput()`:

```c
XSelectInput(display, window,
             KeyPressMask | KeyReleaseMask |
             ButtonPressMask | ButtonReleaseMask |
             PointerMotionMask);
```

## Resources

- X11 Programming: https://www.x.org/wiki/
- OpenGL Tutorials: https://learnopengl.com/
- FreeType Font API: https://www.freetype.org/
- Xlib reference: https://tronche.com/gui/x/xlib/

## Next Steps

1. Implement widget system
2. Add terminal emulator
3. Create application launcher
4. Implement workspace switching
5. Add window compositing
6. Optimize rendering performance
