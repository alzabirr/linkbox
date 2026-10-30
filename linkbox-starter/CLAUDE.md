# Linkbox

Offline-first Android app, built with Flutter, for saving links from any app
and finding them again. No account, no ads, no cloud. "Linkbox" is a placeholder name.

## Where things are

| What | File |
| --- | --- |
| Features, data model, architecture, build plan (M0–M7) | `docs/BUILD_SPEC.md` |
| Every screen: purpose, parts, states, navigation | `docs/SCREENS.md` |
| Colors, fonts, radius, shadows, motion + Flutter theme code | `docs/THEME.md` |
| Screen mockups as images (source of truth for the look) | `design/screens/NN-name.png` |
| Screen mockups as HTML (exact px, hex, font sizes) | `design/html/NN-name.html` |
| Fonts, mascot SVGs, app icon | `assets/` |

Screen numbers (01–30) are the same in SCREENS.md, the PNG names and the HTML names.
If a PNG and its HTML disagree, follow the PNG.

## Rules

- Work on ONE milestone at a time. Stop when its "Done when" line is met.
- Match the mockups exactly: colors, spacing, radius, borders, shadows, fonts.
- Take every color, font, radius and shadow from `AppTheme` / `AppTokens`. Never hard-code them in widgets.
- Every surface has a 2.5 px ink (#141414) border; important tappables get a hard offset shadow with no blur.
- All UI text goes in `lib/l10n/app_en.arb` (and `app_bn.arb`), never as string literals in widgets.
- Screens never import the database or `http`; they only watch Riverpod providers.
- Every network call has a 10 s timeout and never blocks saving a link.
- Store times in UTC; show them in local time.
- Touch targets are at least 44 × 44; icon-only buttons need a Semantics label or tooltip.
- After each change run `flutter analyze` and fix every warning. Run tests that exist.
- Run the app and check the screen you changed before saying it is done.
- Ask me before adding a package that is not listed in BUILD_SPEC.md section 6.
- Commit to git when a milestone works, with a message like `M1: save and show links`.
- Explain what you did in simple words. I am not an expert developer.

## Commands

```
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # drift + riverpod code generation
flutter analyze
flutter test
flutter run                                                # on the connected phone
flutter build appbundle --release                          # release .aab
```
