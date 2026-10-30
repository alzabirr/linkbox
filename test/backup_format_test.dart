import 'package:flutter_test/flutter_test.dart';
import 'package:linkbox/core/services/backup_format.dart';

const chromeExport = '''
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>
    <DT><H3 ADD_DATE="1700000000" PERSONAL_TOOLBAR_FOLDER="true">Bookmarks bar</H3>
    <DL><p>
        <DT><A HREF="https://flutter.dev/" ADD_DATE="1700000100">Flutter &amp; Dart</A>
        <DT><H3>Recipes</H3>
        <DL><p>
            <DT><A HREF="https://example.com/biryani" ADD_DATE="1700000200">Biryani</A>
            <DT><H3>Desserts</H3>
            <DL><p>
                <DT><A HREF="https://example.com/cake">Cake</A>
            </DL><p>
            <DT><A HREF="https://example.com/korma"></A>
        </DL><p>
        <DT><A HREF="javascript:alert(1)">Bookmarklet</A>
    </DL><p>
    <DT><H3>Empty folder</H3>
    <DL><p>
    </DL><p>
    <DT><A HREF="https://other.org/">Other</A>
</DL><p>
''';

void main() {
  group('bookmark HTML import', () {
    final data = BackupFormat.fromBookmarkHtml(chromeExport);
    String? folderOf(String url) {
      final link = data.links.firstWhere((l) => l.url == url);
      final c = data.collections.where((c) => c.id == link.collectionId);
      return c.isEmpty ? null : c.first.name;
    }

    test('reads http links only', () {
      expect(data.links.map((l) => l.url), [
        'https://flutter.dev/',
        'https://example.com/biryani',
        'https://example.com/cake',
        'https://example.com/korma',
        'https://other.org/',
      ]);
    });
    test('folders become collections; bookmarks bar does not', () {
      expect(folderOf('https://flutter.dev/'), isNull);
      expect(folderOf('https://example.com/biryani'), 'Recipes');
      expect(folderOf('https://example.com/cake'), 'Desserts');
      expect(folderOf('https://example.com/korma'), 'Recipes');
      expect(folderOf('https://other.org/'), isNull);
      expect(data.collections.map((c) => c.name), ['Recipes', 'Desserts']);
    });
    test('titles, entities, missing titles, dates', () {
      final f = data.links.first;
      expect(f.title, 'Flutter & Dart');
      expect(f.createdAt, DateTime.utc(2023, 11, 14, 22, 15));
      expect(data.links[3].title, isNull);
    });
    test('1,000+ links', () {
      final big = StringBuffer('<DL><p>');
      for (var i = 0; i < 1500; i++) {
        big.writeln('<DT><A HREF="https://e.com/$i">Link $i</A>');
      }
      expect(BackupFormat.fromBookmarkHtml('$big</DL>').links, hasLength(1500));
    });
    test('not a bookmark file', () {
      expect(() => BackupFormat.fromBookmarkHtml('<p>hello</p>'),
          throwsFormatException);
    });
  });

  group('JSON backup', () {
    final data = BackupData(
      collections: const [
        BackupCollection(id: 2, name: 'Design', color: '#FF9FC4', icon: 'star'),
      ],
      links: [
        BackupLink(
            url: 'https://a.com',
            title: 'A',
            collectionId: 2,
            createdAt: DateTime.utc(2026, 10, 28, 15, 14)),
        const BackupLink(url: 'https://b.com'),
      ],
    );

    test('round trip keeps everything', () {
      final back = BackupFormat.fromJson(BackupFormat.toJson(data));
      expect(back.collections.single.name, 'Design');
      expect(back.collections.single.color, '#FF9FC4');
      expect(back.links.first.collectionId, 2);
      expect(back.links.first.createdAt, DateTime.utc(2026, 10, 28, 15, 14));
      expect(back.links.last.title, isNull);
    });
    test('rejects other files and newer versions', () {
      expect(() => BackupFormat.fromJson('nope'), throwsFormatException);
      expect(() => BackupFormat.fromJson('{"app":"other"}'),
          throwsFormatException);
      expect(() => BackupFormat.fromJson('{"app":"linkbox","version":99}'),
          throwsFormatException);
    });
    test('HTML export can be imported again', () {
      final back =
          BackupFormat.fromBookmarkHtml(BackupFormat.toBookmarkHtml(data));
      expect(back.links, hasLength(2));
      expect(back.collections.single.name, 'Design');
    });
  });
}
