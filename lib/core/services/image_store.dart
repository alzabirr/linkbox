import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Lets the user pick their own picture for a link and keeps a copy in the
/// app's private folder (the gallery file may be moved or deleted later).
class ImageStore {
  const ImageStore();

  /// Returns the saved file path, or null if the user cancelled.
  Future<String?> pickForLink(int linkId) async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (picked == null) return null;
    final dir = Directory('${(await getApplicationDocumentsDirectory()).path}/images');
    await dir.create(recursive: true);
    final ext = picked.path.contains('.') ? picked.path.split('.').last : 'jpg';
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final target = '${dir.path}/link-$linkId-$stamp.$ext';
    await File(picked.path).copy(target);
    return target;
  }
}
