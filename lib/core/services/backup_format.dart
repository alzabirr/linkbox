import 'dart:convert';

import 'package:html/parser.dart' as html;

/// A collection inside a backup or import.
class BackupCollection {
  const BackupCollection({
    required this.id,
    required this.name,
    this.color,
    this.icon,
    this.pinned = false,
  });

  /// Only links this backup together; new ids are given on restore.
  final int id;
  final String name;
  final String? color;
  final String? icon;
  final bool pinned;
}

/// A link inside a backup or import.
class BackupLink {
  const BackupLink({
    required this.url,
    this.title,
    this.description,
    this.imageUrl,
    this.siteName,
    this.kind,
    this.collectionId,
    this.createdAt,
  });

  final String url;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? siteName;
  final String? kind;
  final int? collectionId;

  /// UTC.
  final DateTime? createdAt;
}

/// Everything in a backup file (BUILD_SPEC section 7).
class BackupData {
  const BackupData({
    required this.collections,
    required this.links,
    this.exportedAt,
  });

  final List<BackupCollection> collections;
  final List<BackupLink> links;
  final DateTime? exportedAt;
}

/// Reads and writes the backup JSON and the browser bookmark HTML
/// (Netscape format). No I/O here, so it is easy to test.
class BackupFormat {
  BackupFormat._();

  static const version = 1;

  // ---------------------------------------------------------------- JSON

  static String toJson(BackupData data) {
    final map = {
      'app': 'linkbox',
      'version': version,
      'exportedAt': (data.exportedAt ?? DateTime.now()).toUtc().toIso8601String(),
      'collections': [
        for (final c in data.collections)
          {
            'id': c.id,
            'name': c.name,
            'color': ?c.color,
            'icon': ?c.icon,
            'pinned': c.pinned,
          },
      ],
      'links': [
        for (final l in data.links)
          {
            'url': l.url,
            'title': ?l.title,
            'description': ?l.description,
            'imageUrl': ?l.imageUrl,
            'siteName': ?l.siteName,
            'kind': ?l.kind,
            'collectionId': ?l.collectionId,
            if (l.createdAt != null)
              'createdAt': l.createdAt!.toUtc().toIso8601String(),
          },
      ],
    };
    return const JsonEncoder.withIndent('  ').convert(map);
  }

  /// Throws [FormatException] if this is not a Linkly backup.
  static BackupData fromJson(String text) {
    final Object? root;
    try {
      root = jsonDecode(text);
    } on FormatException {
      throw const FormatException('Not JSON');
    }
    if (root is! Map<String, dynamic> || root['app'] != 'linkbox') {
      throw const FormatException('Not a Linkly backup');
    }
    final v = root['version'];
    if (v is! int || v > version) {
      throw const FormatException('Backup is from a newer version');
    }

    String? str(Object? o) => o is String && o.trim().isNotEmpty ? o : null;
    DateTime? date(Object? o) =>
        o is String ? DateTime.tryParse(o)?.toUtc() : null;

    final collections = <BackupCollection>[
      for (final c in (root['collections'] as List? ?? const []))
        if (c is Map && c['id'] is int && str(c['name']) != null)
          BackupCollection(
            id: c['id'] as int,
            name: str(c['name'])!,
            color: str(c['color']),
            icon: str(c['icon']),
            pinned: c['pinned'] == true,
          ),
    ];
    final links = <BackupLink>[
      for (final l in (root['links'] as List? ?? const []))
        if (l is Map && str(l['url']) != null)
          BackupLink(
            url: str(l['url'])!,
            title: str(l['title']),
            description: str(l['description']),
            imageUrl: str(l['imageUrl']),
            siteName: str(l['siteName']),
            kind: str(l['kind']),
            collectionId: l['collectionId'] is int ? l['collectionId'] as int : null,
            createdAt: date(l['createdAt']),
          ),
    ];
    return BackupData(
        collections: collections,
        links: links,
        exportedAt: date(root['exportedAt']));
  }

  // ------------------------------------------------------- Bookmark HTML

