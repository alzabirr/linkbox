import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/icon_box.dart';
import '../../l10n/app_localizations.dart';
import '../links/delete_dialog.dart';
import 'data_controller.dart';
import 'result_toast.dart';

/// Pick a backup and how to restore it (28). Pops with a message.
class RestorePage extends ConsumerStatefulWidget {
  const RestorePage({super.key});

  @override
  ConsumerState<RestorePage> createState() => _RestorePageState();
}

class _RestorePageState extends ConsumerState<RestorePage> with ToastHost {
  List<BackupChoice>? _choices;
  int _selected = 0;
  bool _replace = false;
  bool _busy = false;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final actions = ref.read(dataActionsProvider);
    final list = await actions.listBackups();
    final count = await actions.linkCount();
    if (mounted) {
      setState(() {
        _choices = list;
        _current = count;
      });
    }
  }

  Future<void> _pickFile() async {
    final l = AppLocalizations.of(context);
    try {
      final data = await ref.read(dataActionsProvider).pickBackup();
      if (data == null || !mounted) return;
      setState(() {
        _choices = [BackupChoice(label: l.chosenFile, data: data), ...?_choices];
        _selected = 0;
      });
    } on Exception {
      showToast(l.restoreError, error: true);
    }
  }

  Future<void> _restore() async {
    final l = AppLocalizations.of(context);
    final choice = _choices![_selected];
    if (_replace) {
      final ok = await showConfirmDialog(
        context,
        title: l.replaceConfirmTitle,
        body: l.replaceConfirmBody,
        confirm: l.restoreReplace,
        cancel: l.keepThem,
      );
      if (!ok) return;
    }
    setState(() => _busy = true);
    final r = await ref
        .read(dataActionsProvider)
        .restore(choice.data, replace: _replace);
    if (mounted) Navigator.of(context).pop(l.restoreDone(r.imported, r.skipped));
  }

  String _size(int? bytes) {
    if (bytes == null) return '';
    if (bytes < 1024) return '$bytes B';
    return '${(bytes / 1024).ceil()} KB';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final choices = _choices;
    final folder = l.downloadFolder;
    final pick = l.restorePick(folder);
    final at = pick.indexOf(folder);
    final pickStyle = AppText.body(15, height: 1.45, color: t.text);

    Widget radioDot(bool on) => Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: on ? AppColors.ink : AppColors.white,
            border: Border.all(color: AppColors.ink, width: AppShape.stroke),
          ),
          child: on
              ? Center(
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                        color: AppColors.ink, shape: BoxShape.circle),
                  ),
                )
              : null,
        );

    Widget modeCard(bool replace, String title, String sub) {
      final on = _replace == replace;
      return BoldCard(
        fill: on ? (replace ? AppColors.sun : AppColors.mint) : t.surface,
        radius: AppShape.rControl,
        padding: const EdgeInsets.all(14),
        selected: on,
        semanticLabel: '$title. $sub',
        onTap: () => setState(() => _replace = replace),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // White ring inside an ink dot when selected (28).
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: on ? AppColors.ink : AppColors.white,
                border: Border.all(color: AppColors.ink, width: AppShape.stroke),
              ),
              child: on
                  ? Center(
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 4),
                          color: AppColors.ink,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppText.body(15,
                          weight: FontWeight.w800,
                          color: on ? AppColors.ink : t.text)),
                  const SizedBox(height: 2),
                  Text(sub,
                      style: AppText.body(13,
                          color: on ? AppColors.ink : t.text)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final List<Widget> list;
    if (choices == null) {
      list = [
        const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    } else {
      list = [
        for (var i = 0; i < choices.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: BoldCard(
              fill: i == _selected ? AppColors.sun : t.surface,
              radius: AppShape.rControl,
              shadow: i == _selected ? AppShadows.offSm : 0,
              padding: const EdgeInsets.all(12),
              selected: i == _selected,
              semanticLabel: choices[i].label,
              onTap: () => setState(() => _selected = i),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: boldBox(
                        fill: AppColors.white,
                        outline: AppColors.ink,
                        radius: AppShape.rTiny),
                    child: const Center(
                      child: AppIcon(AppIcons.file,
                          size: 20, color: AppColors.ink),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(choices[i].label,
                            style: AppText.body(15,
                                weight: FontWeight.w800,
                                color: i == _selected
                                    ? AppColors.ink
                                    : t.text)),
                        const SizedBox(height: 2),
                        Text(
                          [
                            l.linkCount(choices[i].data.links.length),
                            l.collectionCountLabel(
                                choices[i].data.collections.length),
                            if (choices[i].size != null)
                              _size(choices[i].size),
                          ].join(' · '),
                          style: AppText.body(12,
                              weight: FontWeight.w600,
                              color: i == _selected
                                  ? AppColors.ink
                                  : t.text),
                        ),
                      ],
                    ),
                  ),
                  radioDot(i == _selected),
                ],
              ),
            ),
          ),
        if (choices.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(l.restoreNone,
                style: AppText.body(14, height: 1.45, color: t.muted)),
          ),
        BoldCard(
          height: 54,
          fill: Colors.transparent,
          radius: AppShape.rControl,
          dashed: true,
          semanticLabel: l.restoreChooseFile,
          onTap: _pickFile,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(AppIcons.file, size: 18, color: t.text),
              const SizedBox(width: 8),
              Text(l.restoreChooseFile,
                  style: AppText.body(15,
                      weight: FontWeight.w700, color: t.text)),
            ],
          ),
        ),
      ];
    }

    final canRestore = choices != null && choices.isNotEmpty && !_busy;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                        child: Text(l.restore,
                            style: AppText.display(26, color: t.text)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 18, 16),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text.rich(at < 0
                            ? TextSpan(text: pick, style: pickStyle)
                            : TextSpan(style: pickStyle, children: [
                                TextSpan(text: pick.substring(0, at)),
                                TextSpan(
                                    text: folder,
                                    style: AppText.weight(
                                        pickStyle, FontWeight.w800)),
                                TextSpan(
                                    text: pick.substring(at + folder.length)),
                              ])),
                      ),
                      const SizedBox(height: 14),
                      ...list,
                      const SizedBox(height: 22),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(l.restoreHow,
                            style: AppText.display(18, color: t.text)),
                      ),
                      const SizedBox(height: 14),
                      modeCard(false, l.restoreAdd, l.restoreAddSub),
                      const SizedBox(height: 10),
                      modeCard(true, l.restoreReplace,
                          l.restoreReplaceSub(_current)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 18, 24),
                  child: BoldButton(
                    label: l.restoreButton(canRestore
                        ? choices[_selected].data.links.length
                        : 0),
                    expand: true,
                    onPressed: canRestore ? _restore : null,
                  ),
                ),
              ],
            ),
            Positioned(left: 16, right: 18, bottom: 96, child: toastLayer()),
          ],
        ),
      ),
    );
  }
}
