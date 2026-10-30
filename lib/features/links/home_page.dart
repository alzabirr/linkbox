import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/models/collection_item.dart';
import '../../core/models/link_item.dart';
import '../../core/providers.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_chip.dart';
import '../../core/widgets/bold_search_field.dart';
import '../../core/widgets/icon_box.dart';
import '../../core/widgets/link_card.dart';
import '../../core/widgets/link_tile.dart';
import '../../core/widgets/mascot.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/scene_art.dart';
import '../../l10n/app_localizations.dart';
import '../../app/router.dart';
import 'add_link_sheet.dart';
import 'link_actions.dart';
import 'link_menu_sheet.dart';
import 'quick_look_sheet.dart';
import 'selection_bars.dart';
import 'sort_sheet.dart';
import 'links_providers.dart';

/// Links tab: grid (01) or list (02).
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final view = ref.watch(homeViewModeProvider);
    final links = ref.watch(homeLinksProvider);
    final collections = ref.watch(collectionsProvider).value ?? const [];
    final filter = ref.watch(homeCollectionFilterProvider);
    final total = ref.watch(linkCountProvider).value;
    final isGrid = view == ViewMode.grid;
    final selecting = ref.watch(selectionProvider).isNotEmpty;
    final items = links.value ?? const <LinkItem>[];
    final duration = AppMotion.reduce(context)
        ? AppMotion.reduced
        : AppMotion.swap;

    // Opened from the share overlay: /links?open=<id> → Quick look.
    final open = int.tryParse(
      GoRouterState.of(context).uri.queryParameters['open'] ?? '',
    );
    if (open != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        context.go(Routes.links);
        showQuickLook(context, open);
      });
    }

    Widget body;
    if (total == 0) {
      body = const _EmptyState();
    } else {
      body = items.isEmpty && links.hasValue
          ? _NoLinksHere(text: l.emptyCollection)
          : isGrid
          ? _LinkGrid(links: items, collections: collections)
          : _LinkList(links: items, collections: collections);
    }

    if (total == 0) {
      return const SafeArea(bottom: false, child: _EmptyState());
    }

    return PopScope(
      canPop: !selecting,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) ref.read(selectionProvider.notifier).clear();
      },
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (selecting) ...[
                  SelectionTopBar(visible: items),
                  const SizedBox(height: 4),
                ] else ...[
                  PageHeader(
                    title: l.homeTitle,
                    actions: [
                      IconBox(
                        icon: AppIcons.sort,
                        tooltip: l.sortTooltip,
                        onPressed: () => showSortSheet(context, ref),
                      ),
                      IconBox(
                        icon: isGrid ? AppIcons.list : AppIcons.grid,
                        iconSize: isGrid ? 22 : 20,
                        tooltip: isGrid ? l.switchToList : l.switchToGrid,
                        kind: IconBoxKind.sun,
                        onPressed: ref
                            .read(homeViewModeProvider.notifier)
                            .toggle,
                      ),
                    ],
                  ),
                  // The list view (02) has no search bar.
                  if (isGrid)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: BoldSearchField(
                        hint: l.searchHint,
                        clearLabel: l.clearSearch,
                        readOnly: true,
                        onTap: () => context.push(Routes.search),
                      ),
                    ),
                  _CollectionChips(
                    collections: collections,
                    selected: filter,
                    allLabel: l.chipAll,
                    onSelect: ref
                        .read(homeCollectionFilterProvider.notifier)
                        .select,
                  ),
                ],
                Expanded(
                  child: AnimatedSwitcher(
                    duration: duration,
                    child: KeyedSubtree(key: ValueKey(view), child: body),
                  ),
                ),
              ],
            ),
            if (selecting)
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: SelectionToolbar(visible: items),
              )
            else
              Positioned(
                right: 18,
                bottom: 18,
                child: BoldButton(
                  label: l.addLink,
                  icon: AppIcons.plus,
                  size: BoldButtonSize.fab,
                  onPressed: () =>
                      showAddLinkSheet(context, collectionId: filter),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CollectionChips extends StatelessWidget {
  const _CollectionChips({
    required this.collections,
    required this.selected,
    required this.allLabel,
    required this.onSelect,
  });

  final List<CollectionItem> collections;
  final int? selected;
  final String allLabel;
  final ValueChanged<int?> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // 38 chip + 3 px touch padding each side; mockup padding 14 / 4.
      height: 44 + 11 + 1,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 11, 16, 1),
        children: [
          BoldChip(
            label: allLabel,
            selected: selected == null,
            onTap: () => onSelect(null),
          ),
          for (final c in collections) ...[
            const SizedBox(width: 8),
            BoldChip(
              label: c.name,
              color: c.color,
              selected: selected == c.id,
              onTap: () => onSelect(c.id),
            ),
          ],
        ],
      ),
    );
  }
}

/// Shared helpers for both views.
mixin _LinkViewHelpers {
  List<CollectionItem> get collections;

  String? collectionName(LinkItem link) {
    for (final c in collections) {
      if (c.id == link.collectionId) return c.name;
    }
    return null;
  }

  String? kindLabel(AppLocalizations l, LinkKind kind) => switch (kind) {
    LinkKind.video => l.kindVideo,
    LinkKind.article => l.kindArticle,
    LinkKind.post => l.kindPost,
    LinkKind.other => null,
  };

  /// Quick look, open or copy, as chosen in Settings.
  void open(BuildContext context, WidgetRef ref, LinkItem link) =>
      LinkActions.tap(context, ref, link);
}

// Leaves room under the last row for the Add link button.
const _bottomPadding = 18.0 + AppSizes.fabHeight + 24;

