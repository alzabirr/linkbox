# Linkbox – Screens

30 screens. Each one has a mockup image `design/screens/NN-name.png` and its HTML
`design/html/NN-name.html` (exact sizes). Styles come from `docs/THEME.md`.
"M" = the milestone in `docs/BUILD_SPEC.md` section 10 that builds it.

## Navigation map

- Bottom bar, 3 tabs: **Links** (01) · **Collections** (12) · **Settings** (13)
- Pushed pages: 08 Edit, 14 Data, 19 Collection detail, 24 About, 25 Theme picker, 28 Restore
- Bottom sheets: 03 Sort, 04 Quick look, 06 Add link, 09 Move, 20 New collection, 21 Link menu, 27 Collection options
- Dialog: 11 Delete
- Share overlay (separate transparent activity, `share_main.dart`): 07 Duplicate, 22 Saved
- First launch: 16 → 17 → 18 → 05

## Summary

| No. | Screen | Type | Route / opens from | M |
| --- | --- | --- | --- | --- |
| 01 | Home · grid | Tab page | `/links` | M1 |
| 02 | Home · list + clipboard prompt | Tab page state | `/links` (view = list) | M1, M2 |
| 03 | Search + sort sheet | Page + sheet | Search bar on 01 | M3 |
| 04 | Quick look | Sheet | Tap a link (tap action = Quick look) | M3 |
| 05 | First launch / empty | Tab page state | 01 with 0 links | M6 |
| 06 | Add link | Sheet | "Add link" FAB | M1 |
| 07 | Save from share · duplicate | Overlay | Share sheet, URL already saved | M2 |
| 08 | Edit link | Page | `/link/:id/edit` from 04 / 21 | M3 |
| 09 | Move to collection | Sheet | 04, 10, 21, 22 | M4 |
| 10 | Multi-select | Tab page state | Long-press a link | M4 |
| 11 | Delete confirmation | Dialog | Delete in 04, 10, 21 | M4 |
| 12 | Collections | Tab page | `/collections` | M4 |
| 13 | Settings | Tab page | `/settings` | M6 |
| 14 | Import, export & backup | Page | `/settings/data` | M5 |
| 15 | Home · AMOLED dark | Theme variant of 01 | Settings dark + pure black | M6 |
| 16 | Onboarding · welcome | Page | First launch | M6 |
| 17 | Onboarding · save from any app | Page | 16 → Next | M6 |
| 18 | Onboarding · private by design | Page | 17 → Next | M6 |
| 19 | Collection detail | Page | `/collections/:id` | M4 |
| 20 | New collection | Sheet | 12 "New", 06/09 "New" | M4 |
| 21 | Link options menu | Sheet | ⋮ on a list row | M3 |
| 22 | Saved from share | Overlay | Share sheet, new URL | M2 |
| 23 | No results + card states | Page state | 03 with 0 matches; card loading / failed | M1, M3 |
| 24 | About | Page | `/settings/about` | M6 |
| 25 | Theme color picker | Page | `/settings/theme` | M6 |
| 26 | Home-screen widgets | Android widgets | Launcher | M7 |
| 27 | Collection options | Sheet | ⋮ on 19 | M4 |
| 28 | Restore from backup | Page | 14 "Restore" | M5 |
| 29 | Deleted · undo | Snackbar state | After any delete | M4 |
| 30 | Quick look · dark | Theme variant of 04 | Dark mode | M6 |

---

## Screen details

### 01 · Home · grid
- **Header:** "Hey there!" (labelSmall, muted) + "Your links" (headlineLarge). Right: Sort icon box (white), view-toggle icon box (sun, shadowSm).
- **Search bar** (tap → 03).
- **Collection chips**, horizontal scroll: "All" selected = ink fill + white text; others filled with their collection color.
- **Grid** of `LinkCard`, 2 columns, gap 14: tag row (collection UPPERCASE + kind badge "Video/Article/Post"), picture area 92 high, title (2 lines), domain + "NO.001".
- **FAB** "Add link" bottom-right above nav, accent fill, shadowMd → 06.
- **Nav bar**, Links active.
- **States:** 0 links → 05. Loading previews → card loading state (23). Tap → tap action setting. Long-press → 10.

