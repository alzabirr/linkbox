import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/providers.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/mascot.dart';
import '../../l10n/app_localizations.dart';
import 'clipboard_prompt_controller.dart';

/// Watches app resume: checks the clipboard and finishes pending previews.
/// Shows the clipboard prompt (02) at the bottom of [child].
class ClipboardPromptHost extends ConsumerStatefulWidget {
  const ClipboardPromptHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ClipboardPromptHost> createState() =>
      _ClipboardPromptHostState();
}

class _ClipboardPromptHostState extends ConsumerState<ClipboardPromptHost>
    with WidgetsBindingObserver {
  static const _autoHide = Duration(seconds: 8);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _check();
      ref.read(linkRepositoryProvider).resumePending();
    }
  }

  void _check() => ref.read(clipboardPromptProvider.notifier).check();

  @override
  Widget build(BuildContext context) {
    final url = ref.watch(clipboardPromptProvider);
    ref.listen(clipboardPromptProvider, (_, next) {
      _timer?.cancel();
      if (next != null) {
        _timer = Timer(
            _autoHide, ref.read(clipboardPromptProvider.notifier).dismiss);
      }
    });
    final reduce = AppMotion.reduce(context);

    return Stack(
      children: [
        widget.child,
        Positioned(
          left: 14,
          right: 16,
          bottom: 14,
          child: AnimatedSwitcher(
            duration: reduce ? AppMotion.reduced : AppMotion.pop,
            switchInCurve: reduce ? Curves.linear : Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, anim) => reduce
                ? FadeTransition(opacity: anim, child: child)
                : SlideTransition(
                    position: Tween(
                            begin: const Offset(0, 1.4), end: Offset.zero)
                        .animate(anim),
                    child: child,
                  ),
            child: url == null
                ? const SizedBox.shrink()
                : _Prompt(key: ValueKey(url), url: url),
          ),
        ),
      ],
    );
  }
}

class _Prompt extends ConsumerWidget {
  const _Prompt({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final accent = context.tokens.accent;
    final notifier = ref.read(clipboardPromptProvider.notifier);
    // The sun card always uses light-mode colors, also in dark mode.
    return Theme(
      data: AppTheme.light(accent),
      child: Semantics(
        liveRegion: true,
        child: BoldCard(
          fill: AppColors.sun,
          outline: AppColors.ink,
          radius: AppShape.rSection,
          shadow: AppShadows.offMd,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Mascot(MascotMood.happy,
                      size: 46, bodyColor: AppColors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.clipboardTitle,
                            style:
                                AppText.display(17, color: AppColors.ink)),
                        const SizedBox(height: 2),
                        Text(
                          url.replaceFirst(RegExp(r'^https?://(www\.)?'), ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.body(13, color: AppColors.ink),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BoldButton(
                    label: l.notNow,
                    kind: BoldButtonKind.secondary,
                    size: BoldButtonSize.small,
                    onPressed: notifier.dismiss,
                  ),
                  const SizedBox(width: 8),
                  BoldButton(
                    label: l.saveLink,
                    kind: BoldButtonKind.dark,
                    size: BoldButtonSize.small,
                    onPressed: notifier.save,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
