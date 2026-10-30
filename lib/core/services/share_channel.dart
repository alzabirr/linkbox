import 'package:flutter/services.dart';

/// Talks to ShareActivity.kt (the Android share-sheet entry).
class ShareChannel {
  const ShareChannel();

  static const _channel = MethodChannel('linkbox/share');

  /// The shared text and subject (Chrome puts the page title in subject).
  Future<({String? text, String? subject})> getShared() async {
    final map = await _channel.invokeMapMethod<String, String?>('getShared');
    return (text: map?['text'], subject: map?['subject']);
  }

  /// Opens the main app at a saved link and closes the overlay.
  Future<void> openInApp(int linkId) =>
      _channel.invokeMethod('openInApp', {'id': linkId});

  /// Closes the overlay and returns to the other app.
  Future<void> close() => _channel.invokeMethod('close');
}
