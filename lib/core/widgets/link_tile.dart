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
    this.selecting = false,
    this.selected = false,
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

  /// Multi-select (10): check circle instead of ⋮, heavier border.
  final bool selecting;
  final bool selected;

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

    final card = BoldCard(
      radius: AppShape.rControl,
      stroke: selected ? AppShape.strokeHeavy : AppShape.stroke,
      shadow: selecting
          ? (selected ? AppShadows.offLg : 0)
          : AppShadows.offSm,
      padding: EdgeInsets.fromLTRB(
          8, 8, onMore == null || selecting ? 10 : 4, 8),
      onTap: onTap,
      onLongPress: onLongPress,
      selected: selecting ? selected : null,
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
          if (selecting)
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: selected ? AppColors.ink : AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.ink, width: AppShape.stroke),
              ),
              child: selected
                  ? const Center(
                      child: AppIcon(AppIcons.check,
                          size: 15, strokeWidth: 3.6, color: AppColors.white))
                  : null,
            )
          else if (onMore != null)
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
    if (!selecting) return card;
    return AnimatedOpacity(
      duration: AppMotion.select,
      opacity: selected ? 1 : 0.7,
      child: card,
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
