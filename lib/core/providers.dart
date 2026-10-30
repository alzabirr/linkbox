import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'db/database.dart';
import 'repositories/collection_repository.dart';
import 'repositories/data_repository.dart';
import 'repositories/link_repository.dart';
import 'services/file_store.dart';
import 'services/metadata_service.dart';

part 'providers.g.dart';

/// Set in main() with the loaded instance.
final sharedPrefsProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

@Riverpod(keepAlive: true)
AppDatabase database(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
http.Client httpClient(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
}

@Riverpod(keepAlive: true)
MetadataService metadataService(Ref ref) =>
    MetadataService(ref.watch(httpClientProvider));

@Riverpod(keepAlive: true)
LinkRepository linkRepository(Ref ref) => LinkRepository(
      ref.watch(databaseProvider),
      ref.watch(metadataServiceProvider),
      FetchQueue(),
    );

@Riverpod(keepAlive: true)
CollectionRepository collectionRepository(Ref ref) =>
    CollectionRepository(ref.watch(databaseProvider));

@Riverpod(keepAlive: true)
DataRepository dataRepository(Ref ref) => DataRepository(
    ref.watch(databaseProvider), ref.watch(linkRepositoryProvider));

@Riverpod(keepAlive: true)
FileStore fileStore(Ref ref) => FileStore();
