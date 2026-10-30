import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers.dart';
import '../../core/repositories/link_repository.dart';
import '../../core/services/clipboard_service.dart';

part 'clipboard_prompt_controller.g.dart';

/// The link offered in "Save the link you copied?" (02), or null.
@Riverpod(keepAlive: true)
class ClipboardPrompt extends _$ClipboardPrompt {
  static const _lastKey = 'last_clipboard_url';
  var _checking = false;

  @override
  String? build() => null;

  /// Called when the app comes to the foreground; reads the clipboard once.
  Future<void> check() async {
    if (_checking || state != null) return;
    _checking = true;
    try {
      final url = await const ClipboardService().readLink();
      if (url == null) return;
      final prefs = ref.read(sharedPrefsProvider);
      if (prefs.getString(_lastKey) == url) return;
      if (await ref.read(linkRepositoryProvider).findByUrl(url) != null) {
        return;
      }
      // Remember it so the same link is never offered twice.
      await prefs.setString(_lastKey, url);
      state = url;
    } finally {
      _checking = false;
    }
  }

  void dismiss() => state = null;

  Future<void> save() async {
    final url = state;
    state = null;
    if (url == null) return;
    try {
      await ref.read(linkRepositoryProvider).add(url);
    } on DuplicateLinkException {
      // Saved meanwhile (e.g. from the share sheet): nothing to do.
    }
  }
}