### 02 · Home · list + clipboard prompt
- Same header and chips; list of `LinkTile` (thumb 52, title 1 line, "domain · collection", ⋮ → 21).
- **Clipboard prompt** (sun card, shadowMd, mascot happy): "Save the link you copied?", URL preview, buttons Not now (white) / Save link (ink). Auto-hide 8 s.

### 03 · Search + sort sheet
- Back icon box, search field (focused, shadowSm) with pink clear button.
- Filter pills: sort ("Newest first" ▾, sun) and collection ("All collections" ▾).
- Result count line "3 links match “flutter”" (titleLarge), list rows with the match highlighted (sun background, 800 weight).
- **Sort sheet:** Newest first / Oldest first / Name A–Z / Name Z–A; selected = sun row + check + shadowSm.
- 0 results → 23.

### 04 · Quick look
- Sheet over dimmed Home. Big collectible card (frame = card color, shadowLg): tag row "DESIGN · NO.001", picture 168 high with play badge, title (titleLarge), description, "domain · Saved 2 days ago".
- Action row: **Open** (accent, wider) · Copy · Share. Second row: Edit (→ 08) · Move (→ 09) · Delete (red text → 11).

### 05 · First launch / empty
- Big happy mascot with arms, two tilted cards behind it.
- "Save it now. Find it later." (displayLarge), body text.
- Buttons: Import (white → 14) + **Add first link** (accent → 06). Small line "No account · No ads · Works offline".

### 06 · Add link
- Tall sheet: title "Add a link", close icon box.
- **Link field** (shadowSm) with sun "Paste" button.
- **Preview** box (sky fill): thumb, title, 2-line description, domain. Below: green check "Found the title, summary and image". Loading: spinner + "Getting the preview…". Failed: "Couldn’t get a preview…" (still savable).
- **Collection chips** (wrap): None, collections, dashed "+ New" (→ 20). Selected = ink.
- **Save link** button (accent, full width). Invalid URL → field error text, Save disabled.

### 07 · Save from share · duplicate
- Transparent overlay on top of the other app. Bottom card (radius 28, shadowLg): surprised mascot, "You already saved this one", "Saved on 12 Oct in **Design**", mini link row.
- Buttons: Save a copy (white) · **Open saved link** (accent → opens main app at 04).

### 08 · Edit link
- Header: back, "Edit link", **Save** (accent).
- Picture box with "Change image" (image picker) + "Fetch again" (sun).
- Title field with counter "45 / 120", Summary textarea, Link field (read-only, sand), Collection row (→ 09).

### 09 · Move to collection
- Sheet title "Move 3 links to…", helper "Pick a collection. Links can only be in one."
- Rows: icon box in collection color, name, "24 links"; selected = sun + shadowSm + black check circle.
- Dashed "+ New collection" (→ 20); button **Move to Design**.

### 10 · Multi-select
- Top bar becomes ink pill: ✕, "3 selected", "Select all".
- Selected cards: border 3.5 + shadowLg + black check badge; unselected: 70 % opacity + empty badge.
- Bottom toolbar (white card, shadowMd): **Move** (sky) · **Share** (mint) · **Delete** (danger).

### 11 · Delete confirmation
- Centered dialog (shadow 6): sad mascot, "Delete 3 links?", body "They'll be removed from this phone. This can't be undone unless you have a backup."
- **Delete 3 links** (danger, shadowMd) · Keep them (white). After delete → 29.

### 12 · Collections
- Header: "5 collections · 89 links" + "Collections"; **New** button (accent).
- Wide ink tile "89 All links" with two tilted mini cards.
- 2-column tiles (168 high, collection color, shadowMd): icon box, big count, name, "Updated today". Tap → 19.
- Dashed "Create a collection" → 20. Nav: Collections active.

### 13 · Settings
- Section "When I tap a link": segmented Quick look / Open site / Copy link.
- Section "Look & feel": segmented Light / Dark / System; switch "Pure black dark mode"; switch "Match my wallpaper"; accent swatches row (selected = ring) — "more colors" → 25.
- Row card (sky, shadowMd) "Import, export & backup · Last backup: 2 days ago" → 14. About → 24.

