import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

import '../utils/url_normalizer.dart';
import '../widgets/scene_art.dart';

/// What we could learn about a page.
class LinkMetadata {
  const LinkMetadata({
    this.title,
    this.description,
    this.imageUrl,
    this.siteName,
    this.kind = LinkKind.article,
  });

  final String? title;
  final String? description;
  final String? imageUrl;
  final String? siteName;
  final LinkKind kind;

  bool get isEmpty => title == null && description == null && imageUrl == null;
}

/// Reads Open Graph / Twitter / plain HTML tags (BUILD_SPEC section 8).
class MetadataParser {
  MetadataParser._();

  static const maxTitle = 120;

  static LinkMetadata parse(String body, Uri pageUrl) {
    final doc = html.parse(body);

    String? meta(String key) {
      for (final el in doc.querySelectorAll('meta')) {
        final k = (el.attributes['property'] ?? el.attributes['name'] ?? '')
            .toLowerCase();
        if (k == key) {
          final v = _clean(el.attributes['content']);
          if (v != null) return v;
        }
      }
      return null;
    }

    final title = meta('og:title') ??
        meta('twitter:title') ??
        _clean(doc.querySelector('title')?.text);
    final description = meta('og:description') ??
        meta('twitter:description') ??
        meta('description');
    final image = meta('og:image') ??
        meta('og:image:url') ??
        meta('og:image:secure_url') ??
        meta('twitter:image') ??
        meta('twitter:image:src') ??
        _touchIcon(doc);

    return LinkMetadata(
      title: title == null ? null : _cut(title, maxTitle),
      description: description,
      imageUrl: image == null ? null : _absolute(image, pageUrl),
      siteName: meta('og:site_name'),
      kind: kindFor(pageUrl.toString(), ogType: meta('og:type')),
    );
  }

  /// YouTube / Vimeo or og:type video → video; Reddit / X → post.
  static LinkKind kindFor(String url, {String? ogType}) {
    final d = UrlUtils.domainOf(url);
    bool on(String site) => d == site || d.endsWith('.$site');
    if (on('youtube.com') || on('youtu.be') || on('vimeo.com')) {
      return LinkKind.video;
    }
    if (ogType != null && ogType.toLowerCase().startsWith('video')) {
      return LinkKind.video;
    }
    if (on('reddit.com') || on('x.com') || on('twitter.com')) {
      return LinkKind.post;
    }
    return LinkKind.article;
  }

  /// Largest apple-touch-icon.
  static String? _touchIcon(Document doc) {
    String? best;
    var bestSize = -1;
    for (final el in doc.querySelectorAll('link[rel]')) {
      final rel = el.attributes['rel']!.toLowerCase();
      if (!rel.contains('apple-touch-icon')) continue;
      final href = _clean(el.attributes['href']);
      if (href == null) continue;
      final size = int.tryParse(
              (el.attributes['sizes'] ?? '').toLowerCase().split('x').first) ??
          0;
      if (size > bestSize) {
        best = href;
        bestSize = size;
      }
    }
    return best;
  }

  static String? _absolute(String url, Uri base) {
    final resolved = base.resolve(url.startsWith('//') ? '${base.scheme}:$url' : url);
    return resolved.hasScheme && resolved.scheme.startsWith('http')
        ? resolved.toString()
        : null;
  }

  static String? _clean(String? s) {
    if (s == null) return null;
    final t = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    return t.isEmpty ? null : t;
  }

  static String _cut(String s, int max) =>
      s.length <= max ? s : '${s.substring(0, max - 1).trimRight()}…';
}
