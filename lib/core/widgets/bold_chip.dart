import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import 'app_icon.dart';
import 'bold_card.dart';

/// Collection chip: 38 high pill. Default = filled with its color; selected =
/// ink fill with white text. In dark mode an unselected chip is outlined in
/// its color with colored text (mockup 15).
class BoldChip extends StatelessWidget {
  const BoldChip({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
    this.selected = false,
    this.showCheck = false,
    this.icon,
    this.dashed = false,
    this.height = AppSizes.chipHeight,
  });

  final String label;
  final VoidCallback? onTap;

  /// Fill color; null = surface (e.g. "None").
  final Color? color;
  final bool selected;

  /// Show a check mark when selected (Add link collection picker).
  final bool showCheck;
  final AppIconData? icon;

  /// Dashed "+ New" chip.
  final bool dashed;
  final double height;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    late Color fill, fg, outline;
    if (selected) {
      fill = t.selectedFill;
      fg = t.onSelectedFill;
      outline = t.isDark ? t.selectedFill : t.outline;
    } else if (dashed) {
      fill = Colors.transparent;
      fg = t.text;
      outline = t.outline;
    } else if (t.isDark && color != null) {
      fill = t.background;
      fg = color!;
      outline = color!;
    } else {
      fill = color ?? t.surface;
      fg = color != null ? AppColors.ink : t.text;
      outline = t.outline;
    }
    final leading = selected && showCheck ? AppIcons.check : icon;

    // Pad the 38 px chip to a 44 px touch target.
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: ((AppSizes.minTouch - height) / 2).clamp(0, 10)),
          child: BoldCard(
            height: height,
            fill: fill,
            outline: outline,
            radius: height / 2,
            dashed: dashed,
            padding: EdgeInsets.symmetric(horizontal: leading != null ? 14 : 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[
                  AppIcon(leading, size: 15, color: fg),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  maxLines: 1,
                  style: AppText.body(14,
                      weight: selected || dashed
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: fg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
