import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';

/// 58 × 34 switch: on = mint track, off = sand track, white thumb 23.
class BoldSwitch extends StatelessWidget {
  const BoldSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  /// Screen-reader label.
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final duration =
        AppMotion.reduce(context) ? AppMotion.reduced : AppMotion.select;
    const inset = 3.0;
    return Semantics(
      toggled: value,
      label: label,
      onTap: onChanged == null ? null : () => onChanged!(!value),
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onChanged == null ? null : () => onChanged!(!value),
        child: SizedBox(
          height: AppSizes.minTouch,
          child: Center(
            child: AnimatedContainer(
              duration: duration,
              curve: Curves.easeOut,
              width: AppSizes.switchW,
              height: AppSizes.switchH,
              decoration: boldBox(
                fill: value ? AppColors.mint : t.sandDeep,
                outline: t.outline,
                radius: AppSizes.switchH / 2,
              ),
              child: AnimatedAlign(
                duration: duration,
                curve: Curves.easeOut,
                alignment:
                    value ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: inset),
                  child: Container(
                    width: AppSizes.switchThumb,
                    height: AppSizes.switchThumb,
                    decoration: boldBox(
                      fill: AppColors.white,
                      outline: AppColors.ink,
                      radius: AppSizes.switchThumb / 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
