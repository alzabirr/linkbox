# Design files

- `html/` — every screen as HTML, numbered 01–30 like `docs/SCREENS.md`.
  Open one in a text editor to read exact sizes (px), colors (hex) and font sizes.
  `99-design-tokens-board.html` is the token / handoff board.
  These files need the design canvas to render; they are a reference for values, not a web page.
- `screens/` — put the PNG export of each screen here, same names as the HTML
  (`01-home-grid.png` …). **The PNGs are the source of truth for how a screen looks.**

## How to export the PNGs

1. Open the design canvas: https://claude.ai/artifact/RGDUVeYd8tXM9hTKojgmNB
2. Select a screen (artboard) → Share / Export → PNG.
3. Save it into `design/screens/` with the matching number and name.

Note: screens 01, 02, 12, 15, 16, 17, 18 and 29 were edited on the canvas after these HTML
files were saved, so for those the PNG export is the up-to-date version.
