import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/app_theme.dart';
import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_card.dart';
import '../../core/widgets/mascot.dart';
import '../../l10n/app_localizations.dart';
import '../settings/theme_settings.dart';

/// First-launch intro: welcome (16), share (17), private (18).
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _pages = PageController();

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _go(int page) => AppMotion.reduce(context)
      ? _pages.jumpToPage(page)
      : _pages.animateToPage(
          page,
          duration: AppMotion.sheet,
          curve: AppMotion.emphasized,
        );

  void _finish() {
    ref.read(onboardingDoneProvider.notifier).set(true);
    context.go(Routes.links);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final accent = context.tokens.accent;

    final steps = [
      _Step(
        color: AppColors.sun,
        art: const _WelcomeArt(),
        title: l.ob1Title,
        body: TextSpan(text: l.ob1Body),
        button: l.letsGo,
        arrow: true,
        onButton: () => _go(1),
        onSkip: _finish,
      ),
      _Step(
        color: AppColors.pink,
        art: _ShareArt(l: l),
        title: l.ob2Title,
        body: _boldWords(l.ob2Body(l.shareWord, l.appTitle), [
          l.shareWord,
          l.appTitle,
        ]),
        button: l.next,
        arrow: true,
        onButton: () => _go(2),
        onBack: () => _go(0),
      ),
      _Step(
        color: AppColors.mint,
        art: const _PrivateArt(),
        title: l.ob3Title,
        body: TextSpan(text: l.ob3Body),
        bodySize: 15,
        button: l.startSaving,
        onButton: _finish,
        onBack: () => _go(1),
      ),
    ];

    // The intro always uses the light look, like the mockups.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Theme(
        data: AppTheme.light(accent),
        child: Scaffold(
          body: PageView.builder(
            controller: _pages,
            itemCount: steps.length,
            itemBuilder: (context, i) =>
                _StepView(step: steps[i], index: i, count: steps.length, l: l),
          ),
        ),
      ),
    );
  }

  /// Makes [words] inside [text] extra bold.
  static TextSpan _boldWords(String text, List<String> words) {
    final spans = <TextSpan>[];
    var rest = text;
    while (rest.isNotEmpty) {
      var at = -1;
      String? word;
      for (final w in words) {
        final i = rest.indexOf(w);
        if (i >= 0 && (at < 0 || i < at)) {
          at = i;
          word = w;
        }
      }
      if (word == null) {
        spans.add(TextSpan(text: rest));
        break;
      }
      if (at > 0) spans.add(TextSpan(text: rest.substring(0, at)));
      spans.add(
        TextSpan(
          text: word,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      );
      rest = rest.substring(at + word.length);
    }
    return TextSpan(children: spans);
  }
}

class _Step {
  const _Step({
    required this.color,
    required this.art,
    required this.title,
    required this.body,
    required this.button,
    required this.onButton,
    this.arrow = false,
    this.bodySize = 16,
    this.onSkip,
    this.onBack,
  });

  final Color color;
  final Widget art;
  final String title;
  final TextSpan body;
  final double bodySize;
  final String button;
  final bool arrow;
  final VoidCallback onButton;
  final VoidCallback? onSkip;
  final VoidCallback? onBack;
}

class _StepView extends StatelessWidget {
  const _StepView({
    required this.step,
    required this.index,
    required this.count,
    required this.l,
  });