### 14 · Import, export & backup
- **Backup** card (mint, shadowMd, cheer mascot): text with **Download/Linkbox**, "Last backup: …", buttons **Back up now** (ink) · Restore (→ 28).
- **Import from a browser** card: help text, **Choose HTML file** (accent).
- **Export** card: Export HTML · Export JSON.
- Result toast (ink): "Imported 142 links. Skipped 6 you already had."

### 15 · Home · AMOLED dark
- Same as 01 with: background #000, outlines/borders white, chips outlined in their color with colored text, "All" white fill. Cards keep their fills; card text stays ink.

### 16–18 · Onboarding
- Colored top area (16 sun, 17 pink, 18 mint) with illustration; cream bottom panel (top radius 32): step dots (active = long ink pill), headline (displayLarge), body, primary button.
- 16: "Every link in one happy place" — Skip (→ 05), **Let's go**.
- 17: share-menu illustration with Linkbox icon highlighted; "Save from any app in one tap" — Back, Skip, **Next**.
- 18: phone + lock + sleepy mascot; "Your links stay on your phone"; chips No account / No ads / No tracking / Works offline; **Start saving** → sets `onboarding_done` → 05.

### 19 · Collection detail
- Header block in the collection color (bottom radius 32): back, ⋮ (→ 27), "Collection", name (48 / 800), "24 links · updated today", big decorative icon.
- Sort pill + search icon box; list of `LinkTile`; FAB "Add to Design" (→ 06 with this collection preselected).

### 20 · New collection
- Sheet: live preview tile (selected color + icon), Name field with counter "6 / 30", Color swatches (6), Icon grid (6: plane, star, code, book, home, music), **Create collection**. Same sheet in "Rename" mode from 27.

### 21 · Link options menu
- Sheet header: sun mini card with the link. Rows with colored icon boxes: Open in browser · Copy link · Share · Edit · Move to collection · Select more · **Delete** (red).

### 22 · Saved from share
- Overlay card over the other app with confetti: cheer mascot, "Saved!" (titleLarge), title, "youtube.com · added to Recipes".
- Change collection (→ 09) · **Done**. "Closes by itself in a few seconds" (≈ 4 s).

### 23 · No results + card states
- Search with 0 results: confused mascot, "No links match “biryani pdf”", help line, **Clear search**.
- **Card state – Preview failed:** dashed sand picture area "No preview", URL as title, **Try again** (sun).
- **Card state – Loading:** striped picture area, two grey bars, "Getting the preview…".

### 24 · About
- Grape card (shadowLg) with winking mascot, app name, "Version 1.0.0", "Made by [YOUR NAME]".
- Rows: Privacy policy · Send feedback · Rate on Google Play · Open-source licenses (`showLicensePage`) · Replay the intro (→ 16).

### 25 · Theme color picker
- Live preview card (chips, button, switch in the picked color).
- 12 swatches in a 4-column grid (72 high, radius 20; selected = 3.5 border + shadow + check).
- Hex input + color square. **Use this color** (ink).

### 26 · Home-screen widgets (Android)
- **Quick bar** (4×1): mascot, "Search links" pill (opens 03), round accent "+" (opens 06 with clipboard pasted).
- **Recently saved** (4×2): 4 mini link tiles → open 04.
- **Read later** (2×2, mint): icon, big count "31", label.

### 27 · Collection options
- Sheet header: icon box + name + count. Rows: Rename · Color & icon (→ 20) · Pin to top · Share all links · **Delete collection** ("Links move to “No collection”, nothing is lost").

### 28 · Restore from backup
- Text "Pick a backup from Download/Linkbox." Backup rows (date, "142 links · 5 collections · 48 KB"); selected = sun + shadowSm.
- "How should we restore?": radio cards **Add to my links** (default, mint) / Replace everything ("Your current 89 links are removed first.").
- **Restore 142 links**.

### 29 · Deleted · undo
- Home after delete; ink snackbar above nav (accent offset shadow): red trash box, "Deleted 3 links", **Undo** (sun), progress line counting down 5 s.

### 30 · Quick look · dark
- Dark version of 04: sheet #141414 with white top border, card keeps its fill with white outline, white-outlined secondary buttons, "Delete" in #FF8A80.
