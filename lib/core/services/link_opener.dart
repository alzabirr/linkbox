import 'package:url_launcher/url_launcher.dart';

/// Opens a saved link in the browser or the app that owns it.
Future<bool> openLink(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