  final _Step step;
  final int index;
  final int count;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = AppText.body(
      step.bodySize,
      height: 1.5,
      color: AppColors.ink,
    );
    return ColoredBox(
      color: step.color,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: SizedBox(
                height: 44,
                child: Row(
                  children: [
                    if (step.onBack != null)
                      Tooltip(
                        message: l.back,
                        child: BoldCard(
                          width: 44,
                          height: 44,
                          fill: AppColors.white,
                          radius: AppShape.rSmall,
                          onTap: step.onBack,
                          semanticLabel: l.back,
                          child: const Center(
                            child: AppIcon(
                              AppIcons.back,
                              size: 20,
                              strokeWidth: 2.8,
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    if (step.onSkip != null)
                      BoldCard(
                        height: 44,
                        fill: AppColors.white,
                        radius: AppShape.rSmall,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        onTap: step.onSkip,
                        semanticLabel: l.skip,
                        child: Center(
                          widthFactor: 1,
                          child: Text(
                            l.skip,
                            style: AppText.body(
                              14,
                              weight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // The 390 × 420 illustration, scaled to fit the screen.
            Expanded(
              child: ExcludeSemantics(
                child: FittedBox(
                  child: SizedBox(width: 390, height: 420, child: step.art),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                24,
                30,
                24,
                28 + MediaQuery.viewPaddingOf(context).bottom,
              ),
              decoration: const BoxDecoration(
                color: AppColors.paper,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppShape.rPanel),
                ),
                border: Border(
                  top: BorderSide(color: AppColors.ink, width: AppShape.stroke),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    label: l.stepOf(index + 1, count),
                    child: Row(
                      children: [
                        for (var i = 0; i < count; i++) ...[
                          if (i > 0) const SizedBox(width: 6),
                          AnimatedContainer(
                            duration: AppMotion.select,
                            width: i == index ? 28 : 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: i == index ? AppColors.ink : null,
                              borderRadius: BorderRadius.circular(5),
                              border: i == index
                                  ? null
                                  : Border.all(
                                      color: AppColors.ink,
                                      width: AppShape.strokeThin,
                                    ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Semantics(
                    header: true,
                    child: Text(
                      step.title,
                      style: AppText.display(
                        40,
                        height: 1.02,
                        letterSpacing: -1,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text.rich(TextSpan(style: bodyStyle, children: [step.body])),
                  const SizedBox(height: 28),
                  BoldButton(
                    label: step.button,
                    trailingIcon: step.arrow ? AppIcons.arrowRight : null,
                    expand: true,
                    onPressed: step.onButton,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------- Illustrations

Widget _miniCard({
  required double left,
  double? right,
  required double top,
  required Color fill,
  required Color picture,
  required String tag,
  required String number,
  required double angle,
}) => Positioned(
  left: right == null ? left : null,
  right: right,
  top: top,
  child: Transform.rotate(
    angle: angle * 3.14159 / 180,
    child: Container(
      width: 120,
      height: 150,
      padding: const EdgeInsets.all(8),
      decoration: boldBox(
        fill: fill,
        outline: AppColors.ink,
        radius: AppShape.rControl,
        shadow: AppShadows.hard(AppShadows.offMd, AppColors.ink),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tag, style: AppText.display(11, color: AppColors.ink)),
          const SizedBox(height: 6),
          Expanded(
            child: Container(
              decoration: boldBox(
                fill: picture,
                outline: AppColors.ink,
                radius: 10,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              number,
              style: AppText.display(11, color: AppColors.ink),
            ),
          ),
        ],
      ),
    ),
  ),
);

/// 16: two tilted cards and the big mascot with arms.
class _WelcomeArt extends StatelessWidget {
  const _WelcomeArt();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _miniCard(
          left: 22,
          top: 50,
          fill: AppColors.pink,
          picture: AppColors.sky,
          tag: 'DESIGN',
          number: 'NO.001',
          angle: -12,
        ),
        _miniCard(
          left: 0,
          right: 22,
          top: 30,
          fill: AppColors.sky,
          picture: AppColors.cream,
          tag: 'DEV',
          number: 'NO.002',
          angle: 10,
        ),
        Positioned(
          left: 195 - 46,
          top: 22,
          child: Transform.rotate(
            angle: 2 * 3.14159 / 180,
            child: Container(
              width: 92,
              height: 112,
              decoration: boldBox(
                fill: AppColors.mint,
                outline: AppColors.ink,
                radius: 16,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 85,
          top: 150,
          child: BlinkingMascot(size: 220, bodyColor: AppColors.white),
        ),
      ],
    );
  }
}

/// 17: a share sheet with Linkly highlighted, and the mascot looking up.
class _ShareArt extends StatelessWidget {
  const _ShareArt({required this.l});

  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    Widget appIcon({bool linkbox = false}) => linkbox
        ? Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.sun,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.ink, width: 3),
              boxShadow: AppShadows.hard(AppShadows.offSm, AppColors.ink),
            ),
            child: const Center(
              child: Mascot(
                MascotMood.happy,
                size: 26,
                bodyColor: AppColors.white,
              ),
            ),
          )
        : Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFCFCFCF), width: 2),
            ),
          );
    Widget label(String s, {bool strong = false}) => SizedBox(
      width: 64,
      child: Text(
        s,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppText.body(
          11,
          weight: strong ? FontWeight.w800 : FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 40,
          top: 30,
          child: Transform.rotate(
            angle: -3 * 3.14159 / 180,
            child: Container(
              width: 310,
              padding: const EdgeInsets.all(16),
              decoration: boldBox(
                fill: AppColors.white,
                outline: AppColors.ink,
                radius: 26,
                shadow: AppShadows.hard(AppShadows.offLg, AppColors.ink),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: boldBox(
                          fill: AppColors.sky,
                          outline: AppColors.ink,
                          radius: AppShape.rTiny,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.ink,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 100,
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFFCFCFCF),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l.shareTo,
                    style: AppText.display(16, color: AppColors.ink),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      appIcon(),
                      appIcon(),
                      appIcon(linkbox: true),
                      appIcon(),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      label(l.shareMessages),
                      label(l.shareMail),
                      label(l.appTitle, strong: true),
                      label(l.shareMore),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // Dotted arrow up to the Linkly icon.
        Positioned(
          left: 150,
          top: 250,
          child: CustomPaint(
            size: const Size(110, 110),
            painter: _ArrowPainter(),
          ),
        ),
        const Positioned(
          left: 40,
          top: 300,
          child: Mascot(MascotMood.happy, size: 110),
        ),
      ],
    );
  }
}

class _ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.ink
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final curve = Path()
      ..moveTo(30, 100)
      ..cubicTo(20, 60, 60, 50, 58, 14);
    for (final m in curve.computeMetrics()) {
      for (var d = 0.0; d < m.length; d += 12) {
        canvas.drawPath(m.extractPath(d, d + 2), paint);
      }
    }
    canvas.drawPath(
      Path()
        ..moveTo(46, 22)
        ..lineTo(58, 8)
        ..lineTo(70, 24),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArrowPainter old) => false;
}

/// 18: a phone with link rows, a lock badge and the sleepy mascot.
class _PrivateArt extends StatelessWidget {
  const _PrivateArt();

  @override
  Widget build(BuildContext context) {
    Widget row(Color c) => Container(
      height: 54,
      decoration: boldBox(fill: c, outline: AppColors.ink, radius: 12),
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 112,
          top: 26,
          child: Container(
            width: 166,
            height: 300,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(34),
              border: Border.all(color: AppColors.ink, width: 3),
              boxShadow: AppShadows.hard(AppShadows.offXl, AppColors.ink),
            ),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 10),
                row(AppColors.pink),
                const SizedBox(height: 10),
                row(AppColors.sky),
                const SizedBox(height: 10),
                row(AppColors.sun),
              ],
            ),
          ),
        ),
        Positioned(
          left: 230,
          top: 200,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.ink, width: 3),
              boxShadow: AppShadows.hard(AppShadows.offMd, AppColors.ink),
            ),
            child: const Center(
              child: AppIcon(
                AppIcons.lock,
                size: 44,
                strokeWidth: 2.2,
                color: AppColors.ink,
                fill: AppColors.white,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 30,
          top: 240,
          child: Mascot(MascotMood.sleepy, size: 130),
        ),
      ],
    );
  }
}
