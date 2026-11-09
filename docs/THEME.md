# Linkly – Theme and design tokens

One rule sets the look: every surface gets a **2.5 px ink outline**, a **flat bright fill** and,
when it is tappable and important, a **hard offset shadow with no blur**.
Put every value below in `lib/app/theme/` and never hard-code one in a widget.

Mockups: `design/screens/*.png` (look) and `design/html/*.html` (exact values).
The token board is `design/html/99-design-tokens-board.html`.

---

## 1. Colors

| Token | Hex | Used for |
| --- | --- | --- |
| `ink` | `#141414` | All text, outlines, shadows |
| `paper` | `#FDF6EC` | App background (light) |
| `surface` | `#FFFFFF` | Cards, inputs, nav bar, list rows |
| `sand` | `#F3EBDD` | Disabled fields, switch track off, segmented track |
| `sandLine` | `#D9CDB8` | Dashed dividers |
| `muted` | `#4A4A4A` | Secondary text on light backgrounds |
| `primary` | `#FF8A3D` | Main buttons, FAB (user can change it in Settings) |
| `sun` | `#FFD23F` | Selected state, prompts, active nav pill |
| `pink` | `#FF9FC4` | Card / collection fill |
| `sky` | `#7CC4FF` | Card / collection fill |
| `mint` | `#7DDBA3` | Card fill, success, switch on |
| `grape` | `#B79CFF` | Card fill |
| `peach` | `#FF9F6B` | Card fill |
| `cream` | `#FFF1C7` | Scene sky variant |
| `danger` | `#FF6B5E` | Delete buttons (text on it stays ink) |
| `dangerText` | `#B42318` | "Delete" word in menus |

**Text on any colored fill is always `ink`.** All pairs pass 4.5:1.

### Dark and AMOLED

| Token | Light | Dark (AMOLED) |
| --- | --- | --- |
| background | `#FDF6EC` | `#000000` |
| sheet / surface | `#FFFFFF` | `#141414` |
| outline + shadow | `#141414` | `#FFFFFF` |
| text | `#141414` | `#FFFFFF` (inside colored cards: still `#141414`) |
| secondary text | `#4A4A4A` | `#C8C8C8` |
| card fills | palette | same palette |

### Accent choices (Settings › Theme color, screen 25)

`#FF8A3D` Orange (default) · `#FFD23F` Sun · `#7DDBA3` Mint · `#7CC4FF` Sky · `#B79CFF` Grape ·
`#FF9FC4` Pink · `#FF9F6B` Peach · `#C6EB5B` Lime · `#5ED3C6` Teal · `#FF6B5E` Coral ·
`#D7B8FF` Lilac · `#E8C9A0` Sand

### Collection colors

Pink `#FF9FC4`, Sky `#7CC4FF`, Sun `#FFD23F`, Mint `#7DDBA3`, Grape `#B79CFF`, Peach `#FF9F6B`.

---

## 2. Typography

Display font: **Bricolage Grotesque** (800). Body font: **Outfit** (400–700).
Bangla fallback: **Hind Siliguri** (or Noto Sans Bengali). All are free Google Fonts (OFL).

| Flutter style | Font | Size / weight | Used for |
| --- | --- | --- | --- |
| `displayLarge` | Bricolage Grotesque | 40 / 800, height 1.02, letterSpacing −1 | Onboarding + empty headlines |
| `headlineLarge` | Bricolage Grotesque | 32 / 800, height 1.0, letterSpacing −0.8 | Screen titles ("Your links") |
| `headlineMedium` | Bricolage Grotesque | 26–28 / 800 | Sheet titles, dialogs |
| `titleLarge` | Bricolage Grotesque | 20–22 / 800 | Card headings, section titles |
| `titleMedium` | Bricolage Grotesque | 17–18 / 800 | Settings section titles |
| `labelLarge` | Outfit | 16–17 / 800 | Primary buttons |
| `bodyLarge` | Outfit | 15–16 / 500, height 1.5 | Body text |
| `titleSmall` | Outfit | 14–15 / 700 | Card titles, list row titles |
| `bodySmall` | Outfit | 13 / 500 | Descriptions |
| `labelSmall` | Outfit | 12 / 600 | Domain, meta, nav labels |
| card tag | Bricolage Grotesque | 12 / 800, UPPERCASE, letterSpacing 0.4 | "DESIGN", "NO.001" |

For Bangla text use line height 1.6.

---

## 3. Shape, stroke, shadow, spacing

