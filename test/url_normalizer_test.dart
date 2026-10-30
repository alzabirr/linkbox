import 'package:flutter_test/flutter_test.dart';
import 'package:linkbox/core/utils/url_normalizer.dart';

void main() {
  group('normalize', () {
    final n = UrlUtils.normalize;

    test('lowercases scheme and host, drops www', () {
      expect(n('HTTPS://WWW.Example.COM/Path'), 'https://example.com/Path');
    });
    test('removes fragment and trailing slash', () {
      expect(n('https://example.com/a/#top'), 'https://example.com/a');
      expect(n('https://example.com/'), 'https://example.com');
    });
    test('removes tracking params, keeps others sorted', () {
      expect(
          n('https://example.com/a?utm_source=x&b=2&fbclid=1&a=1&gclid=3&ref=hn'),
          'https://example.com/a?a=1&b=2');
      expect(n('https://instagram.com/p/1?igshid=abc'),
          'https://instagram.com/p/1');
    });
    test('youtu.be, m.youtube.com and shorts become youtube.com/watch?v=', () {
      const want = 'https://youtube.com/watch?v=abc123';
      expect(n('https://youtu.be/abc123?si=XYZ'), want);
      expect(n('https://m.youtube.com/watch?v=abc123&feature=share'), want);
      expect(n('https://www.youtube.com/watch?v=abc123&t=42s'), want);
      expect(n('https://youtube.com/shorts/abc123'), want);
    });
    test('same page from different shares matches', () {
      expect(n('https://example.com/post?utm_medium=social'),
          n('https://www.example.com/post/'));
    });
  });

  group('isValid', () {
    test('needs http(s) and a host', () {
      expect(UrlUtils.isValid('https://example.com'), isTrue);
      expect(UrlUtils.isValid('http://a.b/c?d=1'), isTrue);
      expect(UrlUtils.isValid('example.com'), isFalse);
      expect(UrlUtils.isValid('ftp://example.com'), isFalse);
      expect(UrlUtils.isValid('https://'), isFalse);
      expect(UrlUtils.isValid('https://exa mple.com'), isFalse);
    });
  });

  test('extractFirst finds the link inside shared text', () {
    expect(UrlUtils.extractFirst('Watch this! https://youtu.be/x1. So good'),
        'https://youtu.be/x1');
    expect(UrlUtils.extractFirst('no link here'), isNull);
  });

  test('domainOf', () {
    expect(UrlUtils.domainOf('https://www.YouTube.com/watch'), 'youtube.com');
    expect(UrlUtils.domainOf('https://docs.flutter.dev/x'), 'docs.flutter.dev');
  });
}
