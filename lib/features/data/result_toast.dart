import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/widgets/app_icon.dart';

/// Ink message at the bottom of the data pages (14): green check for
/// success, red mark for a problem.
class ResultToast extends StatelessWidget {
  const ResultToast({super.key, required this.text, this.error = false});

  final String text;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(AppShape.rControl),
          border: t.isDark
              ? Border.all(color: t.outline, width: AppShape.stroke)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: error ? AppColors.danger : AppColors.mint,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppIcon(error ? AppIcons.close : AppIcons.check,
                    size: 14, strokeWidth: 3.6, color: AppColors.ink),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text,
                  style: AppText.body(14,
                      weight: FontWeight.w600, color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows a [ResultToast] for a few seconds.
mixin ToastHost<T extends StatefulWidget> on State<T> {
  ({String text, bool error})? toast;
  int _toastId = 0;

  void showToast(String text, {bool error = false}) {
    final id = ++_toastId;
    setState(() => toast = (text: text, error: error));
    Future<void>.delayed(const Duration(seconds: 4), () {
      if (mounted && id == _toastId) setState(() => toast = null);
    });
  }

  Widget toastLayer() => AnimatedSwitcher(
        duration: AppMotion.select,
        child: toast == null
            ? const SizedBox.shrink()
            : ResultToast(
                key: ValueKey(_toastId),
                text: toast!.text,
                error: toast!.error),
      );
}
