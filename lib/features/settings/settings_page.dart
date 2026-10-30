import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/coming_soon.dart';
import '../../core/widgets/page_header.dart';
import '../../l10n/app_localizations.dart';

/// Settings tab (13). Filled in M6; for now it links to the widget gallery.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeader(title: l.settingsTitle),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 18, 0),
            child: _RowCard(
              icon: AppIcons.grid,
              title: l.widgetGallery,
              subtitle: l.widgetGalleryHint,
              onTap: () => context.push(Routes.gallery),
            ),
          ),
          const Expanded(child: ComingSoon(milestone: 'M6')),
        ],
      ),
    );
  }
}

/// Sky row card with icon box, two lines and a chevron (13).
class _RowCard extends StatelessWidget {
  const _RowCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final AppIconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BoldCard(
      fill: AppColors.sky,
      radius: AppShape.rSection,
      shadow: AppShadows.offMd,
      padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
      onTap: onTap,
      semanticLabel: title,
      child: Row(
        children: [
          BoldCard(
            width: AppSizes.iconBox,
            height: AppSizes.iconBox,
            fill: AppColors.white,
            outline: AppColors.ink,
            radius: AppShape.rSmall,
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
          const AppIcon(AppIcons.chevronRight, color: AppColors.ink),
        ],
      ),
    );
  }
}
