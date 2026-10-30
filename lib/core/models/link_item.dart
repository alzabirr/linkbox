import 'package:flutter/foundation.dart';

import '../widgets/scene_art.dart';

enum FetchStatus { pending, ok, failed }

/// A saved link, as the UI sees it.
@immutable
class LinkItem {
  const LinkItem({
    required this.id,
    required this.url,
    required this.domain,
    required this.kind,
    required this.fetchStatus,
    required this.createdAt,
    this.title,
    this.description,
    this.imageUrl,
    this.customImagePath,
    this.siteName,
    this.collectionId,
  });

  final int id;
  final String url;
  final String domain;
  final LinkKind kind;
  final FetchStatus fetchStatus;

  /// UTC.
  final DateTime createdAt;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? customImagePath;
  final String? siteName;
  final int? collectionId;

  /// Title, or the link without "https://" when there is none yet.
  String get displayTitle {
    final t = title?.trim();
    if (t != null && t.isNotEmpty) return t;
    return url.replaceFirst(RegExp(r'^https?://(www\.)?'), '');
  }
}
