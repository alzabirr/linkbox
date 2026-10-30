import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:linkbox/core/db/database.dart';
import 'package:linkbox/core/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// In-memory database + fake internet, for tests.
Future<List<Override>> testOverrides({
  AppDatabase? db,
  http.Client? client,
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return [
    sharedPrefsProvider.overrideWithValue(prefs),
    databaseProvider.overrideWithValue(db ?? memoryDb()),
    httpClientProvider.overrideWithValue(client ?? fakePages()),
  ];
}

AppDatabase memoryDb() => AppDatabase(DatabaseConnection(
    NativeDatabase.memory(), closeStreamsSynchronously: true));

/// Every page has a title; pages under /broken return 500.
http.Client fakePages() => MockClient((req) async {
      if (req.url.path.startsWith('/broken')) return http.Response('', 500);
      return http.Response(
        '<html><head><title>Page ${req.url.path}</title>'
        '<meta property="og:description" content="About ${req.url.host}">'
        '</head></html>',
        200,
        headers: {'content-type': 'text/html; charset=utf-8'},
      );
    });
