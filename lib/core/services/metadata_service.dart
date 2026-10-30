import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../utils/url_normalizer.dart';
import '../widgets/scene_art.dart';
import 'metadata_parser.dart';

/// Why a preview could not be fetched.
class MetadataException implements Exception {
  const MetadataException({this.offline = false});

  /// No connection: try again later instead of marking the link failed.
  final bool offline;
}

/// Downloads a page and reads its title, summary and image.
class MetadataService {
  MetadataService(this._client);

  final http.Client _client;

  static const timeout = Duration(seconds: 10);
  static const _maxBytes = 512 * 1024;
  static const _userAgent =
      'Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36';

  Future<LinkMetadata> fetch(String url) async {
    try {
      final uri = Uri.parse(url.trim());
      if (MetadataParser.kindFor(url) == LinkKind.video &&
          UrlUtils.domainOf(url).contains('youtu')) {
        final yt = await _youtube(uri);
        if (yt != null) return yt;
      }
      final body = await _download(uri).timeout(timeout);
      final meta = MetadataParser.parse(body, uri);
      if (meta.isEmpty) throw const MetadataException();
      return meta;
    } on SocketException {
      throw const MetadataException(offline: true);
    } on http.ClientException catch (e) {
      throw MetadataException(offline: e.message.contains('Failed host lookup'));
    } on TimeoutException {
      throw const MetadataException();
    } on MetadataException {
      rethrow;
    } catch (_) {
      throw const MetadataException();
    }
  }

  /// Reads at most 512 KB of HTML.
  Future<String> _download(Uri uri) async {
    final request = http.Request('GET', uri)
      ..followRedirects = true
      ..maxRedirects = 5
      ..headers.addAll({
        'User-Agent': _userAgent,
        'Accept': 'text/html,application/xhtml+xml',
        'Accept-Language': 'en,bn;q=0.8',
      });
    final response = await _client.send(request);
    if (response.statusCode >= 400) throw const MetadataException();
    final type = response.headers['content-type'] ?? '';
    if (type.isNotEmpty && !type.contains('html')) {
      throw const MetadataException();
    }

    final bytes = <int>[];
    await for (final chunk in response.stream) {
      bytes.addAll(chunk);
      if (bytes.length >= _maxBytes) break;
    }
    final latin = RegExp(r'charset=(iso-8859-1|latin1|windows-1252)',
            caseSensitive: false)
        .hasMatch(type);
    return latin
        ? latin1.decode(bytes, allowInvalid: true)
        : utf8.decode(bytes, allowMalformed: true);
  }

  /// YouTube's oEmbed gives a reliable title and thumbnail.
  Future<LinkMetadata?> _youtube(Uri uri) async {
    try {
      final api = Uri.https('www.youtube.com', '/oembed',
          {'url': uri.toString(), 'format': 'json'});
      final res = await _client.get(api).timeout(timeout);
      if (res.statusCode != 200) return null;
      final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
      final title = json['title'] as String?;
      if (title == null) return null;
      return LinkMetadata(
        title: title.length > MetadataParser.maxTitle
            ? '${title.substring(0, MetadataParser.maxTitle - 1)}…'
            : title,
        description: json['author_name'] as String?,
        imageUrl: json['thumbnail_url'] as String?,
        siteName: 'YouTube',
        kind: LinkKind.video,
      );
    } on SocketException {
      rethrow;
    } catch (_) {
      return null;
    }
  }
}

/// Runs preview fetches, at most [maxConcurrent] at a time.
class FetchQueue {
  FetchQueue({this.maxConcurrent = 3});

  final int maxConcurrent;
  final _waiting = Queue<Future<void> Function()>();
  final _queued = <Object>{};
  var _running = 0;

  /// Adds a job unless one with the same [key] is already waiting/running.
  void add(Object key, Future<void> Function() job) {
    if (!_queued.add(key)) return;
    _waiting.add(() async {
      try {
        await job();
      } finally {
        _queued.remove(key);
      }
    });
    _pump();
  }

  void _pump() {
    while (_running < maxConcurrent && _waiting.isNotEmpty) {
      final job = _waiting.removeFirst();
      _running++;
      job().whenComplete(() {
        _running--;
        _pump();
      });
    }
  }
}
