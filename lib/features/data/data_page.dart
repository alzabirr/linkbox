import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../app/theme/app_theme.dart';
import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/services/file_store.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/icon_box.dart';
import '../../core/widgets/mascot.dart';
import '../../l10n/app_localizations.dart';
import 'data_controller.dart';
import 'result_toast.dart';

/// Import, export & backup (14).
class DataPage extends ConsumerStatefulWidget {
  const DataPage({super.key});

  @override
  ConsumerState<DataPage> createState() => _DataPageState();
}

enum _Job { backup, import, exportHtml, exportJson }

class _DataPageState extends ConsumerState<DataPage> with ToastHost {
  _Job? _busy;

  Future<void> _run(_Job job, Future<String?> Function() action) async {
    if (_busy != null) return;
    setState(() => _busy = job);
    try {
      final message = await action();
      if (message != null && mounted) showToast(message);
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  Future<String?> _backup() async {
    final l = AppLocalizations.of(context);
    try {
      await ref.read(dataActionsProvider).backupNow();
      return l.backupDone;
    } on FileStoreException {
      showToast(l.backupFailed, error: true);
      return null;
    }
  }

  Future<String?> _import() async {
    final l = AppLocalizations.of(context);
    try {
      final r = await ref.read(dataActionsProvider).importBrowserFile();
      return r == null ? null : l.importDone(r.imported, r.skipped);
    } on Exception {
      showToast(l.importError, error: true);
      return null;
    }
  }

  Future<String?> _export(Future<String> Function() f) async {
    final l = AppLocalizations.of(context);
    try {
      return l.exportDone(await f());
    } on FileStoreException {
      showToast(l.backupFailed, error: true);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final actions = ref.read(dataActionsProvider);
    final last = ref.watch(lastBackupProvider);
    final folder = l.downloadFolder;
    final body = l.backupBody(folder);
    final at = body.indexOf(folder);
    final bodyStyle = AppText.body(14, height: 1.45, color: AppColors.ink);

    Widget section({
      required AppIconData icon,
      required Color iconFill,
      required String title,
      required String text,
      required Widget buttons,
    }) => BoldCard(
      radius: 24,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: boldBox(
                  fill: iconFill,
                  outline: AppColors.ink,
                  radius: AppShape.rTiny,
                ),
                child: Center(
                  child: AppIcon(icon, size: 20, color: AppColors.ink),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, style: AppText.display(20, color: t.text)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(text, style: AppText.body(14, height: 1.45, color: t.text)),
          const SizedBox(height: 10),
          buttons,
        ],
      ),
    );

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
                        child: Text(
                          l.dataTitle,
                          style: AppText.display(26, color: t.text),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 18, 100),
                    children: [
                      // Backup (mint, with the cheering mascot). A colored
                      // card keeps light-mode buttons, also in dark mode.
                      Theme(
                        data: AppTheme.light(t.accent),
                        child: BoldCard(
                          outline: t.outline,
                          fill: AppColors.mint,
                          radius: 24,
                          shadow: AppShadows.offMd,
                          clip: true,
                          padding: const EdgeInsets.all(16),
                          child: Stack(
                            children: [
                              const Positioned(
                                right: -4,
                                top: -6,
                                child: Mascot(
                                  MascotMood.cheer,
                                  size: 74,
                                  bodyColor: AppColors.sun,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    l.backupTitle,
                                    style: AppText.display(
                                      22,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 80),
                                    child: Text.rich(
                                      at < 0
                                          ? TextSpan(
                                              text: body,
                                              style: bodyStyle,
                                            )
                                          : TextSpan(
                                              style: bodyStyle,
                                              children: [
                                                TextSpan(
                                                  text: body.substring(0, at),
                                                ),
                                                TextSpan(
                                                  text: folder,
                                                  style: AppText.weight(
                                                    bodyStyle,
                                                    FontWeight.w800,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: body.substring(
                                                    at + folder.length,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    last == null
                                        ? l.lastBackupNever
                                        : l.lastBackup(
                                            DateFormat.MMMd().add_jm().format(
                                              last.toLocal(),
                                            ),
                                          ),
                                    style: AppText.body(
                                      12,
                                      weight: FontWeight.w700,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 14,
                                        child: _Busy(
                                          busy: _busy == _Job.backup,
                                          child: BoldButton(
                                            label: l.backupNow,
                                            kind: BoldButtonKind.dark,
                                            size: BoldButtonSize.medium,
                                            expand: true,
                                            onPressed: () =>
                                                _run(_Job.backup, _backup),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 10,
                                        child: BoldButton(
                                          label: l.restore,
                                          kind: BoldButtonKind.secondary,
                                          size: BoldButtonSize.medium,
                                          weight: FontWeight.w700,
                                          expand: true,
                                          onPressed: () async {
                                            final msg = await context
                                                .push<String>(Routes.restore);
                                            if (msg != null) showToast(msg);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      section(
                        icon: AppIcons.download,
                        iconFill: AppColors.sun,
                        title: l.importTitle,
                        text: l.importBody,
                        buttons: _Busy(
                          busy: _busy == _Job.import,
                          child: BoldButton(
                            label: l.chooseHtml,
                            size: BoldButtonSize.medium,
                            shadow: true,
                            expand: true,
                            onPressed: () => _run(_Job.import, _import),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      section(
                        icon: AppIcons.upload,
                        iconFill: AppColors.grape,
                        title: l.exportTitle,
                        text: l.exportBody,
                        buttons: Row(
                          children: [
                            Expanded(
                              child: _Busy(
                                busy: _busy == _Job.exportHtml,
                                child: BoldButton(
                                  label: l.exportHtml,
                                  kind: BoldButtonKind.secondary,
                                  size: BoldButtonSize.medium,
                                  weight: FontWeight.w700,
                                  expand: true,
                                  onPressed: () => _run(
                                    _Job.exportHtml,
                                    () => _export(actions.exportHtml),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _Busy(
                                busy: _busy == _Job.exportJson,
                                child: BoldButton(
                                  label: l.exportJson,
                                  kind: BoldButtonKind.secondary,
                                  size: BoldButtonSize.medium,
                                  weight: FontWeight.w700,
                                  expand: true,
                                  onPressed: () => _run(
                                    _Job.exportJson,
                                    () => _export(actions.exportJson),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(left: 16, right: 18, bottom: 22, child: toastLayer()),
          ],
        ),
      ),
    );
  }
}

/// Dims a button and shows a small spinner while its job runs.
class _Busy extends StatelessWidget {
  const _Busy({required this.busy, required this.child});

  final bool busy;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!busy) return child;
    return Stack(
      alignment: Alignment.center,
      children: [
        IgnorePointer(child: Opacity(opacity: 0.5, child: child)),
        const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      ],
    );
  }
}
