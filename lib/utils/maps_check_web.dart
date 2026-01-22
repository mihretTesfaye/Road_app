// Web implementation to check if Google Maps JS API is available
import 'dart:js_util' as js_util;
import 'dart:html' as html;

bool isMapsLoaded() {
  try {
    final g = js_util.getProperty(html.window, 'google');
    if (g == null) return false;

    final maps = js_util.getProperty(g, 'maps');
    return maps != null;
  } catch (_) {
    return false;
  }
}
