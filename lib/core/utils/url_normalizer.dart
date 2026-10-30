/// Link helpers: validation, extraction and the duplicate-check key.
class UrlUtils {
  UrlUtils._();

  static final _urlInText = RegExp(r'https?://\S+', caseSensitive: false);

  /// Query keys that only track where a click came from.
  static const _tracking = {'fbclid', 'gclid', 'si', 'igshid', 'ref'};

  /// True when [input] is a full http(s) link with a host.
  static bool isValid(String input) {
    final s = input.trim();
    if (!RegExp(r'^https?://', caseSensitive: false).hasMatch(s)) return false;
    if (s.contains(RegExp(r'\s'))) return false;
    final uri = Uri.tryParse(s);
    return uri != null && uri.host.contains('.');
  }

  /// First http(s) link inside shared text, without trailing punctuation.
  static String? extractFirst(String text) {
    final m = _urlInText.firstMatch(text);
    if (m == null) return null;
    return m.group(0)!.replaceFirst(RegExp(r'''[)\]}>.,;:!?'"]+$'''), '');
  }

  /// "youtube.com" from "https://www.youtube.com/watch?v=1".
  static String domainOf(String url) {
    final host = Uri.tryParse(url.trim())?.host.toLowerCase() ?? '';
    return host.startsWith('www.') ? host.substring(4) : host;
  }

  /// Key used to find duplicates (BUILD_SPEC section 8):
  /// lowercase scheme + host, no `www.`, no fragment, no trailing `/`,
  /// no tracking params, YouTube short / mobile links → youtube.com/watch?v=.
  static String normalize(String url) {
    var uri = Uri.tryParse(url.trim());
    if (uri == null || uri.host.isEmpty) return url.trim().toLowerCase();

    var host = uri.host.toLowerCase();
    if (host.startsWith('www.')) host = host.substring(4);
    var path = uri.path;
    var query = Map<String, List<String>>.from(uri.queryParametersAll);

    if (host == 'm.youtube.com' || host == 'music.youtube.com') {
      host = 'youtube.com';
    }
    if (host == 'youtu.be' && path.length > 1) {
      final id = path.substring(1).split('/').first;
      host = 'youtube.com';
      path = '/watch';
      query = {...query, 'v': [id]};
    }
    if (host == 'youtube.com' && path.startsWith('/shorts/')) {
      final id = path.substring('/shorts/'.length).split('/').first;
      path = '/watch';
      query = {...query, 'v': [id]};
    }

    query.removeWhere((k, _) =>
        k.toLowerCase().startsWith('utm_') ||
        _tracking.contains(k.toLowerCase()));
    if (host == 'youtube.com' && path == '/watch') {
      // Only the video id matters (drop t=, list=, feature=…).
      query.removeWhere((k, _) => k != 'v');
    }

    while (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    if (path == '/') path = '';

    final keys = query.keys.toList()..sort();
    final q = [
      for (final k in keys)
        for (final v in query[k]!)
          '${Uri.encodeQueryComponent(k)}=${Uri.encodeQueryComponent(v)}'
    ].join('&');

    final port = uri.hasPort &&
            !((uri.scheme == 'http' && uri.port == 80) ||
                (uri.scheme == 'https' && uri.port == 443))
        ? ':${uri.port}'
        : '';
    return '${uri.scheme.toLowerCase()}://$host$port$path${q.isEmpty ? '' : '?$q'}';
  }
}
