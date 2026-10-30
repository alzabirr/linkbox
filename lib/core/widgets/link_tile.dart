import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import 'app_icon.dart';
import 'bold_card.dart';
import 'link_picture.dart';
import 'scene_art.dart';

/// List row: 52 px thumb, 1-line title, "domain · collection", ⋮ button.
/// With [highlight] set, matches in the title get a sun background (03).
class LinkTile extends StatelessWidget {
  const LinkTile({
    super.key,
    required this.seed,
    required this.title,
    required this.subtitle,
    required this.moreLabel,
    this.kind = LinkKind.article,
    this.imageUrl,
    this.imageFile,
    this.highlight,
    this.onTap,
    this.onLongPress,
    this.onMore,
  });

  final String seed;
  final String title;

  /// "youtube.com · Design".
  final String subtitle;

  /// Tooltip for the ⋮ button.
  final String moreLabel;
  final LinkKind kind;
  final String? imageUrl;
  final String? imageFile;
  final String? highlight;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final frame = SceneColors.of(seed).frame;
    final titleStyle = AppText.body(15, weight: FontWeight.w700, color: t.text);

    final thumb = Container(
      width: AppSizes.listThumb,
      height: AppSizes.listThumb,
      clipBehavior: Clip.antiAlias,
      decoration: boldBox(
        fill: frame,
        outline: AppColors.ink,
        radius: AppShape.rThumb,
      ),
      child: imageUrl == null && imageFile == null
          ? Center(
              child: AppIcon(
                kind == LinkKind.video ? AppIcons.play : AppIcons.lines,
                size: 20,
                color: AppColors.ink,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(
                AppShape.rThumb - AppShape.stroke,
              ),
              child: LinkPicture(
                imageUrl: imageUrl,
                filePath: imageFile,
                fallback: const SizedBox.shrink(),
              ),
            ),
    );

    return BoldCard(
      radius: AppShape.rControl,
      shadow: AppShadows.offSm,
      padding: EdgeInsets.fromLTRB(8, 8, onMore == null ? 10 : 4, 8),
      onTap: onTap,
      onLongPress: onLongPress,
      semanticLabel: '$title, $subtitle',
      child: Row(
        children: [
          ExcludeSemantics(child: thumb),
          const SizedBox(width: 12),
          Expanded(
            child: ExcludeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    _highlighted(title, highlight, titleStyle),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body(12, color: t.muted),
                  ),
                ],
              ),
            ),
          ),
          if (onMore != null)
            Tooltip(
              message: moreLabel,
              child: Semantics(
                button: true,
                label: moreLabel,
                onTap: onMore,
                excludeSemantics: true,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onMore,
                  child: SizedBox(
                    width: AppSizes.minTouch,
                    height: AppSizes.minTouch,
                    child: Center(
                      child: AppIcon(AppIcons.more, size: 20, color: t.text),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static TextSpan _highlighted(String text, String? query, TextStyle style) {
    final q = query?.trim().toLowerCase() ?? '';
    if (q.isEmpty) return TextSpan(text: text, style: style);
    // A match far into a long title would hide behind the "…": start the
    // row a little before it instead.
    final at = text.toLowerCase().indexOf(q);
    if (at > 24) text = '…${text.substring(at - 12)}';
    final lower = text.toLowerCase();
    final mark = AppText.weight(style, FontWeight.w800).copyWith(
      color: AppColors.ink,
      background: Paint()..color = AppColors.sun,
    );
    final spans = <TextSpan>[];
    var start = 0;
    while (true) {
      final i = lower.indexOf(q, start);
      if (i < 0) break;
      if (i > start) spans.add(TextSpan(text: text.substring(start, i)));
      spans.add(TextSpan(text: text.substring(i, i + q.length), style: mark));
      start = i + q.length;
    }
    if (start < text.length) spans.add(TextSpan(text: text.substring(start)));
    return TextSpan(style: style, children: spans);
  }
}
