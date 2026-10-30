import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../l10n/app_localizations.dart';
import 'mascot.dart';

/// Placeholder body for tabs that later milestones fill in.
class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key, required this.milestone});

  final String milestone;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Mascot(MascotMood.sleepy, size: 96),
            const SizedBox(height: 14),
            Text(
              AppLocalizations.of(context).comingSoon(milestone),
              textAlign: TextAlign.center,
              style: AppText.body(15, height: 1.5, color: t.muted),
            ),
          ],
        ),
      ),
    );
  }
}
