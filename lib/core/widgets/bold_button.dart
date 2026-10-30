import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import 'app_icon.dart';
import 'bold_card.dart';

enum BoldButtonKind {
  /// Accent fill, shadow (Save link, Add first link).
  primary,

  /// Surface fill (Not now, Keep them, Import).
  secondary,

  /// Sun fill (Try again, Clear search, Paste).
  sun,

  /// Danger fill (Delete 3 links).
  danger,

  /// Ink fill, white text (Save link in the clipboard prompt, Back up now).
  dark,
}

enum BoldButtonSize {
  /// 42 high, radius 14, 14 / 700.
  small(42, AppShape.rSmall, 14, FontWeight.w700, AppShadows.offSm),

  /// 50 high, radius 16, 15 / 800.
  medium(50, AppShape.rControlSm, 15, FontWeight.w800, AppShadows.offSm),

  /// 60 high, radius 20, 17 / 800.
  large(AppSizes.buttonHeightLg, AppShape.rCard, 17, FontWeight.w800,
      AppShadows.offMd),

  /// Share overlay buttons (22): 52 high, radius 16, 14 / 800.
  overlay(52, AppShape.rControlSm, 14, FontWeight.w800, AppShadows.offSm),

  /// Share overlay buttons (07): 54 high, radius 18, 15 / 800.
  overlayLarge(54, AppShape.rControl, 15, FontWeight.w800, AppShadows.offSm),

  /// "Add link" floating button: 58 high, radius 20, 16 / 700.
  fab(AppSizes.fabHeight, AppShape.rCard, 16, FontWeight.w700,
      AppShadows.offMd);

  const BoldButtonSize(
      this.height, this.radius, this.fontSize, this.weight, this.shadow);
  final double height;
  final double radius;
  final double fontSize;
  final FontWeight weight;
  final double shadow;
}

class BoldButton extends StatelessWidget {
  const BoldButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.kind = BoldButtonKind.primary,
    this.size = BoldButtonSize.large,
    this.icon,
    this.trailingIcon,
    this.expand = false,
    this.shadow,
    this.weight,
  });

  final String label;
  final VoidCallback? onPressed;
  final BoldButtonKind kind;
  final BoldButtonSize size;
  final AppIconData? icon;
  final AppIconData? trailingIcon;

  /// Fill the available width.
  final bool expand;

  /// Override the default shadow (primary / danger have one).
  final bool? shadow;

  /// Override the size's font weight (e.g. 700 on secondary buttons).
  final FontWeight? weight;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final enabled = onPressed != null;
    final (Color fill, Color fg) = switch (kind) {
      _ when !enabled => (t.sand, t.muted),
      BoldButtonKind.primary => (t.accent, AppColors.ink),
      BoldButtonKind.secondary => (t.surface, t.text),
      BoldButtonKind.sun => (AppColors.sun, AppColors.ink),
      BoldButtonKind.danger => (AppColors.danger, AppColors.ink),
      BoldButtonKind.dark => (t.selectedFill, t.onSelectedFill),
    };
    final hasShadow = enabled &&
        (shadow ??
            (kind == BoldButtonKind.primary ||
                kind == BoldButtonKind.danger));
    final iconSize = switch (size) {
      BoldButtonSize.small => 16.0,
      BoldButtonSize.fab => 22.0,
      _ => 20.0,
    };

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          AppIcon(icon!,
              size: iconSize,
              color: fg,
              strokeWidth: size == BoldButtonSize.fab ? 3 : null),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppText.body(size.fontSize,
                weight: weight ?? size.weight, color: fg),
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          AppIcon(trailingIcon!, size: iconSize, color: fg),
        ],
      ],
    );

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      onTap: onPressed,
      excludeSemantics: true,
      child: BoldCard(
        fill: fill,
        radius: size.radius,
        shadow: hasShadow ? size.shadow : 0,
        width: expand ? double.infinity : null,
        padding: switch (size) {
          BoldButtonSize.small => const EdgeInsets.symmetric(horizontal: 14),
          BoldButtonSize.fab => const EdgeInsets.fromLTRB(16, 0, 22, 0),
          _ => const EdgeInsets.symmetric(horizontal: 20),
        },
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: size.height - AppShape.stroke * 2),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Center(widthFactor: 1, child: content),
          ),
        ),
      ),
    );
  }
}
