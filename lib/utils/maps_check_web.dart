// Web implementation to check if Google Maps JS API is available
import 'dart:html' as html;

bool isMapsLoaded() {
  try {
    final g = html.window['google'];
    if (g == null) return false;
    final maps = (g as dynamic)['maps'];
    return maps != null;
  } catch (_) {
    return false;
  }
}
