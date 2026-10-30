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
  });

  final int id;
  final String name;
  final Color color;
  final String icon;
  final bool pinned;
}