class _LinkGrid extends ConsumerWidget with _LinkViewHelpers {
  const _LinkGrid({required this.links, required this.collections});

  final List<LinkItem> links;
  @override
  final List<CollectionItem> collections;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final rows = (links.length / 2).ceil();
    final selected = ref.watch(selectionProvider);
    final selecting = selected.isNotEmpty;
    final sel = ref.read(selectionProvider.notifier);

    Widget card(LinkItem link) => LinkCard(
      key: ValueKey(link.id),
      seed: link.url,
      title: link.displayTitle,
      domain: link.domain,
      number: l.linkNumber(link.id.toString().padLeft(3, '0')),
      collectionTag: collectionName(link),
      kindLabel: kindLabel(l, link.kind),
      kind: link.kind,
      imageUrl: link.imageUrl,
      imageFile: link.customImagePath,
      state: switch (link.fetchStatus) {
        FetchStatus.ok => LinkCardState.normal,
        FetchStatus.pending => LinkCardState.loading,
        FetchStatus.failed => LinkCardState.failed,
      },
      noPreviewLabel: l.noPreview,
      retryLabel: l.tryAgain,
      loadingLabel: l.gettingPreview,
      selecting: selecting,
      selected: selected.contains(link.id),
      onTap: selecting
          ? () => sel.toggle(link.id)
          : () => open(context, ref, link),
      onLongPress: selecting ? null : () => sel.start(link.id),
      onRetry: () => ref.read(linkRepositoryProvider).retry(link.id),
    );

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 18, _bottomPadding),
      itemCount: rows,
      separatorBuilder: (_, _) => const SizedBox(height: AppSizes.gridGap),
      itemBuilder: (context, row) {
        final a = links[row * 2];
        final b = row * 2 + 1 < links.length ? links[row * 2 + 1] : null;
        // Cards in a row share the same height, like the CSS grid.
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: card(a)),
              const SizedBox(width: AppSizes.gridGap),
              Expanded(child: b == null ? const SizedBox() : card(b)),
            ],
          ),
        );
      },
    );
  }
}

class _LinkList extends ConsumerWidget with _LinkViewHelpers {
  const _LinkList({required this.links, required this.collections});

  final List<LinkItem> links;
  @override
  final List<CollectionItem> collections;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final selected = ref.watch(selectionProvider);
    final selecting = selected.isNotEmpty;
    final sel = ref.read(selectionProvider.notifier);
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 18, _bottomPadding),
      itemCount: links.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSizes.listGap),
      itemBuilder: (context, i) {
        final link = links[i];
        final name = collectionName(link);
        return LinkTile(
          key: ValueKey(link.id),
          seed: link.url,
          title: link.displayTitle,
          subtitle: name == null
              ? link.domain
              : l.linkSubtitle(link.domain, name),
          kind: link.kind,
          imageUrl: link.imageUrl,
          imageFile: link.customImagePath,
          moreLabel: l.moreOptions,
          selecting: selecting,
          selected: selected.contains(link.id),
          onTap: selecting
              ? () => sel.toggle(link.id)
              : () => open(context, ref, link),
          onLongPress: selecting ? null : () => sel.start(link.id),
          onMore: () => showLinkMenu(context, link),
        );
      },
    );
  }
}

/// No links at all (simple version of 05; the full screen comes in M6).
/// First launch / no links yet (05).
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    Widget card(double angle, Color c) => Transform.rotate(
          angle: angle * 3.14159 / 180,
          child: Container(
            width: 92,
            height: 120,
            decoration: boldBox(fill: c, outline: t.outline, radius: 16),
          ),
        );
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Column(
        children: [
          ExcludeSemantics(
            child: SizedBox(
              width: 300,
              height: 280,
              child: Stack(
                children: [
                  Positioned(left: 6, top: 40, child: card(-14, AppColors.sky)),
                  Positioned(right: 6, top: 30, child: card(12, AppColors.pink)),
                  Positioned(
                    left: 32,
                    top: 196,
                    child: Container(
                      width: 236,
                      height: 14,
                      decoration: BoxDecoration(
                        color: t.sandDeep,
                        borderRadius: const BorderRadius.all(
                            Radius.elliptical(118, 7)),
                      ),
                    ),
                  ),
                  const Positioned(
                      left: 55, top: 2, child: BlinkingMascot(size: 190)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Semantics(
            header: true,
            child: Text(
              l.emptyTitle,
              textAlign: TextAlign.center,
              style: AppText.display(40,
                  height: 1.02, letterSpacing: -1, color: t.text),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l.emptyBody,
            textAlign: TextAlign.center,
            style: AppText.body(16, height: 1.5, color: t.muted),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Expanded(
                flex: 10,
                child: BoldButton(
                  label: l.importShort,
                  kind: BoldButtonKind.secondary,
                  size: BoldButtonSize.cta,
                  weight: FontWeight.w700,
                  expand: true,
                  onPressed: () => context.push(Routes.data),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 16,
                child: BoldButton(
                  label: l.addFirstLink,
                  icon: AppIcons.plus,
                  size: BoldButtonSize.cta,
                  expand: true,
                  onPressed: () => showAddLinkSheet(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(l.emptyFootnote,
              textAlign: TextAlign.center,
              style: AppText.body(13, weight: FontWeight.w600, color: t.muted)),
        ],
      ),
    );
  }
}

class _NoLinksHere extends StatelessWidget {
  const _NoLinksHere({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.only(bottom: _bottomPadding),
      child: Text(text, style: AppText.body(15, color: context.tokens.muted)),
    ),
  );
}
