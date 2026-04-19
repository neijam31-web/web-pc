/* 
 * Debian-styled Lightweight Window Manager
 * A minimal X11-based window manager for custom distributions
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/keysym.h>
#include <X11/Xatom.h>

/* Window manager state */
typedef struct {
    Display *display;
    int screen;
    Window root;
    int width;
    int height;
    unsigned long bg_pixel;
    unsigned long fg_pixel;
} WMState;

WMState state;
int running = 1;

/**
 * Initialize window manager
 */
int wm_init(void) {
    state.display = XOpenDisplay(NULL);
    if (!state.display) {
        fprintf(stderr, "Cannot open X display\n");
        return 0;
    }
    
    state.screen = DefaultScreen(state.display);
    state.root = RootWindow(state.display, state.screen);
    state.width = DisplayWidth(state.display, state.screen);
    state.height = DisplayHeight(state.display, state.screen);
    
    /* Get colors */
    Colormap cmap = DefaultColormap(state.display, state.screen);
    XColor bg, fg;
    XAllocNamedColor(state.display, cmap, "black", &bg, &bg);
    XAllocNamedColor(state.display, cmap, "white", &fg, &fg);
    
    state.bg_pixel = bg.pixel;
    state.fg_pixel = fg.pixel;
    
    /* Set root window properties */
    XSetWindowBackground(state.display, state.root, state.bg_pixel);
    XClearWindow(state.display, state.root);
    
    /* Select events */
    XSelectInput(state.display, state.root,
                 SubstructureRedirectMask | SubstructureNotifyMask |
                 KeyPressMask | ButtonPressMask | MotionNotify);
    
    fprintf(stdout, "Window Manager initialized\n");
    fprintf(stdout, "Screen: %dx%d\n", state.width, state.height);
    
    return 1;
}

/**
 * Handle key press events
 */
void handle_key_press(XKeyEvent *event) {
    KeySym keysym = XLookupKeysym(event, 0);
    
    /* Alt+F4 to quit */
    if ((event->state & Mod1Mask) && keysym == XK_F4) {
        printf("Exit signal received (Alt+F4)\n");
        running = 0;
    }
    
    /* Alt+Return to spawn terminal */
    if ((event->state & Mod1Mask) && keysym == XK_Return) {
        printf("Spawning terminal...\n");
        system("xterm &");
    }
}

/**
 * Handle window creation
 */
void handle_map_request(XMapRequestEvent *event) {
    printf("Window map request: 0x%lx\n", event->window);
    
    XMapWindow(state.display, event->window);
    XSetInputFocus(state.display, event->window, RevertToPointerRoot, CurrentTime);
}

/**
 * Main event loop
 */
void event_loop(void) {
    XEvent event;
    
    while (running) {
        XNextEvent(state.display, &event);
        
        switch (event.type) {
            case KeyPress:
                handle_key_press(&event.xkey);
                break;
            case MapRequest:
                handle_map_request(&event.xmaprequest);
                break;
            case DestroyNotify:
                printf("Window destroyed: 0x%lx\n", event.xdestroywindow.window);
                break;
            case ConfigureRequest:
                printf("Configure request received\n");
                break;
            case Expose:
                printf("Expose event\n");
                break;
        }
    }
}

/**
 * Cleanup window manager
 */
void wm_cleanup(void) {
    if (state.display) {
        XCloseDisplay(state.display);
    }
    fprintf(stdout, "Window Manager cleaned up\n");
}

/**
 * Main entry point
 */
int main(int argc, char *argv[]) {
    fprintf(stdout, "Debian-styled Window Manager v1.0\n");
    fprintf(stdout, "Controls: Alt+F4 (exit), Alt+Return (terminal)\n\n");
    
    if (!wm_init()) {
        return EXIT_FAILURE;
    }
    
    event_loop();
    
    wm_cleanup();
    
    return EXIT_SUCCESS;
}
