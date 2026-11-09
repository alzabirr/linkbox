import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers.dart';
import '../../core/repositories/data_repository.dart';
import '../../core/services/backup_format.dart';
import '../../core/services/file_store.dart';

part 'data_controller.g.dart';

/// When the last backup was written (`last_backup_at`).
@riverpod
class LastBackup extends _$LastBackup {
  static const _key = 'last_backup_at';

  @override
  DateTime? build() => DateTime.tryParse(
      ref.watch(sharedPrefsProvider).getString(_key) ?? '');

  void set(DateTime at) {
    state = at;
    ref.read(sharedPrefsProvider).setString(_key, at.toUtc().toIso8601String());
  }
}

/// A backup file with what's inside, for the Restore page (28).
class BackupChoice {
  const BackupChoice({
    required this.label,
    required this.data,
    this.size,
  });

  final String label;
  final BackupData data;

  /// Bytes; null for a file the user picked.
  final int? size;
}

/// Backup, restore, import and export actions (14, 28).
class DataActions {
  DataActions(this.ref);

  final Ref ref;

  DataRepository get _data => ref.read(dataRepositoryProvider);
  FileStore get _files => ref.read(fileStoreProvider);

  static String _stamp() =>
      DateFormat('yyyy-MM-dd-HHmm').format(DateTime.now());

  /// Writes linkly-backup-YYYY-MM-DD-HHmm.json to Download/Linkly.
  /// Throws [FileStoreException].
  Future<String> backupNow() async {
    final json = BackupFormat.toJson(await _data.exportAll());
    final name =
        await _files.saveToDownloads('linkly-backup-${_stamp()}.json', json);
    ref.read(lastBackupProvider.notifier).set(DateTime.now());
    return name;
  }

  Future<String> exportHtml() async => _files.saveToDownloads(
      'linkly-export-${_stamp()}.html',
      BackupFormat.toBookmarkHtml(await _data.exportAll()));

  Future<String> exportJson() async => _files.saveToDownloads(
      'linkly-export-${_stamp()}.json',
      BackupFormat.toJson(await _data.exportAll()));

  /// Picks a browser export and adds its links. Null if cancelled.
  /// Throws [FormatException] or [FileStoreException].
  Future<ImportResult?> importBrowserFile() async {
    final text = await _files.pickText();
    if (text == null) return null;
    return _data.import(BackupFormat.fromBookmarkHtml(text));
  }

  /// Backups in Download/Linkly, newest first; unreadable ones are skipped.
  Future<List<BackupChoice>> listBackups() async {
    final out = <BackupChoice>[];
    for (final f in await _files.listBackups()) {
      try {
        out.add(BackupChoice(
          label: DateFormat.yMMMd().add_jm().format(f.modified),
          data: BackupFormat.fromJson(await _files.readUri(f.uri)),
          size: f.size,
        ));
      } on Exception {
        // Not readable or not a backup: leave it out.
      }
    }
    return out;
  }

  /// Lets the user pick a backup file. Null if cancelled.
  /// Throws [FormatException] or [FileStoreException].
  Future<BackupData?> pickBackup() async {
    final text = await _files.pickText();
    return text == null ? null : BackupFormat.fromJson(text);
  }

  Future<ImportResult> restore(BackupData data, {required bool replace}) =>
      _data.import(data, replace: replace);

  Future<int> linkCount() => _data.linkCount();
}

@Riverpod(keepAlive: true)
DataActions dataActions(Ref ref) => DataActions(ref);
