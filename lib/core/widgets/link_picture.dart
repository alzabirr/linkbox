import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';

/// A link's picture: the user's own image first, then the page image,
/// else [fallback] (usually the drawn scene).
class LinkPicture extends StatelessWidget {
  const LinkPicture({
    super.key,
    required this.fallback,
    this.imageUrl,
    this.filePath,
  });

  final Widget fallback;
  final String? imageUrl;
  final String? filePath;

  @override
  Widget build(BuildContext context) {
    if (filePath != null) {
      return Image.file(
        File(filePath!),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _network(),
      );
    }
    return _network();
  }

  Widget _network() {
    if (imageUrl == null) return fallback;
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
      fadeInDuration: AppMotion.select,
      fadeOutDuration: Duration.zero,
      placeholder: (_, _) => const ColoredBox(color: AppColors.sand),
      errorWidget: (_, _, _) => fallback,
    );
  }
}
