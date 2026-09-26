import 'package:html_unescape/html_unescape.dart';

class HtmlUtils {
  static final HtmlUnescape _unescape = HtmlUnescape();

  /// Decodes HTML entities in a given string.
  /// Handles null or empty strings safely.
  static String unescape(String? text) {
    if (text == null || text.isEmpty) return '';
    return _unescape.convert(text);
  }
}
