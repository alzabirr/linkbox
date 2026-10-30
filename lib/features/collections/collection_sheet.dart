import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/models/collection_item.dart';
import '../../core/providers.dart';
import '../../core/repositories/collection_repository.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/bold_sheet.dart';
import '../../l10n/app_localizations.dart';
import '../links/links_providers.dart';

/// New collection, or edit one ([editing]) — same sheet (20).
/// Returns the collection id, or null if cancelled.
Future<int?> showCollectionSheet(
  BuildContext context, {
  CollectionItem? editing,
}) => showBoldSheet<int>(
  context,
  tall: true,
  top: 110,
  builder: (_) => _CollectionSheet(editing: editing),
);

class _CollectionSheet extends ConsumerStatefulWidget {
  const _CollectionSheet({this.editing});

  final CollectionItem? editing;

  @override
  ConsumerState<_CollectionSheet> createState() => _CollectionSheetState();
}

class _CollectionSheetState extends ConsumerState<_CollectionSheet> {
  late final _name = TextEditingController(text: widget.editing?.name ?? '');
  late Color _color;
  late String _icon;
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    if (e != null) {
      _color = e.color;
      _icon = e.icon;
    } else {
      // A different color for each new collection.
      final count = ref.read(collectionsProvider).value?.length ?? 0;
      _color =
          AppColors.collectionColors[count % AppColors.collectionColors.length];
      _icon = 'star';
    }
    _name.addListener(() => setState(() => _error = null));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final repo = ref.read(collectionRepositoryProvider);
    final hex = CollectionRepository.toHex(_color);
    setState(() => _saving = true);
    try {
      final e = widget.editing;
      final int id;
      if (e == null) {
        id = await repo.create(_name.text, colorHex: hex, icon: _icon);
      } else {
        await repo.update(e.id, name: _name.text, colorHex: hex, icon: _icon);
        id = e.id;
      }
      if (mounted) Navigator.of(context).pop(id);
    } on DuplicateCollectionException {
      setState(() {
        _saving = false;
        _error = AppLocalizations.of(context).duplicateCollectionName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final name = _name.text.trim();
    final count = widget.editing == null
        ? 0
        : ref
                  .watch(collectionStatsProvider)
                  .value?[widget.editing!.id]
                  ?.count ??
              0;
    final colorNames = [
      l.colorPink,
      l.colorBlue,
      l.colorYellow,
      l.colorGreen,
      l.colorPurple,
      l.colorPeach,
      l.colorOrange,
      l.colorLime,
      l.colorTeal,
      l.colorCoral,
      l.colorLilac,
      l.colorSand,
    ];
    final iconNames = <String, String>{
      'star': l.iconStar,
      'heart': l.iconHeart,
      'plane': l.iconPlane,
      'home': l.iconHome,
      'code': l.iconCode,
      'book': l.iconBook,
      'music': l.iconMusic,
      'video': l.iconVideo,
      'camera': l.iconCamera,
      'game': l.iconGame,
      'food': l.iconFood,
      'coffee': l.iconCoffee,
      'bag': l.iconBag,
      'gift': l.iconGift,
      'work': l.iconWork,
      'school': l.iconSchool,
      'idea': l.iconIdea,
      'news': l.iconNews,
      'fitness': l.iconFitness,
      'leaf': l.iconLeaf,
      'place': l.iconPlace,
      'globe': l.iconGlobe,
      'car': l.iconCar,
      'people': l.iconPeople,
    };
    final icons = AppIcons.collectionIcons.keys.toList();

    Widget label(String text, [Widget? trailing]) => Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: AppText.body(14, weight: FontWeight.w700, color: t.text),
          ),
        ),
        ?trailing,
      ],
    );

    return BoldSheet(
      title: widget.editing == null
          ? l.newCollectionTitle
          : l.editCollectionTitle,
      closeLabel: l.close,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 5, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Live preview tile.
                  BoldCard(
                    fill: _color,
                    outline: t.outline,
                    radius: AppShape.rSection,
                    shadow: AppShadows.offMd,
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: boldBox(
                            fill: AppColors.white,
                            outline: AppColors.ink,
                            radius: AppShape.rControlSm,
                          ),
                          child: Center(
                            child: AppIcon(
                              AppIcons.collectionIcons[_icon]!,
                              size: 26,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name.isEmpty ? l.newCollection : name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.display(
                                  24,
                                  color: AppColors.ink,
                                ),
                              ),
                              Text(
                                l.previewMeta(l.linkCount(count)),
                                style: AppText.body(
                                  13,
                                  weight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  label(
                    l.nameLabel,
                    Text(
                      l.charCount(
                        _name.text.length,
                        CollectionRepository.maxName,
                      ),
                      style: AppText.body(
                        12,
                        weight: FontWeight.w600,
                        color: t.muted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 56,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: boldBox(
                      fill: t.surface,
                      outline: t.outline,
                      radius: AppShape.rControlSm,
                      shadow: t.shadowOf(AppShadows.offSm),
                    ),
                    child: TextField(
                      controller: _name,
                      autofocus: widget.editing == null,
                      textCapitalization: TextCapitalization.sentences,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                          CollectionRepository.maxName,
                        ),
                      ],
                      cursorColor: t.text,
                      style: AppText.body(
                        16,
                        weight: FontWeight.w600,
                        color: t.text,
                      ),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: l.namePlaceholder,
                        hintStyle: AppText.body(16, color: t.muted),
                      ),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: AppText.body(
                        13,
                        weight: FontWeight.w600,
                        color: t.dangerText,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  label(l.colorLabel),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (
                        var i = 0;
                        i < AppColors.collectionColors.length;
                        i++
                      )
                        _ColorSwatch(
                          color: AppColors.collectionColors[i],
                          label: colorNames[i],
                          selected:
                              AppColors.collectionColors[i].toARGB32() ==
                              _color.toARGB32(),
                          onTap: () => setState(
                            () => _color = AppColors.collectionColors[i],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  label(l.iconLabel),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 6,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.05,
                    children: [
                      for (final name in icons)
                        BoldCard(
                          fill: _icon == name ? AppColors.sun : AppColors.white,
                          outline: AppColors.ink,
                          radius: AppShape.rSmall,
                          selected: _icon == name,
                          semanticLabel: iconNames[name],
                          onTap: () => setState(() => _icon = name),
                          child: Center(
                            child: AppIcon(
                              AppIcons.collectionIcons[name]!,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
          BoldButton(
            label: widget.editing == null ? l.createCollection : l.saveChanges,
            expand: true,
            onPressed: name.isEmpty || _saving ? null : _save,
          ),
        ],
      ),
    );
  }
}

/// 46 px color circle; selected = ring in the sheet color + ink ring (20).
class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: t.outline, width: AppShape.stroke),
            boxShadow: selected
                ? [
                    BoxShadow(color: t.outline, spreadRadius: 5.5),
                    BoxShadow(color: t.background, spreadRadius: 3),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
