#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>
#include <cairo/cairo.h>
#include <cairo/cairo-xlib.h>
#include <stdio.h>
#include <unistd.h>

struct MwmHints {
  unsigned long flags;
  unsigned long functions;
  unsigned long decorations;
  long input_mode;
  unsigned long status;
};
enum {
  MWM_HINTS_FUNCTIONS = (1L << 0),
  MWM_HINTS_DECORATIONS =  (1L << 1),

  MWM_FUNC_ALL = (1L << 0),
  MWM_FUNC_RESIZE = (1L << 1),
  MWM_FUNC_MOVE = (1L << 2),
  MWM_FUNC_MINIMIZE = (1L << 3),
  MWM_FUNC_MAXIMIZE = (1L << 4),
  MWM_FUNC_CLOSE = (1L << 5)
};

int main()
{
  int status;
  Display* xDisplay = XOpenDisplay(0);
  if (xDisplay == 0) {
    printf("Failed to connect to X. Terminating.\n");
    return 1;
  }
  int xScreen = DefaultScreen(xDisplay);
  Window xRoot = RootWindow(xDisplay, xScreen);
  int width = 100;
  int height = 100;
  XVisualInfo xVisualInfo;
  status = XMatchVisualInfo(xDisplay,
                            xScreen,
                            32,
                            TrueColor,
                            &xVisualInfo);
  if (status == 0) {
    printf("No 32-bit visual available from X. Terminating.\n");
    return 1;
  }
  XSetWindowAttributes xAttributes;
  xAttributes.background_pixmap = None;
  xAttributes.border_pixel = 0;
  xAttributes.colormap = XCreateColormap(xDisplay,
                                         xRoot,
                                         xVisualInfo.visual,
                                         AllocNone);
  xAttributes.event_mask = ExposureMask;
  int xAttributeMask = CWBackPixmap | CWBorderPixel | CWColormap | CWEventMask;
  Window xWindow = XCreateWindow(xDisplay,
                                 xRoot,
                                 0, 0,
                                 width, height,
                                 0,
                                 xVisualInfo.depth,
                                 InputOutput,
                                 xVisualInfo.visual,
                                 xAttributeMask,
                                 &xAttributes);

  // Make the window floating
  // I'd prefer "_NET_WM_WINDOW_TYPE_NOTIFICATION", but i3 still tiles that
  Atom windowType = XInternAtom(xDisplay, "_NET_WM_WINDOW_TYPE", 0);
  Atom windowTypeDesktop = XInternAtom(xDisplay, "_NET_WM_WINDOW_TYPE_UTILITY", 0);
  XChangeProperty(xDisplay,
                  xWindow,
                  windowType,
                  XA_ATOM,
                  32,
                  PropModeReplace,
                  (unsigned char*)&windowTypeDesktop,
                  1);

  // Remove the window decorations
  Atom motifHintsType = XInternAtom(xDisplay, "_MOTIF_WM_HINTS", 0);
  struct MwmHints motifHints;
  motifHints.flags = MWM_HINTS_DECORATIONS;
  motifHints.decorations = 0;
  XChangeProperty(xDisplay,
                  xWindow,
                  motifHintsType,
                  XA_ATOM,
                  32,
                  PropModeReplace,
                  (unsigned char*)&motifHints,
                  5);

  XMapWindow(xDisplay, xWindow);
  XSelectInput(xDisplay, xWindow, ExposureMask | KeyPressMask);

  // Create cairo surface
  cairo_surface_t* cs = cairo_xlib_surface_create(xDisplay,
                                                  xWindow,
                                                  xVisualInfo.visual,
                                                  width, height);
  cairo_xlib_surface_set_size(cs, width, height); // Is this really needed?

  // Create cairo context
  cairo_t* cr = cairo_create(cs);

  while (1) {
    XEvent e;
    XNextEvent(xDisplay, &e);
    if (e.type == Expose) {
      //XWindowAttributes xWinAttr;
      //int width, height;
      //XGetWindowAttributes(xDisplay, xWindow, &xWinAttr);
      //width = xWinAttr.width;
      //height = xWinAttr.height;

      cairo_save(cr);
      cairo_set_source_rgba(cr, 1.0, 0.0, 0.0, 0.5);
      cairo_set_operator(cr, CAIRO_OPERATOR_SOURCE);
      cairo_paint(cr);
      cairo_restore(cr);
    }
    if (e.type == KeyPress) {
      break;
    }
  }

  cairo_destroy(cr);
  cairo_surface_destroy(cs);
  XUnmapWindow(xDisplay, xWindow);
  XDestroyWindow(xDisplay, xWindow);
  XCloseDisplay(xDisplay);
}
