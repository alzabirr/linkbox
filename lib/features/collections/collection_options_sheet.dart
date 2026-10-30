import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/models/collection_item.dart';
import '../../core/models/link_item.dart';
import '../../core/providers.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_sheet.dart';
import '../../l10n/app_localizations.dart';
import '../links/delete_dialog.dart';
import 'collection_sheet.dart';

/// ⋮ on a collection (27). Returns true when the collection was deleted.
Future<bool> showCollectionOptions(
  BuildContext context, {
  required CollectionItem collection,
  required List<LinkItem> links,
}) async {
  final deleted = await showBoldSheet<bool>(
    context,
    builder: (_) => _Options(collection: collection, links: links),
  );
  return deleted ?? false;
}

class _Options extends ConsumerWidget {
  const _Options({required this.collection, required this.links});

  final CollectionItem collection;
  final List<LinkItem> links;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final nav = Navigator.of(context);
    final page = nav.context;
    final repo = ref.read(collectionRepositoryProvider);

    Widget row(AppIconData icon, Color bg, String label, String sub,
            VoidCallback onTap, {Color? color}) =>
        Semantics(
          button: true,
          label: '$label. $sub',
          onTap: onTap,
          excludeSemantics: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: boldBox(
                          fill: bg,
                          outline: AppColors.ink,
                          radius: AppShape.rTiny),
                      child: Center(
                        child: AppIcon(icon, size: 19, color: AppColors.ink),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(label,
                              style: AppText.body(16,
                                  weight: FontWeight.w700,
                                  color: color ?? t.text)),
                          const SizedBox(height: 1),
                          Text(sub,
                              style: AppText.body(12, color: t.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

    return BoldSheet(
      padding: const EdgeInsets.fromLTRB(16, 12, 18, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: boldBox(
                        fill: collection.color,
                        outline: t.outline,
                        radius: AppShape.rControlSm),
                    child: Center(
                      child: AppIcon(
                          AppIcons.collectionIcons[collection.icon] ??
                              AppIcons.star,
                          size: 24,
                          color: AppColors.ink),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(collection.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.display(24, color: t.text)),
                        Text(l.linkCount(links.length),
                            style: AppText.body(13,
                                weight: FontWeight.w600, color: t.text)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            row(AppIcons.edit, AppColors.white, l.optRename, l.optRenameSub, () {
              nav.pop();
              showCollectionSheet(page, editing: collection);
            }),
            row(AppIcons.palette, AppColors.sun, l.optColor, l.optColorSub, () {
              nav.pop();
              showCollectionSheet(page, editing: collection);
            }),
            row(AppIcons.pin, AppColors.sky,
                collection.pinned ? l.optUnpin : l.optPin, l.optPinSub, () {
              nav.pop();
              repo.setPinned(collection.id, !collection.pinned);
            }),
            if (links.isNotEmpty)
              row(AppIcons.shareUp, AppColors.mint, l.optShare,
                  l.optShareSub(links.length), () {
                nav.pop();
                SharePlus.instance.share(ShareParams(
                  subject: collection.name,
                  text: links.map((e) => e.url).join('\n'),
                ));
              }),
            row(AppIcons.trash, AppColors.danger, l.optDelete, l.optDeleteSub,
                () async {
              final ok = await showConfirmDialog(
                context,
                title: l.deleteCollectionTitle(collection.name),
                body: l.optDeleteSub,
                confirm: l.optDelete,
                cancel: l.keepIt,
              );
              if (!ok) return;
              await repo.delete(collection.id);
              nav.pop(true);
            }, color: t.dangerText),
          ],
        ),
      ),
    );
  }
}
