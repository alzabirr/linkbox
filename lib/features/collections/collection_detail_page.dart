import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/models/link_item.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/icon_box.dart';
import '../../core/widgets/link_tile.dart';
import '../../l10n/app_localizations.dart';
import '../links/add_link_sheet.dart';
import '../links/link_actions.dart';
import '../links/link_menu_sheet.dart';
import '../links/links_providers.dart';
import '../links/quick_look_sheet.dart';
import '../links/selection_bars.dart';
import '../links/sort_sheet.dart';
import 'collection_options_sheet.dart';

/// One collection: colored header, sort, links, "Add to …" (19).
class CollectionDetailPage extends ConsumerWidget {
  const CollectionDetailPage({super.key, required this.collectionId});

  final int collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final collection = ref.watch(collectionProvider(collectionId)).value;
    final links = ref.watch(collectionLinksProvider(collectionId)).value ??
        const <LinkItem>[];
    final stats = ref.watch(collectionStatsProvider).value?[collectionId];
    final selection = ref.watch(selectionProvider);
    final selecting = selection.isNotEmpty;
    final sort = ref.watch(linkSortSettingProvider);
    if (collection == null) return const Scaffold();

    final header = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: collection.color,
        borderRadius:
            const BorderRadius.vertical(bottom: Radius.circular(AppShape.rPanel)),
        border: Border(
            bottom: BorderSide(color: t.outline, width: AppShape.stroke)),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              right: -18,
              top: 46,
              child: Transform.rotate(
                angle: 14 * 3.14159 / 180,
                child: AppIcon(
                  AppIcons.collectionIcons[collection.icon] ?? AppIcons.star,
                  size: 150,
                  strokeWidth: 1,
                  color: AppColors.ink,
                  fill: AppColors.sun,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconBox(
                        icon: AppIcons.back,
                        tooltip: l.back,
                        fill: AppColors.white,
                        outline: AppColors.ink,
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      const Spacer(),
                      IconBox(
                        icon: AppIcons.more,
                        iconSize: 20,
                        tooltip: l.collectionOptions,
                        fill: AppColors.white,
                        outline: AppColors.ink,
                        onPressed: () async {
                          final deleted = await showCollectionOptions(context,
                              collection: collection, links: links);
                          if (deleted && context.mounted) {
                            Navigator.of(context).maybePop();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.collectionLabel,
                            style: AppText.body(14,
                                weight: FontWeight.w700, color: AppColors.ink)),
                        const SizedBox(height: 4),
                        Text(collection.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.display(48,
                                height: 1,
                                letterSpacing: -1.4,
                                color: AppColors.ink)),
                        const SizedBox(height: 4),
                        Text(
                            l.collectionMeta(l.linkCount(links.length),
                                relativeDay(context, stats?.updatedAt ?? collection.createdAt)),
                            style: AppText.body(14,
                                weight: FontWeight.w600, color: AppColors.ink)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return PopScope(
      canPop: !selecting,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) ref.read(selectionProvider.notifier).clear();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (selecting)
                  SafeArea(bottom: false, child: SelectionTopBar(visible: links))
                else
                  header,
                if (!selecting)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 18, 10),
                    child: Row(
                      children: [
                        BoldCard(
                          height: AppSizes.chipHeight,
                          radius: AppShape.rChip,
                          padding: const EdgeInsets.fromLTRB(14, 0, 12, 0),
                          onTap: () => showSortSheet(context, ref),
                          semanticLabel: sortLabel(l, sort),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(sortLabel(l, sort),
                                  style: AppText.body(13,
                                      weight: FontWeight.w700, color: t.text)),
                              const SizedBox(width: 6),
                              AppIcon(AppIcons.chevronDown,
                                  size: 16, color: t.text),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconBox(
                          icon: AppIcons.search,
                          size: 44,
                          iconSize: 20,
                          tooltip: l.searchIn(collection.name),
                          onPressed: () => context.push(
                              '${Routes.search}?collection=$collectionId'),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: links.isEmpty
                      ? Center(
                          child: Text(l.emptyCollection,
                              style: AppText.body(15, color: t.muted)),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(
                              16, selecting ? 18 : 0, 18, 110),
                          itemCount: links.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSizes.listGap),
                          itemBuilder: (context, i) {
                            final link = links[i];
                            final sel = ref.read(selectionProvider.notifier);
                            return LinkTile(
                              key: ValueKey(link.id),
                              seed: link.url,
                              title: link.displayTitle,
                              subtitle:
                                  '${link.domain} · ${relativeDay(context, link.createdAt)}',
                              kind: link.kind,
                              imageUrl: link.imageUrl,
                              imageFile: link.customImagePath,
                              moreLabel: l.moreOptions,
                              selecting: selecting,
                              selected: selection.contains(link.id),
                              onTap: selecting
                                  ? () => sel.toggle(link.id)
                                  : () => showQuickLook(context, link.id),
                              onLongPress: selecting
                                  ? null
                                  : () => sel.start(link.id),
                              onMore: () => showLinkMenu(context, link),
                            );
                          },
                        ),
                ),
              ],
            ),
            Positioned(
              left: selecting ? 16 : null,
              right: selecting ? 16 : 18,
              bottom: 26 + MediaQuery.viewPaddingOf(context).bottom,
              child: selecting
                  ? SelectionToolbar(visible: links)
                  : BoldButton(
                      label: l.addToCollection(collection.name),
                      icon: AppIcons.plus,
                      size: BoldButtonSize.fab,
                      onPressed: () =>
                          showAddLinkSheet(context, collectionId: collectionId),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
