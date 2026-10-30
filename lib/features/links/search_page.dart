import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/bold_search_field.dart';
import '../../core/widgets/icon_box.dart';
import '../../core/widgets/link_tile.dart';
import '../../core/widgets/mascot.dart';
import '../../l10n/app_localizations.dart';
import 'links_providers.dart';
import 'quick_look_sheet.dart';
import 'sort_sheet.dart';

/// Search with sort / collection pills and highlighted matches (03, 23).
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _field = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _field.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _setQuery(String q) => ref.read(searchQueryProvider.notifier).set(q);

  void _clear() {
    _field.clear();
    _setQuery('');
    _focus.requestFocus();
  }

  Future<void> _pickCollection() async {
    final l = AppLocalizations.of(context);
    final cols = ref.read(collectionsProvider).value ?? const [];
    // -1 stands for "All collections" (null cannot be a map key here).
    final picked = await showOptionSheet<int>(
      context,
      title: l.showLinksFrom,
      selected: ref.read(searchCollectionProvider) ?? -1,
      options: {-1: l.allCollections, for (final c in cols) c.id: c.name},
    );
    if (picked != null) {
      ref.read(searchCollectionProvider.notifier).set(picked == -1 ? null : picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final query = ref.watch(searchQueryProvider).trim();
    final results = ref.watch(searchResultsProvider).value;
    final cols = ref.watch(collectionsProvider).value ?? const [];
    final sort = ref.watch(linkSortSettingProvider);
    final colId = ref.watch(searchCollectionProvider);
    String colName = l.allCollections;
    final names = <int, String>{};
    for (final c in cols) {
      names[c.id] = c.name;
      if (c.id == colId) colName = c.name;
    }

    Widget body;
    if (results == null) {
      body = const SizedBox();
    } else if (results.isEmpty && query.isNotEmpty) {
      body = _NoResults(query: query, onClear: _clear);
    } else {
      body = ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 18, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          if (query.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 6, 2, 10),
              child: Text(l.searchResultCount(results.length, query),
                  style: AppText.display(18, color: t.text)),
            ),
          for (final link in results) ...[
            LinkTile(
              key: ValueKey(link.id),
              seed: link.url,
              title: link.displayTitle,
              subtitle: link.collectionId != null &&
                      names[link.collectionId] != null
                  ? l.linkSubtitle(link.domain, names[link.collectionId]!)
                  : link.domain,
              kind: link.kind,
              imageUrl: link.imageUrl,
              imageFile: link.customImagePath,
              highlight: query,
              moreLabel: l.moreOptions,
              onTap: () => showQuickLook(context, link.id),
            ),
            const SizedBox(height: AppSizes.listGap),
          ],
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
              child: Row(
                children: [
                  IconBox(
                    icon: AppIcons.back,
                    size: 48,
                    radius: AppShape.rControlSm,
                    tooltip: l.back,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Semantics(
                      label: l.searchLabel,
                      child: BoldSearchField(
                        controller: _field,
                        focusNode: _focus,
                        hint: l.searchHint,
                        clearLabel: l.clearSearch,
                        autofocus: true,
                        onChanged: _setQuery,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  _Pill(
                    label: sortLabel(l, sort),
                    fill: AppColors.sun,
                    onTap: () => showSortSheet(context, ref),
                  ),
                  const SizedBox(width: 8),
                  _Pill(
                    label: colName,
                    fill: colId == null ? t.surface : AppColors.sun,
                    onTap: _pickCollection,
                  ),
                ],
              ),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

/// 38 high pill with a ▾ (03).
class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.fill, required this.onTap});

  final String label;
  final Color fill;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = fill == AppColors.sun ? AppColors.ink : context.tokens.text;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: BoldCard(
        height: AppSizes.chipHeight,
        fill: fill,
        radius: AppShape.rChip,
        padding: const EdgeInsets.fromLTRB(14, 0, 12, 0),
        onTap: onTap,
        semanticLabel: label,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: AppText.body(13, weight: FontWeight.w700, color: fg)),
            const SizedBox(width: 6),
            AppIcon(AppIcons.chevronDown, size: 16, color: fg),
          ],
        ),
      ),
    );
  }
}

/// "No links match …" with the confused mascot (23).
class _NoResults extends StatelessWidget {
  const _NoResults({required this.query, required this.onClear});

  final String query;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(30, 26, 30, 24),
      child: Column(
        children: [
          const Mascot(MascotMood.confused, size: 110),
          const SizedBox(height: 10),
          Text(l.noResultsTitle(query),
              textAlign: TextAlign.center,
              style: AppText.display(28, height: 1.1, color: t.text)),
          const SizedBox(height: 10),
          Text(l.noResultsBody,
              textAlign: TextAlign.center,
              style: AppText.body(15, height: 1.5, color: t.text)),
          const SizedBox(height: 16),
          BoldButton(
            label: l.clearSearch,
            kind: BoldButtonKind.sun,
            size: BoldButtonSize.medium,
            shadow: true,
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}
