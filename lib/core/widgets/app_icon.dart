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
  static const upload = AppIconData(
      '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M17 8l-5-5-5 5M12 3v12"/>');
  static const file = AppIconData(
      '<path d="M14 3H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"/><path d="M14 3v6h6"/>');
  static const shield = AppIconData(
      '<path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z"/>');
  static const mail =
      AppIconData('<path d="M3 6h18v12H3zM3 7l9 6 9-6"/>');
  static const lock = AppIconData(
      '<rect x="4" y="11" width="16" height="10" rx="2.5"/><path d="M8 11V7a4 4 0 0 1 8 0v4" fill="none"/><circle cx="12" cy="16" r="1.5" fill="#141414"/>');
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

  static const palette = AppIconData(
      '<path d="M12 3a9 9 0 1 0 0 18c1 0 1.5-.7 1.5-1.5 0-.4-.2-.8-.4-1.1-.3-.3-.4-.7-.4-1.1 0-.8.7-1.5 1.5-1.5H16a5 5 0 0 0 5-5c0-4.4-4-8-9-8zM7.5 11.5h.01M10.5 7.5h.01M15.5 7.5h.01"/>');
  static const pin = AppIconData('<path d="M12 17v5M5 17h14l-2-4V5H7v8z"/>');

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

  static const heart = AppIconData(
      '<path d="M20.8 4.6a5.5 5.5 0 0 0-7.8 0L12 5.7l-1-1.1a5.5 5.5 0 0 0-7.8 7.8l1 1.1L12 21l7.8-7.5 1-1.1a5.5 5.5 0 0 0 0-7.8z"/>');
  static const bag = AppIconData(
      '<path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4zM3 6h18M16 10a4 4 0 0 1-8 0"/>');
  static const camera = AppIconData(
      '<path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/>');
  static const video = AppIconData(
      '<rect x="2" y="5" width="15" height="14" rx="2"/><path d="m22 8-5 4 5 4z"/>');
  static const game = AppIconData(
      '<rect x="2" y="7" width="20" height="10" rx="4"/><path d="M6 12h4M8 10v4M15 11h.01M18 13h.01"/>');
  static const place = AppIconData(
      '<path d="M12 22s7-6.2 7-12a7 7 0 0 0-14 0c0 5.8 7 12 7 12z"/><circle cx="12" cy="10" r="2.5"/>');
  static const work = AppIconData(
      '<rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2M2 13h20"/>');
  static const school =
      AppIconData('<path d="M22 10 12 5 2 10l10 5 10-5zM6 12v5c3 2 9 2 12 0v-5"/>');
  static const food = AppIconData(
      '<path d="M4 11h16a8 8 0 0 1-16 0zM12 3v4M8 4v3M16 4v3"/>');
  static const fitness =
      AppIconData('<path d="M6 6v12M18 6v12M3 9v6M21 9v6M6 12h12"/>');
  static const gift = AppIconData(
      '<rect x="3" y="8" width="18" height="4" rx="1"/><path d="M12 8v13M19 12v7a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2v-7M7.5 8a2.5 2.5 0 0 1 0-5C11 3 12 8 12 8s1-5 4.5-5a2.5 2.5 0 0 1 0 5"/>');
  static const idea = AppIconData(
      '<path d="M9 18h6M10 22h4M12 2a7 7 0 0 0-4 12.7V17h8v-2.3A7 7 0 0 0 12 2z"/>');
  static const globe = AppIconData(
      '<circle cx="12" cy="12" r="10"/><path d="M2 12h20M12 2a15 15 0 0 1 0 20M12 2a15 15 0 0 0 0 20"/>');
  static const leaf = AppIconData(
      '<path d="M11 20A7 7 0 0 1 4 13c0-6 6-10 16-10 0 10-4 16-10 16zM4 21c3-6 7-9 11-11"/>');
  static const coffee = AppIconData(
      '<path d="M17 8h1a4 4 0 0 1 0 8h-1M3 8h14v9a4 4 0 0 1-4 4H7a4 4 0 0 1-4-4zM6 2v3M10 2v3M14 2v3"/>');
  static const car = AppIconData(
      '<path d="M3 13l2-6h14l2 6v4H3z"/><circle cx="7.5" cy="17" r="1.5"/><circle cx="16.5" cy="17" r="1.5"/>');
  static const news = AppIconData(
      '<rect x="3" y="4" width="18" height="16" rx="2"/><path d="M7 8h10M7 12h10M7 16h6"/>');
  static const people = AppIconData(
      '<circle cx="9" cy="8" r="3.5"/><path d="M2 20c0-3.9 3.1-7 7-7s7 3.1 7 7M16 4.5a3.5 3.5 0 0 1 0 7M18 13.5c2.4.8 4 3.2 4 6.5"/>');

  /// Collection icons (screen 20), in picker order. The key is stored.
  static const collectionIcons = <String, AppIconData>{
    'star': star,
    'heart': heart,
    'plane': plane,
    'home': home,
    'code': code,
    'book': book,
    'music': music,
    'video': video,
    'camera': camera,
    'game': game,
    'food': food,
    'coffee': coffee,
    'bag': bag,
    'gift': gift,
    'work': work,
    'school': school,
    'idea': idea,
    'news': news,
    'fitness': fitness,
    'leaf': leaf,
    'place': place,
    'globe': globe,
    'car': car,
    'people': people,
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
    this.fill,
  });

  final AppIconData icon;
  final double size;
  final Color? color;
  final double? strokeWidth;

  /// Fills the shape (e.g. the big sun-filled star in 19).
  final Color? fill;

  @override
  Widget build(BuildContext context) {
    final c = color ?? DefaultTextStyle.of(context).style.color!;
    String toHex(Color c) =>
        '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
    final hex = toHex(c);
    final fillHex = fill != null ? toHex(fill!) : (icon.filled ? hex : 'none');
    final opacity = c.a;
    final svg =
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" '
        'fill="$fillHex" stroke="$hex" '
        'stroke-width="${strokeWidth ?? icon.stroke}" stroke-linecap="round" '
        'stroke-linejoin="round" opacity="$opacity">${icon.body}</svg>';
    return ExcludeSemantics(
      child: SvgPicture.string(svg, width: size, height: size),
    );
  }
}
