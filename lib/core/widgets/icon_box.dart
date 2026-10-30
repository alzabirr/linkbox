import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import 'app_icon.dart';
import 'bold_card.dart';

enum IconBoxKind {
  /// Surface fill, no shadow (Sort, Close, Back).
  plain,

  /// Sun fill with small shadow (view toggle).
  sun,
}

/// 46 × 46 outlined icon button with a tooltip / screen-reader label.
class IconBox extends StatelessWidget {
  const IconBox({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.kind = IconBoxKind.plain,
    this.size = AppSizes.iconBox,
    this.radius = AppShape.rSmall,
    this.iconSize = 22,
    this.fill,
  });

  final AppIconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final IconBoxKind kind;
  final double size;
  final double radius;
  final double iconSize;

  /// Custom fill (e.g. pink clear button in search).
  final Color? fill;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final isSun = kind == IconBoxKind.sun;
    final bg =
        fill ?? (isSun ? AppColors.sun : (t.isDark ? t.background : t.surface));
    final fg = (isSun || fill != null) ? AppColors.ink : t.text;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        onTap: onPressed,
        excludeSemantics: true,
        child: BoldCard(
          width: size,
          height: size,
          fill: bg,
          radius: radius,
          shadow: isSun ? AppShadows.offSm : 0,
          onTap: onPressed,
          child: Center(
            child: AppIcon(icon, size: iconSize, color: fg),
          ),
        ),
      ),
    );
  }
}
