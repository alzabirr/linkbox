import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/models/collection_item.dart';
import '../../core/repositories/collection_repository.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/page_header.dart';
import '../../l10n/app_localizations.dart';
import '../links/link_actions.dart';
import '../links/links_providers.dart';
import 'collection_sheet.dart';

/// Collections tab (12).
class CollectionsPage extends ConsumerWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cols = ref.watch(collectionsProvider).value ?? const [];
    final stats = ref.watch(collectionStatsProvider).value ?? const {};
    final total = ref.watch(linkCountProvider).value ?? 0;

    final rows = <Widget>[];
    for (var i = 0; i < cols.length; i += 2) {
      rows.add(Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.gridGap),
        child: Row(
          children: [
            Expanded(child: _Tile(collection: cols[i], stats: stats[cols[i].id])),
            const SizedBox(width: AppSizes.gridGap),
            Expanded(
              child: i + 1 < cols.length
                  ? _Tile(collection: cols[i + 1], stats: stats[cols[i + 1].id])
                  : const SizedBox(),
            ),
          ],
        ),
      ));
    }

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: PageHeader(
              title: l.collectionsTitle,
              actions: [
                BoldButton(
                  label: l.newShort,
                  icon: AppIcons.plus,
                  size: BoldButtonSize.header,
                  shadow: true,
                  onPressed: () => showCollectionSheet(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 18, 32),
              children: [
                _AllLinksTile(
                  count: total,
                  onTap: () {
                    ref.read(homeCollectionFilterProvider.notifier).select(null);
                    context.go(Routes.links);
                  },
                ),
                const SizedBox(height: AppSizes.gridGap),
                ...rows,
                BoldCard(
                  height: 60,
                  fill: Colors.transparent,
                  radius: AppShape.rCard,
                  dashed: true,
                  semanticLabel: l.createACollection,
                  onTap: () => showCollectionSheet(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppIcon(AppIcons.plus, size: 18, color: context.tokens.text),
                      const SizedBox(width: 8),
                      Text(l.createACollection,
                          style: AppText.body(15,
                              weight: FontWeight.w700,
                              color: context.tokens.text)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Wide ink tile "89 All links" with two tilted mini cards (12).
class _AllLinksTile extends StatelessWidget {
  const _AllLinksTile({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    Widget mini(Color c, double angle) => Transform.rotate(
          angle: angle * 3.14159 / 180,
          child: Container(
            width: 60,
            height: 44,
            decoration: boldBox(
                fill: c, outline: AppColors.white, radius: 10),
          ),
        );
    return BoldCard(
      height: 112,
      fill: AppColors.ink,
      outline: t.isDark ? t.outline : AppColors.ink,
      radius: AppShape.rSection,
      clip: true,
      onTap: onTap,
      semanticLabel: '$count ${l.allLinks}',
      child: Stack(
        children: [
          Positioned(right: 18, top: 12, child: mini(AppColors.pink, 10)),
          Positioned(right: 36, top: 22, child: mini(AppColors.sun, -8)),
          Positioned(
            left: 14,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$count',
                    style: AppText.display(40,
                        height: 1, color: AppColors.white)),
                const SizedBox(height: 2),
                Text(l.allLinks,
                    style: AppText.body(15,
                        weight: FontWeight.w700, color: AppColors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 168 high collection tile: icon box, count, name, "Updated today".
class _Tile extends StatelessWidget {
  const _Tile({required this.collection, this.stats});

  final CollectionItem collection;
  final CollectionStats? stats;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final count = stats?.count ?? 0;
    final updated = stats?.updatedAt ?? collection.createdAt;
    return BoldCard(
      height: 168,
      fill: collection.color,
      radius: AppShape.rSection,
      shadow: AppShadows.offMd,
      padding: const EdgeInsets.all(14),
      onTap: () => context.push(Routes.collection(collection.id)),
      semanticLabel: '${collection.name}, ${l.linkCount(count)}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: boldBox(
                    fill: AppColors.white,
                    outline: AppColors.ink,
                    radius: AppShape.rSmall),
                child: Center(
                  child: AppIcon(
                      AppIcons.collectionIcons[collection.icon] ??
                          AppIcons.star,
                      color: AppColors.ink),
                ),
              ),
              const Spacer(),
              Text('$count',
                  style: AppText.display(34, height: 1, color: AppColors.ink)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (collection.pinned) ...[
                    const AppIcon(AppIcons.pin, size: 16, color: AppColors.ink),
                    const SizedBox(width: 4),
                  ],
                  Expanded(
                    child: Text(collection.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.display(20, color: AppColors.ink)),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(l.updatedWhen(relativeDay(context, updated)),
                  style: AppText.body(12,
                      weight: FontWeight.w600, color: AppColors.ink)),
            ],
          ),
        ],
      ),
    );
  }
}
