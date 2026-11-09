import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:linkbox/core/models/link_item.dart';
import 'package:linkbox/core/providers.dart';
import 'package:linkbox/core/services/backup_format.dart';
import 'package:linkbox/core/services/metadata_service.dart';
import 'package:linkbox/core/widgets/scene_art.dart';

import 'helpers/test_app.dart';

void main() {
  test('YouTube uses oEmbed for title and thumbnail', () async {
    final client = MockClient((req) async {
      expect(req.url.path, '/oembed');
      return http.Response(
          '{"title":"Biryani","author_name":"Chef","thumbnail_url":"https://i.ytimg.com/x.jpg"}',
          200);
    });
    final m = await MetadataService(client).fetch('https://youtu.be/abc');
    expect(m.title, 'Biryani');
    expect(m.imageUrl, 'https://i.ytimg.com/x.jpg');
    expect(m.kind, LinkKind.video);
  });

  test('no connection → "offline", other errors → failed', () async {
    final offline = MockClient((_) async => throw const SocketException('x'));
    expect(
        () => MetadataService(offline).fetch('https://example.com'),
        throwsA(isA<MetadataException>()
            .having((e) => e.offline, 'offline', isTrue)));
    final broken = MockClient((_) async => http.Response('', 404));
    expect(
        () => MetadataService(broken).fetch('https://example.com'),
        throwsA(isA<MetadataException>()
            .having((e) => e.offline, 'offline', isFalse)));
    final notHtml = MockClient((_) async => http.Response('%PDF', 200,
        headers: {'content-type': 'application/pdf'}));
    expect(() => MetadataService(notHtml).fetch('https://example.com/a.pdf'),
        throwsA(isA<MetadataException>()));
  });

  test('Facebook error page: a title from the link, not "failed"', () async {
    final fb = MockClient((_) async => http.Response(
        '<title>Error Facebook</title>', 400,
        headers: {'content-type': 'text/html'}));
    final m = await MetadataService(fb)
        .fetch('https://www.facebook.com/share/v/1HtoHsKBLQ/');
    expect(m.title, 'Facebook video');
    expect(m.kind, LinkKind.video);
    expect(m.imageUrl, isNull);
    final offline = MockClient((_) async => throw const SocketException('x'));
    expect(
        () => MetadataService(offline)
            .fetch('https://www.facebook.com/share/v/1HtoHsKBLQ/'),
        throwsA(isA<MetadataException>()
            .having((e) => e.offline, 'offline', isTrue)));
  });

  test('Facebook: tries preview-app names until one gives a picture', () async {
    final agents = <String>[];
    final fb = MockClient((req) async {
      agents.add(req.headers['User-Agent']!);
      if (agents.length < 2) {
        return http.Response('<title>Log in to Facebook</title>', 200,
            headers: {'content-type': 'text/html'});
      }
      return http.Response(
          '<meta property="og:title" content="Biryani at home">'
          '<meta property="og:image" content="https://scontent.xx.fbcdn.net/a.jpg?x=1&amp;y=2">',
          200,
          headers: {'content-type': 'text/html; charset="utf-8"'});
    });
    final m = await MetadataService(fb)
        .fetch('https://www.facebook.com/share/v/1HtoHsKBLQ/');
    expect(agents, MetadataService.metaAgents.take(2).toList());
    expect(m.title, 'Biryani at home');
    expect(m.imageUrl, 'https://scontent.xx.fbcdn.net/a.jpg?x=1&y=2');
    expect(m.siteName, 'Facebook');
    expect(m.kind, LinkKind.video);
  });

  test('Instagram with no preview: a title from the link', () async {
    final ig = MockClient((_) async => http.Response('', 429));
    final m = await MetadataService(ig)
        .fetch('https://www.instagram.com/reel/DAbc123/');
    expect(m.title, 'Instagram reel');
    expect(m.kind, LinkKind.video);
    final post = await MetadataService(ig)
        .fetch('https://www.instagram.com/p/DAbc123/');
    expect(post.title, 'Instagram post');
    expect(post.kind, LinkKind.post);
  });

  test('a page that never answers fails after the timeout', () async {
    final slow = MockClient((_) => Completer<http.Response>().future);
    await expectLater(
        MetadataService(slow).fetch('https://example.com')
            .timeout(MetadataService.timeout + const Duration(seconds: 2)),
        throwsA(isA<MetadataException>()));
  }, timeout: const Timeout(Duration(seconds: 20)));

  test('offline save stays "pending" and is fetched later', () async {
    var online = false;
    final client = MockClient((req) async {
      if (!online) throw const SocketException('offline');
      return http.Response('<title>Back online</title>', 200,
          headers: {'content-type': 'text/html'});
    });
    final c = ProviderContainer(overrides: await testOverrides(client: client));
    addTearDown(c.dispose);
    final repo = c.read(linkRepositoryProvider);
    final id = await repo.add('https://example.com/a');
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect((await repo.findById(id))!.fetchStatus, FetchStatus.pending);

    online = true;
    await repo.resumePending();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    final link = (await repo.findById(id))!;
    expect(link.fetchStatus, FetchStatus.ok);
    expect(link.title, 'Back online');
  });

  test('fetch queue runs at most 3 at once', () async {
    final queue = FetchQueue();
    var running = 0, most = 0;
    final done = <Future<void>>[];
    for (var i = 0; i < 10; i++) {
      final c = Completer<void>();
      done.add(c.future);
      queue.add(i, () async {
        running++;
        most = running > most ? running : most;
        await Future<void>.delayed(const Duration(milliseconds: 10));
        running--;
        c.complete();
      });
    }
    await Future.wait(done);
    expect(most, 3);
  });

  test('2,000 links: search answers in under 300 ms', () async {
    final c = ProviderContainer(overrides: await testOverrides(
        client: MockClient((_) async => http.Response('', 500))));
    addTearDown(c.dispose);
    final data = c.read(dataRepositoryProvider);
    await data.import(await _bigBackup(2000));
    final repo = c.read(linkRepositoryProvider);
    final sw = Stopwatch()..start();
    final hits = await repo.watchLinks(query: 'recipe 19').first;
    sw.stop();
    expect(hits, isNotEmpty);
    expect(sw.elapsedMilliseconds, lessThan(300));
  });

}

Future<BackupData> _bigBackup(int n) async => BackupData(
      collections: const [],
      links: [
        for (var i = 0; i < n; i++)
          BackupLink(
              url: 'https://example.com/$i',
              title: 'Recipe $i',
              description: 'Saved recipe number $i'),
      ],
    );
