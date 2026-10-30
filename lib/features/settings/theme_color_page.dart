import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/icon_box.dart';
import '../../l10n/app_localizations.dart';
import 'theme_settings.dart';

/// 12 accent colors + a hex code, with a live preview (25).
class ThemeColorPage extends ConsumerStatefulWidget {
  const ThemeColorPage({super.key});

  @override
  ConsumerState<ThemeColorPage> createState() => _ThemeColorPageState();
}

class _ThemeColorPageState extends ConsumerState<ThemeColorPage> {
  late Color _picked = ref.read(themeSettingsProvider).accent;
  late final _hex = TextEditingController(text: toHex(_picked));
  bool _hexError = false;

  @override
  void dispose() {
    _hex.dispose();
    super.dispose();
  }

  void _pick(Color c) => setState(() {
        _picked = c;
        _hex.text = toHex(c);
        _hexError = false;
      });

  void _typed(String text) {
    final c = parseHex(text);
    setState(() {
      _hexError = c == null && text.trim().length >= 6;
      if (c != null) _picked = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final names = [
      l.colorOrange, l.colorSun, l.colorMint, l.colorSky,
      l.colorGrape, l.colorPink, l.colorPeach, l.colorLime,
      l.colorTeal, l.colorCoral, l.colorLilac, l.colorSand,
    ];

    Widget chip(String label, Color fill, {bool ink = false}) => Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: boldBox(
              fill: fill, outline: AppColors.ink, radius: 17),
          child: Text(label,
              style: AppText.body(13,
                  weight: FontWeight.w700,
                  color: ink ? AppColors.white : AppColors.ink)),
        );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
              child: Row(
                children: [
                  IconBox(
                    icon: AppIcons.back,
                    tooltip: l.back,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 12),
                  Semantics(
                    header: true,
                    child: Text(l.themeColorTitle,
                        style: AppText.display(26, color: t.text)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 18, 16),
                children: [
                  // Live preview (always light, like the cards it shows).
                  BoldCard(
                    fill: AppColors.white,
                    outline: t.outline,
                    radius: 24,
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.previewLabel,
                            style: AppText.body(13,
                                weight: FontWeight.w700, color: AppColors.ink)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            chip(l.chipAll, AppColors.ink, ink: true),
                            const SizedBox(width: 8),
                            chip('Design', _picked),
                            const SizedBox(width: 8),
                            chip('Dev', AppColors.white),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 52,
                                alignment: Alignment.center,
                                decoration: boldBox(
                                  fill: _picked,
                                  outline: AppColors.ink,
                                  radius: AppShape.rControlSm,
                                  shadow: AppShadows.hard(
                                      AppShadows.offSm, AppColors.ink),
                                ),
                                child: Text(l.saveLink,
                                    style: AppText.body(15,
                                        weight: FontWeight.w800,
                                        color: AppColors.ink)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: AppSizes.switchW,
                              height: AppSizes.switchH,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 3),
                              decoration: boldBox(
                                  fill: _picked,
                                  outline: AppColors.ink,
                                  radius: 17),
                              child: Container(
                                width: AppSizes.switchThumb,
                                height: AppSizes.switchThumb,
                                decoration: boldBox(
                                    fill: AppColors.white,
                                    outline: AppColors.ink,
                                    radius: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(l.pickAColor,
                      style: AppText.display(18, color: t.text)),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    padding: const EdgeInsets.only(right: 4, bottom: 4),
                    childAspectRatio: 1.15,
                    children: [
                      for (var i = 0; i < AppColors.accents.length; i++)
                        _BigSwatch(
                          color: AppColors.accents[i],
                          name: names[i],
                          selected: AppColors.accents[i].toARGB32() ==
                              _picked.toARGB32(),
                          onTap: () => _pick(AppColors.accents[i]),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(l.hexLabel,
                      style: AppText.body(14,
                          weight: FontWeight.w700, color: t.text)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 52,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: boldBox(
                            fill: t.surface,
                            outline: t.outline,
                            radius: AppShape.rControlSm,
                          ),
                          child: TextField(
                            controller: _hex,
                            onChanged: _typed,
                            autocorrect: false,
                            cursorColor: t.text,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: t.text,
                            ),
                            decoration: const InputDecoration(
                              isCollapsed: true,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: boldBox(
                            fill: _picked,
                            outline: t.outline,
                            radius: AppShape.rControlSm),
                      ),
                    ],
                  ),
                  if (_hexError) ...[
                    const SizedBox(height: 6),
                    Text(l.hexInvalid,
                        style: AppText.body(13,
                            weight: FontWeight.w600, color: t.dangerText)),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 18, 24),
              child: BoldButton(
                label: l.useThisColor,
                kind: BoldButtonKind.dark,
                expand: true,
                shadow: false,
                onPressed: () {
                  ref.read(themeSettingsProvider.notifier).setAccent(_picked);
                  Navigator.of(context).maybePop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 72 high swatch with its name; selected = 3.5 border + shadow + check.
class _BigSwatch extends StatelessWidget {
  const _BigSwatch({
    required this.color,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BoldCard(
      fill: color,
      radius: AppShape.rCard,
      stroke: selected ? AppShape.strokeHeavy : AppShape.stroke,
      shadow: selected ? AppShadows.offMd : 0,
      selected: selected,
      semanticLabel: name,
      onTap: onTap,
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Column(
        children: [
          if (selected)
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                  color: AppColors.ink, shape: BoxShape.circle),
              child: const Center(
                child: AppIcon(AppIcons.check,
                    size: 13, strokeWidth: 3.6, color: AppColors.white),
              ),
            ),
          const Spacer(),
          Text(name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body(11,
                  weight: FontWeight.w800, color: AppColors.ink)),
        ],
      ),
    );
  }
}