| Token | Value | Used for |
| --- | --- | --- |
| `stroke` | 2.5 | Every card, chip, input, button |
| `strokeHeavy` | 3.5 | Selected card (multi-select), selected swatch |
| `strokeThin` | 2 | Small badges, nav pill, mini tags |
| `shadowSm` | Offset(3, 3), blur 0, ink | Small buttons, list rows, selected chips |
| `shadowMd` | Offset(4, 4), blur 0, ink | Cards, FAB, primary buttons |
| `shadowLg` | Offset(5, 5)–(6, 6), blur 0, ink | Big cards, dialogs |
| `radiusChip` | 19 (fully round pill) | Chips |
| `radiusSmall` | 12–14 | Icon buttons, thumbs, small buttons |
| `radiusControl` | 16–18 | Inputs, buttons, search bar |
| `radiusCard` | 20–22 | Link cards, sections |
| `radiusBig` | 24–28 | Sheets (top corners), dialogs, onboarding panel (32) |
| spacing | 4 · 8 · 12 · 16 · 20 · 24 | Screen side padding 16–18; card gap 14; list gap 10 |
| touch target | 44 × 44 minimum | Everything tappable |

### Common sizes

| Element | Size |
| --- | --- |
| Icon button box | 46 × 46, radius 14 |
| Search bar | height 52, radius 18 |
| Chip | height 38, radius 19, padding 0 16 |
| Primary button | height 56–60, radius 18–20 |
| FAB "Add link" | height 58, radius 20, shadow 4 |
| List row | min height 68, thumb 52 × 52 radius 13 |
| Grid card | 2 columns, gap 14, picture area height 92, radius 20 |
| Bottom nav | height 84, top border 2.5, active pill 60 × 32 sun |
| Bottom sheet | top radius 28, top border 2.5, grabber 44 × 5 ink |
| Switch | 58 × 34, thumb 23 |

---

## 4. Motion

| Element | Animation | Timing |
| --- | --- | --- |
| Card / button press | Shadow 4 → 0 and widget moves +4, +4 ("pushed in") | 90 ms easeOut |
| Bottom sheet | Slide up + scrim 0 → 50% | 280 ms emphasized |
| Clipboard prompt / Saved overlay | Slide up with small overshoot | 320 ms spring |
| Select a card | Check badge scale 0.6 → 1, border 2.5 → 3.5 | 160 ms |
| Grid ↔ list | Cross-fade (`AnimatedSwitcher`) | 200 ms |
| Delete | Cards shrink + fade, grid reflows | 220 ms |
| Undo bar | Progress line shrinks over 5 s | linear |
| Mascot (empty state only) | Blink every 4 s | 120 ms |

If `MediaQuery.of(context).disableAnimations` is true, use a 120 ms fade instead of all of the above.

---

## 5. Link card artwork

When a link has an image, show it inside the card's framed picture area (2.5 border, radius 14).
When it has none, draw the flat "scene" from the mockups with a `CustomPainter`:

- sky rectangle (fill A)
- sun circle top-right, r ≈ 11, 2.5 ink stroke (fill B)
- wavy hill along the bottom, 2.5 ink stroke (fill C)
- white circle badge with a play triangle (video) or three lines (article/post)

Pick fills A/B/C from the palette using `url.hashCode`, so the same link always gets the same colors.
Card frame color: one of pink / sky / sun / peach / mint / grape, also by hash.

---

## 6. Mascot

Original bookmark-shaped character. SVGs in `assets/mascot/`, drawn with `flutter_svg`,
wrapped in `ExcludeSemantics` (decoration only).

| File | Mood | Used on screens |
| --- | --- | --- |
| `happy.svg` | Happy | 05, 16, 02 (clipboard), 24 |
| `surprised.svg` | Surprised | 07 duplicate |
| `sad.svg` | Sad | 11 delete dialog |
| `confused.svg` | Confused | 23 no results |
| `sleepy.svg` | Sleepy | 18 privacy |
| `cheer.svg` | Cheering | 22 saved, 14 backup |

---

## 7. Flutter starting code

`lib/app/theme/tokens.dart`