  /// Netscape bookmark file: one folder (<H3>) per collection.
  static String toBookmarkHtml(BackupData data) {
    String esc(String s) => const HtmlEscape().convert(s);
    String a(BackupLink l) {
      final added = l.createdAt == null
          ? ''
          : ' ADD_DATE="${l.createdAt!.millisecondsSinceEpoch ~/ 1000}"';
      return '<DT><A HREF="${esc(l.url)}"$added>${esc(l.title ?? l.url)}</A>';
    }

    final b = StringBuffer()
      ..writeln('<!DOCTYPE NETSCAPE-Bookmark-file-1>')
      ..writeln('<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">')
      ..writeln('<TITLE>Bookmarks</TITLE>')
      ..writeln('<H1>Bookmarks</H1>')
      ..writeln('<DL><p>');
    for (final c in data.collections) {
      final inside = data.links.where((l) => l.collectionId == c.id);
      b
        ..writeln('    <DT><H3>${esc(c.name)}</H3>')
        ..writeln('    <DL><p>');
      for (final l in inside) {
        b.writeln('        ${a(l)}');
      }
      b.writeln('    </DL><p>');
    }
    final ids = data.collections.map((c) => c.id).toSet();
    for (final l in data.links.where((l) => !ids.contains(l.collectionId))) {
      b.writeln('    ${a(l)}');
    }
    b.writeln('</DL><p>');
    return b.toString();
  }

  /// Reads a browser bookmark export. Each folder becomes a collection
  /// (nested folders use their own name; the bookmarks bar itself is not a
  /// collection). Throws [FormatException] if no links are found.
  static BackupData fromBookmarkHtml(String text) {
    // Walk the tags in order: <H3> names the next <DL>; <A> belongs to the
    // innermost named folder.
    final tags = RegExp(
      r'<h3([^>]*)>(.*?)</h3>|<dl[^>]*>|</dl>|<a\s([^>]*)>(.*?)</a>',
      caseSensitive: false,
      dotAll: true,
    );
    final ids = <String, int>{}; // lowercase name → id
    final collections = <BackupCollection>[];
    final links = <BackupLink>[];
    final stack = <int?>[];
    int? pending; // folder named by the last <H3>, waiting for its <DL>
    var pendingSet = false;

    String plain(String s) => html.parseFragment(s).text?.trim() ?? '';
    String? attr(String attrs, String name) => RegExp(
          '$name\\s*=\\s*"([^"]*)"',
          caseSensitive: false,
        ).firstMatch(attrs)?.group(1);

    for (final m in tags.allMatches(text)) {
      final tag = m.group(0)!.toLowerCase();
      if (tag.startsWith('<h3')) {
        final isBar = (m.group(1) ?? '')
            .toLowerCase()
            .contains('personal_toolbar_folder');
        final name = plain(m.group(2) ?? '');
        pendingSet = true;
        pending = isBar || name.isEmpty
            ? null
            : ids.putIfAbsent(name.toLowerCase(), () {
                final id = ids.length + 1;
                collections.add(BackupCollection(id: id, name: name));
                return id;
              });
      } else if (tag.startsWith('<dl')) {
        // A folder inherits its parent's collection when it has no name.
        stack.add(pendingSet ? pending ?? _top(stack) : _top(stack));
        pending = null;
        pendingSet = false;
      } else if (tag == '</dl>') {
        if (stack.isNotEmpty) stack.removeLast();
      } else {
        final attrs = m.group(3) ?? '';
        final href = plain(attr(attrs, 'href') ?? '');
        if (!href.startsWith(RegExp(r'https?://', caseSensitive: false))) {
          continue;
        }
        final added = int.tryParse(attr(attrs, 'add_date') ?? '');
        final title = plain(m.group(4) ?? '');
        links.add(BackupLink(
          url: href,
          title: title.isEmpty || title == href ? null : title,
          collectionId: _top(stack),
          createdAt: added == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(
                  // Some browsers write microseconds.
                  added > 100000000000 ? added ~/ 1000 : added * 1000,
                  isUtc: true),
        ));
      }
    }
    if (links.isEmpty) throw const FormatException('No links');
    // Drop folders that ended up with no links.
    final used = links.map((l) => l.collectionId).toSet();
    return BackupData(
      collections: collections.where((c) => used.contains(c.id)).toList(),
      links: links,
    );
  }

  static int? _top(List<int?> stack) => stack.isEmpty ? null : stack.last;
}
