import 'package:flutter/services.dart';

import '../utils/url_normalizer.dart';

/// Reads a link from the clipboard. Only call while the app is in the
/// foreground (Android 10+ blocks background reads).
class ClipboardService {
  const ClipboardService();

  Future<String?> readLink() async {
    // hasStrings does not trigger Android 12's "pasted" toast; getData does.
    if (!await Clipboard.hasStrings()) return null;
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) return null;
    if (UrlUtils.isValid(text)) return text;
    return UrlUtils.extractFirst(text);
  }
}
