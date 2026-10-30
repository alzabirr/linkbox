import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/mascot.dart';
import '../../l10n/app_localizations.dart';

/// "Delete 3 links?" (11). Returns true when the user confirms.
Future<bool> showDeleteDialog(BuildContext context, {required int count}) {
  final l = AppLocalizations.of(context);
  return showConfirmDialog(
    context,
    title: l.deleteTitle(count),
    body: l.deleteBody(count),
    confirm: l.deleteLinks(count),
    cancel: l.keepThem,
  );
}

/// The sad-mascot dialog with a danger button and a white cancel button.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String confirm,
  required String cancel,
}) async {
  final ok = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: AppColors.ink.withValues(alpha: 0.55),
    transitionDuration:
        AppMotion.reduce(context) ? AppMotion.reduced : AppMotion.select,
    transitionBuilder: (context, anim, _, child) => FadeTransition(
      opacity: anim,
      child: ScaleTransition(
        scale: Tween(begin: 0.94, end: 1.0)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: child,
      ),
    ),
    pageBuilder: (context, _, _) => _DeleteDialog(
        title: title, body: body, confirm: confirm, cancel: cancel),
  );
  return ok ?? false;
}

class _DeleteDialog extends StatelessWidget {
  const _DeleteDialog({
    required this.title,
    required this.body,
    required this.confirm,
    required this.cancel,
  });

  final String title;
  final String body;
  final String confirm;
  final String cancel;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Material(
            type: MaterialType.transparency,
            child: Semantics(
              scopesRoute: true,
              namesRoute: true,
              explicitChildNodes: true,
              label: title,
              child: BoldCard(
                fill: t.background,
                radius: AppShape.rSheet,
                shadow: AppShadows.offXl,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: Mascot(MascotMood.sad, size: 84)),
                    const SizedBox(height: 12),
                    Text(title,
                        textAlign: TextAlign.center,
                        style: AppText.display(28, color: t.text)),
                    const SizedBox(height: 12),
                    Text(body,
                        textAlign: TextAlign.center,
                        style: AppText.body(15, height: 1.5, color: t.text)),
                    const SizedBox(height: 20),
                    BoldButton(
                      label: confirm,
                      kind: BoldButtonKind.danger,
                      size: BoldButtonSize.dialog,
                      expand: true,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                    const SizedBox(height: 10),
                    BoldButton(
                      label: cancel,
                      kind: BoldButtonKind.secondary,
                      size: BoldButtonSize.dialog,
                      weight: FontWeight.w700,
                      expand: true,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
