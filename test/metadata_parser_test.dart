import 'package:flutter_test/flutter_test.dart';
import 'package:linkbox/core/services/metadata_parser.dart';
import 'package:linkbox/core/widgets/scene_art.dart';

void main() {
  final page = Uri.parse('https://example.com/blog/post');

  test('prefers Open Graph tags', () {
    final m = MetadataParser.parse('''
      <html><head>
        <title>Plain title</title>
        <meta property="og:title" content="OG &amp; title">
        <meta property="og:description" content="OG description">
        <meta property="og:image" content="/img/cover.png">
        <meta property="og:site_name" content="Example">
        <meta name="twitter:title" content="Twitter title">
      </head></html>''', page);
    expect(m.title, 'OG & title');
    expect(m.description, 'OG description');
    expect(m.imageUrl, 'https://example.com/img/cover.png');
    expect(m.siteName, 'Example');
    expect(m.kind, LinkKind.article);
  });

  test('falls back to twitter tags, then <title> and meta description', () {
    final m = MetadataParser.parse('''
      <head><title>  Just   a title </title>
      <meta name="twitter:image" content="//cdn.example.com/a.jpg">
      <meta name="description" content="Plain description"></head>''', page);
    expect(m.title, 'Just a title');
    expect(m.description, 'Plain description');
    expect(m.imageUrl, 'https://cdn.example.com/a.jpg');
  });

  test('uses the largest apple-touch-icon when there is no image', () {
    final m = MetadataParser.parse('''
      <link rel="apple-touch-icon" sizes="76x76" href="small.png">
      <link rel="apple-touch-icon" sizes="180x180" href="big.png">''', page);
    expect(m.imageUrl, 'https://example.com/blog/big.png');
  });

  test('survives broken HTML and cuts long titles to 120', () {
    final m = MetadataParser.parse(
        '<title>${'a' * 300}<div><meta property="og:type" content="video.other"',
        page);
    expect(m.title!.length, lessThanOrEqualTo(120));
    expect(MetadataParser.parse('<<<>>>', page).isEmpty, isTrue);
  });

  test('kind from site and og:type', () {
    expect(MetadataParser.kindFor('https://youtu.be/x'), LinkKind.video);
    expect(MetadataParser.kindFor('https://www.reddit.com/r/x'), LinkKind.post);
    expect(MetadataParser.kindFor('https://x.com/a/status/1'), LinkKind.post);
    expect(MetadataParser.kindFor('https://a.com', ogType: 'video.movie'),
        LinkKind.video);
    expect(MetadataParser.kindFor('https://a.com'), LinkKind.article);
  });
}
