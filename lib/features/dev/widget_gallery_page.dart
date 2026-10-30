import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/bold_chip.dart';
import '../../core/widgets/bold_search_field.dart';
import '../../core/widgets/bold_sheet.dart';
import '../../core/widgets/bold_switch.dart';
import '../../core/widgets/icon_box.dart';
import '../../core/widgets/link_card.dart';
import '../../core/widgets/link_tile.dart';
import '../../core/widgets/mascot.dart';
import '../../core/widgets/scene_art.dart';
import '../../core/widgets/segmented_picker.dart';
import '../../l10n/app_localizations.dart';
import '../settings/theme_settings.dart';

/// Sample links from the mockups (content, not UI text).
class _Sample {
  const _Sample(this.url, this.title, this.domain, this.collection, this.kind);
  final String url;
  final String title;
  final String domain;
  final String collection;
  final LinkKind kind;
}

const _samples = [
  _Sample('https://youtube.com/watch?v=kitchen',
      'Small kitchen layout ideas that actually work', 'youtube.com',
      'Design', LinkKind.video),
  _Sample('https://docs.flutter.dev/ui/design/material',
      'Material 3 theming in Flutter', 'docs.flutter.dev', 'Dev',
      LinkKind.article),
  _Sample('https://reddit.com/r/architecture/courtyard',
      'Courtyard house plans – what would you change?', 'reddit.com',
      'Design', LinkKind.post),
  _Sample('https://youtube.com/watch?v=biryani',
      'Chicken biryani, step by step', 'youtube.com', 'Recipes',
      LinkKind.video),
];

/// Test page that shows every core widget (M0 "Done when").
class WidgetGalleryPage extends ConsumerStatefulWidget {
  const WidgetGalleryPage({super.key});

  @override
  ConsumerState<WidgetGalleryPage> createState() => _WidgetGalleryPageState();
}

class _WidgetGalleryPageState extends ConsumerState<WidgetGalleryPage> {
  bool _switch = true;
  String _tap = 'quick';
  int _chip = 0;
  final Set<int> _selected = {0};

