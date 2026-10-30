import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';

/// A backup file in Download/Linkbox.
class BackupFileInfo {
  const BackupFileInfo({
    required this.uri,
    required this.name,
    required this.size,
    required this.modified,
  });

  final String uri;
  final String name;

  /// Bytes.
  final int size;
  final DateTime modified;
}

/// Thrown when a file can't be written or read.
class FileStoreException implements Exception {
  const FileStoreException();
}

/// Download/Linkbox files (MediaStore: no storage permission on Android 10+)
/// and the system file picker.
class FileStore {
  FileStore();

  static const _channel = MethodChannel('linkbox/files');
  static const folder = 'Linkbox';
  static bool _ready = false;

  Future<void> _init() async {
    if (_ready) return;
    await MediaStore.ensureInitialized();
    MediaStore.appFolder = folder;
    _ready = true;
  }

  /// Writes [content] to Download/Linkbox/[fileName]; returns the saved name.
  Future<String> saveToDownloads(String fileName, String content) async {
    try {
      await _init();
      final temp = File('${(await getTemporaryDirectory()).path}/$fileName');
      await temp.writeAsString(content);
      final info = await MediaStore().saveFile(
        tempFilePath: temp.path,
        dirType: DirType.download,
        dirName: DirName.download,
      );
      // media_store_plus moves the temp file, so it may already be gone.
      if (await temp.exists()) await temp.delete();
      if (info == null) throw const FileStoreException();
      return info.name;
    } on FileStoreException {
      rethrow;
    } catch (e) {
      debugPrint('Linkbox: saving $fileName failed: $e');
      throw const FileStoreException();
    }
  }

  /// Backups this install wrote, newest first.
  Future<List<BackupFileInfo>> listBackups() async {
    try {
      final rows = await _channel.invokeListMethod<Map>('listBackups') ?? [];
      return [
        for (final r in rows)
          BackupFileInfo(
            uri: r['uri'] as String,
            name: r['name'] as String,
            size: (r['size'] as num).toInt(),
            modified: DateTime.fromMillisecondsSinceEpoch(
                (r['modified'] as num).toInt()),
          ),
      ];
    } on PlatformException {
      return const [];
    } on MissingPluginException {
      return const [];
    }
  }

  Future<String> readUri(String uri) async {
    try {
      final text = await _channel.invokeMethod<String>('readText', {'uri': uri});
      if (text == null) throw const FileStoreException();
      return text;
    } on PlatformException {
      throw const FileStoreException();
    }
  }

  /// Lets the user pick any file; returns its text, or null if cancelled.
  Future<String?> pickText() async {
    final files = await FilePicker.pickFiles();
    if (files.isEmpty) return null;
    try {
      return await files.single.xFile.readAsString();
    } catch (_) {
      throw const FileStoreException();
    }
  }
}
