import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import 'app_icon.dart';
import 'icon_box.dart';

/// Opens [child] as a bottom sheet: paper background, top radius 28,
/// 2.5 px top outline, 50 % ink scrim, 280 ms emphasized slide.
/// A [tall] sheet starts 84 px below the top of the screen (06).
Future<T?> showBoldSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool tall = false,
  double top = _tallSheetTop,
}) {
  final reduce = AppMotion.reduce(context);
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    // Cover the whole screen, bottom bar included.
    useRootNavigator: true,
    sheetAnimationStyle: AnimationStyle(
      duration: reduce ? AppMotion.reduced : AppMotion.sheet,
      reverseDuration: reduce ? AppMotion.reduced : AppMotion.sheet,
      curve: AppMotion.emphasized,
    ),
    builder: (context) => tall
        ? SizedBox(
            height: MediaQuery.sizeOf(context).height - top,
            child: builder(context),
          )
        : builder(context),
  );
}

const _tallSheetTop = 84.0;

/// Sheet body with the 44 × 5 grabber, a title and an optional close box.
class BoldSheet extends StatelessWidget {
  const BoldSheet({
    super.key,
    required this.child,
    this.title,
    this.closeLabel,
    this.padding = const EdgeInsets.fromLTRB(18, 12, 20, 24),
  });

  final Widget child;
  final String? title;

  /// When set, shows a close icon box with this tooltip.
  final String? closeLabel;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final navBar = MediaQuery.viewPaddingOf(context).bottom;
    return Padding(
      padding: padding.copyWith(
        bottom: padding.bottom + (keyboard > navBar ? keyboard : navBar),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: AppSizes.grabberW,
              height: AppSizes.grabberH,
              decoration: BoxDecoration(
                color: t.outline,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          if (title != null) ...[
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: context.text.headlineMedium,
                    semanticsLabel: title,
                  ),
                ),
                if (closeLabel != null)
                  IconBox(
                    icon: AppIcons.close,
                    iconSize: 18,
                    tooltip: closeLabel!,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 18),
          Flexible(child: child),
        ],
      ),
    );
  }
}
