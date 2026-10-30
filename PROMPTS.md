# Prompts for Claude Code

Open Claude Code inside this folder. Go one milestone at a time (M0 → M7 in
`docs/BUILD_SPEC.md` section 10) and test each one on your phone before the next.

Before M0: export every screen from the design canvas as PNG into `design/screens/`,
named like the HTML files (`01-home-grid.png`, `02-home-list-clipboard.png`, …).

---

## First milestone (M0)

```
Read CLAUDE.md, docs/BUILD_SPEC.md, docs/SCREENS.md, docs/THEME.md
and look at the mockups in design/screens/.
Do milestone M0 only: create the Flutter project in this folder (keep the
existing files), download the fonts listed in assets/fonts/README.md,
add the packages, build AppTheme with all tokens from docs/THEME.md,
and build the core widgets. Run the app on my phone and fix any errors.
Stop when M0's "Done when" is met, and tell me how to test it.
```

## Every next milestone

```
M[0] works. Now do milestone M[1] from docs/BUILD_SPEC.md.
Use screens [06, 01, 02] — read them in docs/SCREENS.md, look at
design/screens/ and take exact values from design/html/.
Match them exactly. Run the app, fix errors, and stop when "Done when" is met.
```

Screens per milestone:

| Milestone | Screens |
| --- | --- |
| M1 | 01, 02, 06, 23 |
| M2 | 02 (clipboard prompt), 07, 22 |
| M3 | 03, 04, 08, 21, 23 |
| M4 | 09, 10, 11, 12, 19, 20, 27, 29 |
| M5 | 14, 28 |
| M6 | 05, 13, 15, 16, 17, 18, 24, 25, 30 |
| M7 | 26 + release |

## When something looks wrong

```
Screen [01] doesn't match the mockup. Here is a screenshot from my phone
[attach screenshot]. Compare it with design/screens/[01-home-grid.png]
and design/html/[01-home-grid.html], and fix every difference:
spacing, colors, font sizes, borders, shadows.
```

## When something breaks

```
When I [what you did], the app [what happened].
I expected [what should happen]. Here is the error: [paste error].
Find the cause, fix it, and explain the fix in simple words.
```

## Before release

```
All milestones are done. Go through section 12 of docs/BUILD_SPEC.md:
write the missing tests, run them, and build a signed release .aab.
Tell me step by step what I must do in the Play Console.
```
