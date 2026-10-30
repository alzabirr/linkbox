import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/services/link_opener.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/bold_sheet.dart';
import '../../core/widgets/icon_box.dart';
import '../../core/widgets/mascot.dart';
import '../../l10n/app_localizations.dart';

/// App facts shown on About. Fill these in before release.
class AppInfo {
  AppInfo._();

  static const version = '1.0.0';
  static const author = '[YOUR NAME]';
  static const feedbackEmail = '[YOUR EMAIL]';
  static const packageName = 'com.example.linkbox';
}

/// About (24).
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;

    Widget confetti(double w, double h, Color c, double r, double deg) =>
        Transform.rotate(
          angle: deg * 3.14159 / 180,
          child: Container(
            width: w,
            height: h,
            decoration: boldBox(fill: c, outline: AppColors.ink, radius: r),
          ),
        );

    final rows = [
      (AppIcons.shield, AppColors.mint, l.privacyPolicy, l.privacySub, () {
        showBoldSheet<void>(
          context,
          builder: (context) => BoldSheet(
            title: l.privacyPolicy,
            closeLabel: l.close,
            child: SingleChildScrollView(
              child: Text(l.privacyBody,
                  style: AppText.body(15, height: 1.5, color: t.text)),
            ),
          ),
        );
      }),
      (AppIcons.mail, AppColors.sky, l.sendFeedback, l.feedbackSub, () {
        openLink('mailto:${AppInfo.feedbackEmail}?subject=Linkbox');
      }),
      (AppIcons.star, AppColors.sun, l.rateApp, l.rateSub, () {
        openLink(
            'https://play.google.com/store/apps/details?id=${AppInfo.packageName}');
      }),
      (AppIcons.code, AppColors.pink, l.licenses, l.licensesSub, () {
        showLicensePage(
          context: context,
          applicationName: l.appTitle,
          applicationVersion: AppInfo.version,
        );
      }),
      (AppIcons.retry, AppColors.peach, l.replayIntro, l.replaySub, () {
        context.go(Routes.welcome);
      }),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
              child: Row(
                children: [
                  IconBox(
                    icon: AppIcons.back,
                    tooltip: l.back,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 12),
                  Semantics(
                    header: true,
                    child: Text(l.aboutTitle,
                        style: AppText.display(26, color: t.text)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 18, 24),
                children: [
                  BoldCard(
                    fill: AppColors.grape,
                    radius: 26,
                    shadow: AppShadows.offLg,
                    clip: true,
                    padding: const EdgeInsets.all(22),
                    child: Stack(
                      children: [
                        Positioned(
                            left: 0,
                            top: 4,
                            child: confetti(16, 16, AppColors.sun, 8, 0)),
                        Positioned(
                            right: 8,
                            top: 38,
                            child: confetti(14, 22, AppColors.mint, 4, 24)),
                        Positioned(
                            left: 22,
                            bottom: 28,
                            child: confetti(14, 14, AppColors.pink, 3, 45)),
                        Center(
                          child: Column(
                            children: [
                              const Mascot(MascotMood.wink, size: 100),
                              const SizedBox(height: 12),
                              Text(l.appTitle,
                                  style: AppText.display(34,
                                      letterSpacing: -0.8,
                                      color: AppColors.ink)),
                              const SizedBox(height: 8),
                              Text(l.version(AppInfo.version),
                                  style: AppText.body(14,
                                      weight: FontWeight.w700,
                                      color: AppColors.ink)),
                              const SizedBox(height: 8),
                              Text(l.madeBy(AppInfo.author),
                                  style: AppText.body(14,
                                      color: AppColors.ink)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  BoldCard(
                    radius: AppShape.rSection,
                    clip: true,
                    child: Column(
                      children: [
                        for (var i = 0; i < rows.length; i++)
                          Container(
                            decoration: BoxDecoration(
                              border: i == rows.length - 1
                                  ? null
                                  : Border(
                                      bottom: BorderSide(
                                          color: t.sandLine, width: 2)),
                            ),
                            child: Semantics(
                              button: true,
                              label: '${rows[i].$3}. ${rows[i].$4}',
                              onTap: rows[i].$5,
                              excludeSemantics: true,
                              child: InkWell(
                                onTap: rows[i].$5,
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(minHeight: 60),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: boldBox(
                                              fill: rows[i].$2,
                                              outline: AppColors.ink,
                                              radius: AppShape.rTiny),
                                          child: Center(
                                            child: AppIcon(rows[i].$1,
                                                size: 18,
                                                color: AppColors.ink),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(rows[i].$3,
                                                  style: AppText.body(15,
                                                      weight: FontWeight.w700,
                                                      color: t.text)),
                                              Text(rows[i].$4,
                                                  style: AppText.body(12,
                                                      color: t.muted)),
                                            ],
                                          ),
                                        ),
                                        AppIcon(AppIcons.chevronRight,
                                            size: 18, color: t.text),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(l.aboutFooter,
                      textAlign: TextAlign.center,
                      style: AppText.body(13,
                          weight: FontWeight.w600, color: t.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
