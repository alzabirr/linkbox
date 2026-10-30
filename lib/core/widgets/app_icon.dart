import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A simple stroke icon on a 24×24 grid, copied from the mockups' SVGs.
@immutable
class AppIconData {
  const AppIconData(this.body, {this.stroke = 2.4, this.filled = false});

  /// SVG elements inside the 24×24 viewBox.
  final String body;

  /// Default stroke width used in the mockups.
  final double stroke;

  /// Filled glyphs (play triangle) use the color as fill too.
  final bool filled;
}

class AppIcons {
  AppIcons._();

  static const sort = AppIconData('<path d="M4 6h16M7 12h10M10 18h4"/>');
  static const list = AppIconData(
    '<path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/>',
  );
  static const grid = AppIconData(
    '<rect x="3" y="3" width="7" height="7" rx="1.5"/><rect x="14" y="3" width="7" height="7" rx="1.5"/>'
    '<rect x="3" y="14" width="7" height="7" rx="1.5"/><rect x="14" y="14" width="7" height="7" rx="1.5"/>',
  );
  static const search = AppIconData(
    '<circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/>',
  );
  static const link = AppIconData(
    '<path d="M10 13a5 5 0 0 0 7.07 0l3-3a5 5 0 0 0-7.07-7.07l-1.5 1.5"/>'
    '<path d="M14 11a5 5 0 0 0-7.07 0l-3 3a5 5 0 0 0 7.07 7.07l1.5-1.5"/>',
  );
  static const linkOff = AppIconData(
    '<path d="M10 13a5 5 0 0 0 7.07 0l3-3a5 5 0 0 0-7.07-7.07l-1.5 1.5"/>'
    '<path d="M14 11a5 5 0 0 0-7.07 0l-3 3a5 5 0 0 0 7.07 7.07l1.5-1.5"/><path d="M3 3l18 18"/>',
  );
  static const folder = AppIconData(
    '<path d="M3 7a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>',
  );
  static const sliders = AppIconData(
    '<path d="M4 21v-7M4 10V3M12 21v-9M12 8V3M20 21v-5M20 12V3M1 14h6M9 8h6M17 16h6"/>',
  );
  static const plus = AppIconData('<path d="M12 5v14M5 12h14"/>', stroke: 3);
  static const close = AppIconData(
    '<path d="M18 6 6 18M6 6l12 12"/>',
    stroke: 3,
  );
  static const check = AppIconData('<path d="M20 6 9 17l-5-5"/>', stroke: 3.2);
  static const paste = AppIconData(
    '<rect x="8" y="2" width="8" height="4" rx="1"/>'
    '<path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/>',
  );
  static const more = AppIconData(
    '<circle cx="12" cy="5" r="1"/><circle cx="12" cy="12" r="1"/><circle cx="12" cy="19" r="1"/>',
    stroke: 3,
  );
  static const back = AppIconData(
    '<path d="M19 12H5M12 19l-7-7 7-7"/>',
    stroke: 2.6,
  );
  static const arrowRight = AppIconData(
    '<path d="M5 12h14M12 5l7 7-7 7"/>',
    stroke: 3,
  );
  static const chevronRight = AppIconData(
    '<path d="m9 18 6-6-6-6"/>',
    stroke: 2.8,
  );
  static const download = AppIconData(
    '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/>',
  );
  static const retry = AppIconData(
    '<path d="M21 12a9 9 0 1 1-3-6.7L21 8M21 3v5h-5"/>',
    stroke: 2.8,
  );
  static const share = AppIconData(
    '<circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/>'
    '<path d="m8.6 13.5 6.8 4M15.4 6.5l-6.8 4"/>',
  );

  static const external = AppIconData(
    '<path d="M15 3h6v6M10 14 21 3M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/>',
    stroke: 2.6,
  );
  static const copy = AppIconData(
    '<rect x="9" y="9" width="12" height="12" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>',
  );
  static const shareUp = AppIconData(
    '<path d="M4 12v8h16v-8M16 6l-4-4-4 4M12 2v13"/>',
  );
  static const edit = AppIconData(
    '<path d="M12 20h9"/><path d="M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4z"/>',
  );
  static const moveTo = AppIconData(
    '<path d="M3 7a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><path d="M9 13h6M12 10l3 3-3 3"/>',
  );
  static const trash = AppIconData(
    '<path d="M3 6h18M8 6V4h8v2M6 6l1 14a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2l1-14"/>',
  );
  static const image = AppIconData(
    '<rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="9" cy="9" r="2"/><path d="m21 15-5-5L5 21"/>',
  );
  static const chevronDown = AppIconData(
    '<path d="m6 9 6 6 6-6"/>',
    stroke: 2.6,
  );
  static const selectMore = AppIconData(
    '<path d="M9 11l3 3 8-8M20 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h11"/>',
  );

  /// Card badge glyphs (filled, stroke 2).
  static const play = AppIconData(
    '<path d="M9 7v10l8-5z"/>',
    stroke: 2,
    filled: true,
  );
  static const playBig = AppIconData(
    '<path d="M9 6v12l9-6z"/>',
    stroke: 2,
    filled: true,
  );
  static const lines = AppIconData(
    '<path d="M7 6h10M7 12h10M7 18h6"/>',
    stroke: 2,
    filled: true,
  );

  /// Collection icons (screen 20).
  static const plane = AppIconData(
    '<path d="M2 16l20-8-8 14-2-6zM12 16l10-8"/>',
  );
  static const star = AppIconData(
    '<path d="M12 3l2.5 5.5L20 9l-4 4 1 6-5-3-5 3 1-6-4-4 5.5-.5z"/>',
  );
  static const code = AppIconData('<path d="M8 7l-5 5 5 5M16 7l5 5-5 5"/>');
  static const book = AppIconData(
    '<path d="M4 5h6a2 2 0 0 1 2 2v13a2 2 0 0 0-2-2H4zM20 5h-6a2 2 0 0 0-2 2v13a2 2 0 0 1 2-2h6z"/>',
  );
  static const home = AppIconData('<path d="M3 11l9-7 9 7v9H3zM9 20v-6h6v6"/>');
  static const music = AppIconData(
    '<path d="M9 18V5l11-2v13M9 18a3 3 0 1 1-6 0 3 3 0 0 1 6 0zM20 16a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>',
  );

  static const collectionIcons = <String, AppIconData>{
    'star': star,
    'code': code,
    'book': book,
    'plane': plane,
    'home': home,
    'music': music,
  };
}

/// Draws an [AppIconData] in [color]. Decorative: wrap the button, not the
/// icon, in a Semantics label / tooltip.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size = 22,
    this.color,
    this.strokeWidth,
  });

  final AppIconData icon;
  final double size;
  final Color? color;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    final c = color ?? DefaultTextStyle.of(context).style.color!;
    final hex =
        '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
    final opacity = c.a;
    final svg =
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" '
        'fill="${icon.filled ? hex : 'none'}" stroke="$hex" '
        'stroke-width="${strokeWidth ?? icon.stroke}" stroke-linecap="round" '
        'stroke-linejoin="round" opacity="$opacity">${icon.body}</svg>';
    return ExcludeSemantics(
      child: SvgPicture.string(svg, width: size, height: size),
    );
  }
}