  String _kind(AppLocalizations l, LinkKind k) => switch (k) {
        LinkKind.video => l.kindVideo,
        LinkKind.post => l.kindPost,
        _ => l.kindArticle,
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final theme = ref.watch(themeSettingsProvider);
    final settings = ref.read(themeSettingsProvider.notifier);
    const chipColors = [
      AppColors.pink,
      AppColors.sky,
      AppColors.sun,
      AppColors.mint
    ];
    const chipNames = ['Design', 'Dev', 'Recipes', 'Read later'];

    LinkCard card(int i, {bool selecting = false}) {
      final s = _samples[i];
      return LinkCard(
        seed: s.url,
        title: s.title,
        domain: s.domain,
        number: l.linkNumber((i + 1).toString().padLeft(3, '0')),
        collectionTag: s.collection,
        kindLabel: _kind(l, s.kind),
        kind: s.kind,
        selecting: selecting,
        selected: _selected.contains(i),
        onTap: selecting
            ? () => setState(() => _selected.contains(i)
                ? _selected.remove(i)
                : _selected.add(i))
            : () {},
        onLongPress: () {},
      );
    }

    Widget pair(Widget a, Widget b) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: a),
            const SizedBox(width: AppSizes.gridGap),
            Expanded(child: b),
          ],
        );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 18, 40),
          children: [
            Row(
              children: [
                IconBox(
                  icon: AppIcons.back,
                  tooltip: l.back,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(l.widgetGallery,
                      style: context.text.headlineMedium),
                ),
              ],
            ),

            _Section(l.galleryTheme),
            SegmentedPicker<ThemeMode>(
              label: l.galleryTheme,
              value: theme.mode,
              onChanged: settings.setMode,
              options: {
                ThemeMode.light: l.themeLight,
                ThemeMode.dark: l.themeDark,
                ThemeMode.system: l.themeSystem,
              },
            ),
            const SizedBox(height: 12),
            _SwitchRow(
              title: l.pureBlack,
              subtitle: l.pureBlackHint,
              value: theme.amoled,
              onChanged: settings.setAmoled,
            ),
            const SizedBox(height: 8),
            Text(l.accentColor,
                style: AppText.body(15, weight: FontWeight.w700, color: t.text)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final c in AppColors.accents.take(6))
                  _Swatch(
                    color: c,
                    selected: c == theme.accent,
                    onTap: () => settings.setAccent(c),
                  ),
              ],
            ),

            _Section(l.galleryButtons),
            BoldButton(
                label: l.saveLink, expand: true, onPressed: () {}),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: [
                BoldButton(
                    label: l.notNow,
                    kind: BoldButtonKind.secondary,
                    size: BoldButtonSize.small,
                    onPressed: () {}),
                BoldButton(
                    label: l.saveLink,
                    kind: BoldButtonKind.dark,
                    size: BoldButtonSize.small,
                    onPressed: () {}),
                BoldButton(
                    label: l.clearSearch,
                    kind: BoldButtonKind.sun,
                    size: BoldButtonSize.medium,
                    shadow: true,
                    onPressed: () {}),
                BoldButton(
                    label: l.addLink,
                    icon: AppIcons.plus,
                    size: BoldButtonSize.fab,
                    onPressed: () {}),
              ],
            ),
            const SizedBox(height: 14),
            pair(
              BoldButton(
                  label: l.deleteLinks(3),
                  kind: BoldButtonKind.danger,
                  size: BoldButtonSize.medium,
                  expand: true,
                  onPressed: () {}),
              BoldButton(
                  label: l.keepThem,
                  kind: BoldButtonKind.secondary,
                  size: BoldButtonSize.medium,
                  expand: true,
                  onPressed: () {}),
            ),
            const SizedBox(height: 14),
            BoldButton(label: l.saveLink, expand: true, onPressed: null),

            _Section(l.galleryIconBoxes),
            Wrap(
              spacing: 8,
              children: [
                IconBox(
                    icon: AppIcons.sort, tooltip: l.sortTooltip, onPressed: () {}),
                IconBox(
                    icon: AppIcons.list,
                    tooltip: l.switchToList,
                    kind: IconBoxKind.sun,
                    onPressed: () {}),
                IconBox(
                    icon: AppIcons.grid,
                    iconSize: 20,
                    tooltip: l.switchToGrid,
                    kind: IconBoxKind.sun,
                    onPressed: () {}),
                IconBox(
                    icon: AppIcons.close,
                    iconSize: 18,
                    tooltip: l.close,
                    onPressed: () {}),
                IconBox(
                    icon: AppIcons.back,
                    size: 48,
                    radius: AppShape.rControlSm,
                    tooltip: l.back,
                    onPressed: () {}),
              ],
            ),

            _Section(l.galleryChips),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  BoldChip(
                      label: l.chipAll,
                      selected: _chip == 0,
                      onTap: () => setState(() => _chip = 0)),
                  for (var i = 0; i < chipNames.length; i++) ...[
                    const SizedBox(width: 8),
                    BoldChip(
                      label: chipNames[i],
                      color: chipColors[i],
                      selected: _chip == i + 1,
                      onTap: () => setState(() => _chip = i + 1),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                BoldChip(label: l.chipNone, height: 40, onTap: () {}),
                BoldChip(
                    label: chipNames[1],
                    height: 40,
                    selected: true,
                    showCheck: true,
                    onTap: () {}),
                BoldChip(
                    label: l.chipNew,
                    height: 40,
                    dashed: true,
                    icon: AppIcons.plus,
                    onTap: () {}),
              ],
            ),

            _Section(l.galleryInputs),
            BoldSearchField(hint: l.searchHint, clearLabel: l.clearSearch),
            const SizedBox(height: 14),
            _SwitchRow(
              title: l.pureBlack,
              subtitle: l.pureBlackHint,
              value: _switch,
              onChanged: (v) => setState(() => _switch = v),
            ),
            const SizedBox(height: 12),
            Text(l.tapActionLabel, style: context.text.titleMedium),
            const SizedBox(height: 10),
            SegmentedPicker<String>(
              label: l.tapActionLabel,
              value: _tap,
              onChanged: (v) => setState(() => _tap = v),
              options: {
                'quick': l.tapQuickLook,
                'open': l.tapOpen,
                'copy': l.tapCopy,
              },
            ),

            _Section(l.galleryCards),
            pair(card(0), card(1)),
            const SizedBox(height: AppSizes.gridGap),
            pair(card(2), card(3)),

            _Section(l.galleryCardStates),
            pair(
              LinkCard(
                seed: 'example.com/plans',
                title: 'example.com/plans/2026…',
                domain: 'example.com',
                number: l.linkNumber('005'),
                state: LinkCardState.failed,
                noPreviewLabel: l.noPreview,
                retryLabel: l.tryAgain,
                onRetry: () {},
              ),
              LinkCard(
                seed: 'example.com/loading',
                title: '',
                domain: 'example.com',
                number: l.linkNumber('006'),
                state: LinkCardState.loading,
                loadingLabel: l.gettingPreview,
              ),
            ),

            _Section(l.gallerySelecting),
            pair(card(0, selecting: true), card(1, selecting: true)),

            _Section(l.galleryList),
            for (var i = 0; i < _samples.length; i++) ...[
              LinkTile(
                seed: _samples[i].url,
                title: _samples[i].title,
                subtitle: '${_samples[i].domain} · ${_samples[i].collection}',
                kind: _samples[i].kind,
                moreLabel: l.moreOptions,
                highlight: i == 1 ? 'flutter' : null,
                onTap: () {},
                onMore: () {},
              ),
              const SizedBox(height: AppSizes.listGap),
            ],

            _Section(l.galleryMascot),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                for (final m in MascotMood.values) Mascot(m, size: 70),
                BoldCard(
                  fill: AppColors.sun,
                  padding: const EdgeInsets.all(8),
                  child: const Mascot(MascotMood.happy,
                      size: 46, bodyColor: AppColors.white),
                ),
              ],
            ),

            _Section(l.gallerySheet),
            BoldButton(
              label: l.galleryOpenSheet,
              kind: BoldButtonKind.secondary,
              size: BoldButtonSize.medium,
              onPressed: () => showBoldSheet<void>(
                context,
                builder: (context) => BoldSheet(
                  title: l.sheetDemoTitle,
                  closeLabel: l.close,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l.sheetDemoBody, style: context.text.bodyLarge),
                      const SizedBox(height: 24),
                      BoldButton(
                        label: l.saveLink,
                        expand: true,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 12),
      child: Container(
        padding: const EdgeInsets.only(top: 18),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: t.sandLine, width: 2)),
        ),
        child: Semantics(
          header: true,
          child: Text(title, style: AppText.display(18, color: t.text)),
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style:
                      AppText.body(15, weight: FontWeight.w700, color: t.text)),
              Text(subtitle, style: AppText.body(12, color: t.muted)),
            ],
          ),
        ),
        BoldSwitch(value: value, onChanged: onChanged, label: title),
      ],
    );
  }
}

/// 44 px accent swatch; selected = 3 px border + white gap + ink ring.
class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Semantics(
      button: true,
      selected: selected,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
                color: t.outline, width: selected ? 3 : AppShape.stroke),
            boxShadow: selected
                ? [
                    BoxShadow(color: t.outline, spreadRadius: 5.5),
                    BoxShadow(color: t.surface, spreadRadius: 3),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