```dart
import 'package:flutter/material.dart';

class AppColors {
  static const ink = Color(0xFF141414);
  static const paper = Color(0xFFFDF6EC);
  static const surface = Color(0xFFFFFFFF);
  static const sand = Color(0xFFF3EBDD);
  static const sandLine = Color(0xFFD9CDB8);
  static const muted = Color(0xFF4A4A4A);
  static const primary = Color(0xFFFF8A3D);
  static const sun = Color(0xFFFFD23F);
  static const pink = Color(0xFFFF9FC4);
  static const sky = Color(0xFF7CC4FF);
  static const mint = Color(0xFF7DDBA3);
  static const grape = Color(0xFFB79CFF);
  static const peach = Color(0xFFFF9F6B);
  static const cream = Color(0xFFFFF1C7);
  static const danger = Color(0xFFFF6B5E);
  static const dangerText = Color(0xFFB42318);

  static const cardFills = [pink, sky, sun, peach, mint, grape];
}

class AppShape {
  static const stroke = 2.5;
  static const strokeHeavy = 3.5;
  static const rChip = 19.0;
  static const rSmall = 14.0;
  static const rControl = 18.0;
  static const rCard = 20.0;
  static const rSheet = 28.0;
}

class AppShadows {
  static List<BoxShadow> hard(double o, {Color color = AppColors.ink}) =>
      [BoxShadow(color: color, offset: Offset(o, o), blurRadius: 0)];
  static final sm = hard(3);
  static final md = hard(4);
  static final lg = hard(5);
}

/// The one decoration almost every surface uses.
BoxDecoration boldBox({
  Color fill = AppColors.surface,
  double radius = AppShape.rCard,
  double stroke = AppShape.stroke,
  List<BoxShadow>? shadow,
  Color outline = AppColors.ink,
}) =>
    BoxDecoration(
      color: fill,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: outline, width: stroke),
      boxShadow: shadow,
    );
```

`lib/app/theme/app_theme.dart` (outline — fill in every text style from section 2)

```dart
ThemeData buildLightTheme(Color accent) {
  const display = 'BricolageGrotesque';
  const body = 'Outfit';
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.paper,
    fontFamily: body,
    fontFamilyFallback: const ['HindSiliguri'],
    colorScheme: ColorScheme.light(
      primary: accent,
      onPrimary: AppColors.ink,
      secondary: AppColors.sun,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      outline: AppColors.ink,
      error: AppColors.danger,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontFamily: display, fontSize: 32, fontWeight: FontWeight.w800,
          height: 1.0, letterSpacing: -0.8, color: AppColors.ink),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink),
      labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink),
      // …the rest from section 2
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.paper,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppShape.rSheet)),
        side: BorderSide(color: AppColors.ink, width: AppShape.stroke),
      ),
    ),
  );
}
// buildDarkTheme(accent, {amoled}) swaps paper→#000000, surface→#141414, ink outlines→white.
```

`pubspec.yaml` fonts block

```yaml
flutter:
  fonts:
    - family: BricolageGrotesque
      fonts:
        - asset: assets/fonts/BricolageGrotesque-Variable.ttf
    - family: Outfit
      fonts:
        - asset: assets/fonts/Outfit-Variable.ttf
    - family: HindSiliguri
      fonts:
        - asset: assets/fonts/HindSiliguri-Regular.ttf
          weight: 400
        - asset: assets/fonts/HindSiliguri-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/HindSiliguri-Bold.ttf
          weight: 700
  assets:
    - assets/mascot/
    - assets/icon/
```

## 8. Core widgets to build in M0

| Widget | What it is | Variants |
| --- | --- | --- |
| `BoldCard` | `boldBox` container with optional press "push-in" | fill color, shadow on/off, selected |
| `BoldButton` | Primary / secondary / danger / dark button | height 50–60, icon optional |
| `IconBox` | 46 × 46 outlined icon button with tooltip | white / sun |
| `BoldChip` | Collection chip | default (colored) / selected (ink fill, white text) |
| `BoldSearchField` | Search bar with clear button | idle / focused (shadow) |
| `BoldSwitch` | 58 × 34 switch | on (mint) / off (sand) |
| `SegmentedPicker` | 3-option selector on sand track | selected = sun + border |
| `BoldSheet` | Bottom sheet with grabber and title | – |
| `LinkCard` | Grid card: tag row, picture/scene, title, domain, number | normal / selected / loading / failed |
| `LinkTile` | List row: thumb, title, "domain · collection", ⋮ | normal / search highlight |
| `MainNavBar` | 3 tabs: Links, Collections, Settings | active pill sun |
| `Mascot` | SVG by mood | happy, surprised, sad, confused, sleepy, cheer |
| `SceneArt` | CustomPainter for cards without an image | seeded by URL |
