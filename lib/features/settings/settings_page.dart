import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/bold_switch.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/segmented_picker.dart';
import '../../l10n/app_localizations.dart';
import '../data/data_controller.dart';
import '../links/link_actions.dart';
import 'accent_swatch.dart';
import 'theme_settings.dart';

/// Settings tab (13).
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final theme = ref.watch(themeSettingsProvider);
    final themeCtl = ref.read(themeSettingsProvider.notifier);
    final tap = ref.watch(tapActionSettingProvider);
    final last = ref.watch(lastBackupProvider);
    final accentNames = [
      l.colorOrange, l.colorSun, l.colorMint, l.colorSky, l.colorGrape, l.colorPink,
    ];

    Widget section(String title, List<Widget> children, {double gap = 10}) =>
        BoldCard(
          radius: AppShape.rSection,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(title, style: AppText.display(17, color: t.text)),
              ),
              for (final c in children) ...[SizedBox(height: gap), c],
            ],
          ),
        );

    Widget switchRow(String title, String hint, bool value,
            ValueChanged<bool> onChanged) =>
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppText.body(15,
                            weight: FontWeight.w700, color: t.text)),
                    Text(hint, style: AppText.body(12, color: t.muted)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              BoldSwitch(value: value, onChanged: onChanged, label: title),
            ],
          ),
        );

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: PageHeader(title: l.settingsTitle),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 18, 32),
              children: [
                section(l.tapActionLabel, [
                  SegmentedPicker<TapAction>(
                    label: l.tapActionLabel,
                    value: tap,
                    onChanged: ref.read(tapActionSettingProvider.notifier).set,
                    options: {
                      TapAction.quickLook: l.tapQuickLook,
                      TapAction.open: l.tapOpen,
                      TapAction.copy: l.tapCopy,
                    },
                  ),
                ]),
                const SizedBox(height: 14),
                section(l.lookAndFeel, gap: 12, [
                  SegmentedPicker<ThemeMode>(
                    label: l.lookAndFeel,
                    value: theme.mode,
                    onChanged: themeCtl.setMode,
                    options: {
                      ThemeMode.light: l.themeLight,
                      ThemeMode.dark: l.themeDark,
                      ThemeMode.system: l.themeSystem,
                    },
                  ),
                  switchRow(l.pureBlack, l.pureBlackHint, theme.amoled,
                      themeCtl.setAmoled),
                  switchRow(l.matchWallpaper, l.matchWallpaperHint,
                      theme.dynamicColor, themeCtl.setDynamicColor),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(l.accentColor,
                                style: AppText.body(15,
                                    weight: FontWeight.w700, color: t.text)),
                          ),
                          // "More colors" → Theme color (25).
                          Semantics(
                            button: true,
                            label: l.moreColors,
                            excludeSemantics: true,
                            onTap: () => context.push(Routes.themeColor),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => context.push(Routes.themeColor),
                              child: SizedBox(
                                height: AppSizes.minTouch,
                                child: Row(
                                  children: [
                                    Text(l.moreColors,
                                        style: AppText.body(13,
                                            weight: FontWeight.w700,
                                            color: t.text)),
                                    AppIcon(AppIcons.chevronRight,
                                        size: 16, color: t.text),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (var i = 0; i < 6; i++)
                            AccentSwatch(
                              color: AppColors.accents[i],
                              label: accentNames[i],
                              selected: !theme.dynamicColor &&
                                  AppColors.accents[i].toARGB32() ==
                                      theme.accent.toARGB32(),
                              onTap: () =>
                                  themeCtl.setAccent(AppColors.accents[i]),
                            ),
                        ],
                      ),
                    ],
                  ),
                ]),
                const SizedBox(height: 14),
                _RowCard(
                  icon: AppIcons.download,
                  fill: AppColors.sky,
                  title: l.dataRowTitle,
                  subtitle: last == null
                      ? l.lastBackupNever
                      : l.lastBackup(relativeDay(context, last)),
                  onTap: () => context.push(Routes.data),
                ),
                const SizedBox(height: 14),
                _RowCard(
                  icon: AppIcons.star,
                  fill: AppColors.grape,
                  title: l.aboutTitle,
                  subtitle: l.aboutRowHint,
                  onTap: () => context.push(Routes.about),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Colored row card with icon box, two lines and a chevron (13).
class _RowCard extends StatelessWidget {
  const _RowCard({
    required this.icon,
    required this.fill,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final AppIconData icon;
  final Color fill;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BoldCard(
      fill: fill,
      radius: AppShape.rSection,
      shadow: AppShadows.offMd,
      padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
      onTap: onTap,
      semanticLabel: '$title. $subtitle',
      child: Row(
        children: [
          Container(
            width: AppSizes.iconBox,
            height: AppSizes.iconBox,
            decoration: boldBox(
                fill: AppColors.white,
                outline: AppColors.ink,
                radius: AppShape.rSmall),
            child: Center(child: AppIcon(icon, color: AppColors.ink)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppText.body(16,
                        weight: FontWeight.w800, color: AppColors.ink)),
                Text(subtitle,
                    style: AppText.body(12,
                        weight: FontWeight.w600, color: AppColors.ink)),
              ],
            ),
          ),
          const AppIcon(AppIcons.chevronRight,
              strokeWidth: 2.8, color: AppColors.ink),
        ],
      ),
    );
  }
}
