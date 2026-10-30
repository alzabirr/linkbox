import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/models/link_sort.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/bold_sheet.dart';
import '../../l10n/app_localizations.dart';
import 'links_providers.dart';

String sortLabel(AppLocalizations l, LinkSort s) => switch (s) {
      LinkSort.newest => l.sortNewest,
      LinkSort.oldest => l.sortOldest,
      LinkSort.az => l.sortAz,
      LinkSort.za => l.sortZa,
    };

/// "Sort links" sheet (03).
Future<void> showSortSheet(BuildContext context, WidgetRef ref) async {
  final l = AppLocalizations.of(context);
  final current = ref.read(linkSortSettingProvider);
  final picked = await showOptionSheet<LinkSort>(
    context,
    title: l.sortTitle,
    selected: current,
    options: {for (final s in LinkSort.values) s: sortLabel(l, s)},
  );
  if (picked != null) ref.read(linkSortSettingProvider.notifier).set(picked);
}

/// A sheet with a title and one row per option; the selected row is sun
/// with a check (03). Returns the tapped option.
Future<T?> showOptionSheet<T>(
  BuildContext context, {
  required String title,
  required Map<T, String> options,
  required T selected,
}) =>
    showBoldSheet<T>(
      context,
      builder: (context) {
        final t = context.tokens;
        return BoldSheet(
          padding: const EdgeInsets.fromLTRB(16, 12, 18, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                child: Text(title,
                    style: AppText.display(24, color: t.text)),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(right: 3, bottom: 3),
                  itemCount: options.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final e = options.entries.elementAt(i);
                    final on = e.key == selected;
                    return BoldCard(
                      height: 56,
                      fill: on ? AppColors.sun : t.surface,
                      radius: AppShape.rControlSm,
                      shadow: on ? AppShadows.offSm : 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      selected: on,
                      semanticLabel: e.value,
                      onTap: () => Navigator.of(context).pop(e.key),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(e.value,
                                style: AppText.body(16,
                                    weight:
                                        on ? FontWeight.w800 : FontWeight.w600,
                                    color: on ? AppColors.ink : t.text)),
                          ),
                          if (on)
                            const AppIcon(AppIcons.check,
                                strokeWidth: 3, color: AppColors.ink),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
