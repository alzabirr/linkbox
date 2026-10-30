import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

@immutable
class CollectionItem {
  const CollectionItem({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.pinned,
    required this.createdAt,
  });

  final int id;
  final String name;
  final Color color;
  final String icon;
  final bool pinned;

  /// UTC; "Updated …" falls back to this while the collection is empty.
  final DateTime createdAt;
}
