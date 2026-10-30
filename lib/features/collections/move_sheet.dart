import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/providers.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/bold_sheet.dart';
import '../../l10n/app_localizations.dart';
import '../links/links_providers.dart';

/// Opens "Move to collection" (09). Returns true when the links moved.
Future<bool> showMoveSheet(
  BuildContext context, {
  required List<int> linkIds,
  int? currentCollectionId,
}) async {
  final moved = await showBoldSheet<bool>(
    context,
    builder: (_) =>
        MoveSheet(linkIds: linkIds, currentCollectionId: currentCollectionId),
  );
  return moved ?? false;
}

class MoveSheet extends ConsumerStatefulWidget {
  const MoveSheet({
    super.key,
    required this.linkIds,
    this.currentCollectionId,
  });

  final List<int> linkIds;
  final int? currentCollectionId;

  @override
  ConsumerState<MoveSheet> createState() => _MoveSheetState();
}

class _MoveSheetState extends ConsumerState<MoveSheet> {
  late int? _selected = widget.currentCollectionId;

  Future<void> _move() async {
    await ref
        .read(linkRepositoryProvider)
        .moveLinks(widget.linkIds, _selected);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final collections = ref.watch(collectionsProvider).value ?? const [];
    final counts = ref.watch(collectionCountsProvider).value ?? const {};
    String selectedName = l.noCollection;
    for (final c in collections) {
      if (c.id == _selected) selectedName = c.name;
    }

    final rows = <Widget>[
      _Row(
        name: l.noCollection,
        count: l.linkCount(counts[null] ?? 0),
        color: AppColors.white,
        selected: _selected == null,
        onTap: () => setState(() => _selected = null),
      ),
      for (final c in collections)
        _Row(
          name: c.name,
          count: l.linkCount(counts[c.id] ?? 0),
          color: c.color,
          selected: _selected == c.id,
          onTap: () => setState(() => _selected = c.id),
        ),
    ];

    return BoldSheet(
      padding: const EdgeInsets.fromLTRB(16, 12, 18, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.moveTitle(widget.linkIds.length),
                    style: AppText.display(26, color: t.text)),
                const SizedBox(height: 10),
                Text(l.moveHelp,
                    style: AppText.body(14, color: t.muted)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              clipBehavior: Clip.none,
              padding: const EdgeInsets.only(right: 3, bottom: 3),
              itemCount: rows.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) => rows[i],
            ),
          ),
          const SizedBox(height: 16),
          BoldButton(
            label: l.moveTo(selectedName),
            expand: true,
            onPressed: _move,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.name,
    required this.count,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String count;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final fg = selected ? AppColors.ink : t.text;
    return BoldCard(
      height: 62,
      fill: selected ? AppColors.sun : t.surface,
      radius: AppShape.rControl,
      shadow: selected ? AppShadows.offSm : 0,
      padding: const EdgeInsets.fromLTRB(8, 0, 14, 0),
      onTap: onTap,
      selected: selected,
      semanticLabel: '$name, $count',
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: boldBox(
              fill: color,
              outline: AppColors.ink,
              radius: AppShape.rTiny,
            ),
            child: Center(
              child: AppIcon(AppIcons.folder,
                  size: 20, color: AppColors.ink),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body(16, weight: FontWeight.w700, color: fg)),
                Text(count,
                    style: AppText.body(12,
                        color: selected ? AppColors.ink : t.muted)),
              ],
            ),
          ),
          if (selected)
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                  color: AppColors.ink, shape: BoxShape.circle),
              child: const Center(
                child: AppIcon(AppIcons.check,
                    size: 15, strokeWidth: 3.4, color: AppColors.white),
              ),
            ),
        ],
      ),
    );
  }
}
