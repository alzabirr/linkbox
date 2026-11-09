# Linkly – Build Spec

Offline-first Android app, built in Flutter, for saving links from any app and finding them again.
No account, no ads, no cloud. The app is called "Linkly".

Related files:
- Screens: `docs/SCREENS.md` (all 30 screens, numbered)
- Design tokens + theme code: `docs/THEME.md`
- Mockups: `design/screens/*.png` (look) and `design/html/*.html` (exact values)

---

## 1. Overview

**The problem.** People save links in chats, notes and browser tabs, then lose them.
Linkly gives every link a title, summary and picture, and keeps them in collections.

**Who it's for.** Anyone who saves videos, posts, recipes, articles or design ideas from YouTube,
Reddit, Chrome, Instagram and similar apps.

**Reference.** The feature set follows the Play Store app Savr (GPL v3). We re-implement the features
with our own code, name and design. If any Savr code is copied, Linkly must also be GPL v3.

### Goals
- Save a link from any app in two taps, using the share sheet
- Show each link as a visual card with title, summary and image
- Organize links into collections; search and sort them
- Keep all data on the device, with import, export and local backup
- Work fully offline; the internet is only used to fetch link previews

### Not in version 1
- Accounts, cloud sync or a web version
- iOS (possible later; the share extension needs separate native work)
- Tags, reminders, reading-mode article text

---

## 2. Features

P1 = needed to launch · P2 = finishes the experience · P3 = can come in an update.

| Area | Feature | Priority | Screens |
| --- | --- | --- | --- |
| Saving | Receive links from the Android share sheet | P1 | 07, 22 |
| Saving | Add a link by hand, with a Paste button | P1 | 06 |
| Saving | Auto-fetch title, summary and image (Open Graph) | P1 | 06, 23 |
| Saving | Duplicate detection (normalized URL) | P1 | 07 |
| Saving | Clipboard prompt: offer to save a copied link | P2 | 02 |
| Organizing | Collections: create, rename, color, icon, pin, delete | P1 | 12, 19, 20, 27 |
| Organizing | Move one or many links to a collection | P1 | 09 |
| Organizing | Multi-select with batch move, share, delete | P1 | 10, 11 |
| Organizing | Undo after delete | P2 | 29 |
| Finding | Search by title or URL, with match highlight | P1 | 03, 23 |
| Finding | Sort: newest, oldest, A–Z, Z–A | P1 | 03 |
| Finding | Grid (cards) and list views | P1 | 01, 02 |
| Finding | Filter by collection chips on Home | P1 | 01 |
| Viewing | Quick look with Open, Copy, Share, Edit, Move, Delete | P1 | 04, 21 |
| Viewing | Edit title, summary, image; fetch preview again | P1 | 08 |
| Settings | Tap action: Quick look, Open site or Copy link | P2 | 13 |
| Settings | Light, dark, system theme + pure-black AMOLED mode | P2 | 13, 15, 30 |
| Settings | Accent color picker + Android dynamic color | P2 | 13, 25 |
| Data | Import browser bookmarks (Netscape HTML file) | P1 | 14 |
| Data | Export to HTML and JSON | P1 | 14 |
| Data | Local backup to Download/Linkly + restore (add or replace) | P1 | 14, 28 |
| Onboarding | 3-step intro + empty state | P2 | 05, 16–18 |
| Extras | About page, licenses, feedback, rate | P2 | 24 |
| Extras | Home-screen widgets (quick save, recent, collection count) | P3 | 26 |

---

## 3. Screens

See `docs/SCREENS.md`. Navigation: bottom bar with 3 tabs (Links, Collections, Settings);
everything else is pushed on top or opened as a bottom sheet.

---

## 4. Key user flows

### Save from another app (share sheet)
1. In YouTube, Chrome or Reddit, the user taps **Share** and picks **Linkly**.
2. Linkly opens as a transparent overlay activity, not the full app.
3. Extract the first URL from the shared text and normalize it.
4. URL already saved → screen 07 "You already saved this one" → Open saved link / Save a copy.
5. New → save at once with the URL as a temporary title, show screen 22 "Saved!".
6. Fetch the preview in the background; update title, summary and image.
7. The overlay closes after ~4 s, or on Done. "Change collection" opens 09.

Must take under 2 seconds.

### Add a link by hand
1. Tap **Add link** on Home → 06.
2. Paste or type the URL; validate it starts with http:// or https://.
3. After a 500 ms pause in typing, fetch and show the preview.
4. Pick a collection (optional), tap **Save link**.
5. If the preview fails, save anyway; the card shows the "Preview failed" state (23).

### Clipboard prompt
1. When the app comes to the foreground, read the clipboard once.
2. If it holds a URL that isn't saved and wasn't offered before, show the prompt (02).
3. **Save link** saves it like the share flow; **Not now** remembers the URL so it isn't offered again.
4. The prompt hides after 8 s.

### Organize several links
1. Long-press a card → multi-select (10).
2. Tap more cards, or **Select all**.
3. **Move** → 09 · **Share** → sends URLs as a list · **Delete** → 11.
4. After delete show the Undo bar (29) for 5 s; purge rows only when it expires.

### Back up, restore, import
1. **Back up now** writes a JSON file to Download/Linkly (14).
2. **Restore** lists backups by date (28); default "Add to my links" skips duplicates.
3. **Choose HTML file** imports a browser export; folders become collections.
4. Show "Imported {n} links. Skipped {m} you already had."

---

## 5. Design system

See `docs/THEME.md`.

---

## 6. Tech stack and architecture

Flutter (stable, Dart 3) · Riverpod for state · Drift (SQLite) for storage.

### Layers (each layer only calls the one below)

```
UI            Screens, sheets, LinkCard + core widgets, AppTheme, go_router
   ↓
State         Riverpod providers: links, search, selection, settings
   ↓
Repositories  LinkRepository, CollectionRepository, SettingsRepository
   ↓
Services      Metadata fetch+parse · Share intent receiver · Clipboard watcher ·
              Backup/import/export · Home widget updater
   ↓
Platform      Drift SQLite · shared_preferences · Download/Linkly files ·
              Internet (previews only) · Android share + widgets
```

### Packages

| Need | Package | Notes |
| --- | --- | --- |
| State | flutter_riverpod (+ riverpod_generator) | One provider per feature area |
| Database | drift + drift_flutter | Typed SQLite; reactive streams |
| Settings | shared_preferences | Theme, accent, tap action, view mode |
| Navigation | go_router | 3 tabs with ShellRoute |
| Receive shared links | receive_sharing_intent | Alternative: share_handler |
| Link previews | http + html | Parse Open Graph / Twitter tags yourself |
| Images | cached_network_image | Disk cache |
| Open, share | url_launcher, share_plus | |
| Files | file_picker, path_provider | Import file; temp export files |
| Download folder | media_store_plus | Android 10+ scoped storage |
| Dynamic color | dynamic_color | "Match my wallpaper" |
| Mascot | flutter_svg | |
| Home widgets | home_widget | P3 |
| Languages | flutter_localizations + intl | English + Bangla |
| Pick custom image | image_picker | Edit link (08) |

Check each package on pub.dev for its latest version before adding it.

### Rules
- Screens never import the database or `http`; they only watch providers.
- Every network call has a 10 s timeout and never blocks saving.
- Store times in UTC; show local time.
- Clipboard: Flutter's `Clipboard` API, only while the app is in the foreground.

---

## 7. Data model

### Table `links`

| Column | Type | Notes |
| --- | --- | --- |
| id | int PK | auto-increment |
| url | text, not null | exactly as shared |
| normalized_url | text, unique index | duplicate check (section 8) |
| title | text? | editable, max 120 chars |
| description | text? | editable |
| image_url | text? | from the page |
| custom_image_path | text? | user's own image; overrides image_url |
| site_name | text? | e.g. "YouTube" |
| domain | text, not null | e.g. youtube.com |
| kind | text | video / article / post / other |
| collection_id | int? | FK → collections.id, set null on delete |
| fetch_status | text | pending / ok / failed |
| created_at | datetime UTC | "Newest first" |
| updated_at | datetime UTC | |
| deleted_at | datetime? | soft delete for Undo |

Indexes: `normalized_url` (unique), `collection_id`, `created_at`, `title`.

### Table `collections`

| Column | Type | Notes |
| --- | --- | --- |
| id | int PK | |
| name | text, not null | max 30, unique (case-insensitive) |
| color | text | hex from the palette |
| icon | text | star, code, book, plane, home, music |
| pinned | bool | pinned first |
| sort_order | int | manual order |
| created_at | datetime UTC | |

### Settings (shared_preferences)

| Key | Values | Default |
| --- | --- | --- |
| theme_mode | light / dark / system | system |
| amoled | bool | false |
| dynamic_color | bool | false |
| accent | hex | #FF8A3D |
| tap_action | quickLook / open / copy | quickLook |
| view_mode | grid / list | grid |
| sort | newest / oldest / az / za | newest |
| onboarding_done | bool | false |
| last_clipboard_url | text | "" |
| last_backup_at | datetime | – |

### Backup file (JSON)

```json
{
  "app": "linkbox",
  "version": 1,
  "exportedAt": "2026-10-28T15:14:00Z",
  "collections": [{"id": 2, "name": "Design", "color": "#FF9FC4", "icon": "star", "pinned": false}],
  "links": [{"url": "https://…", "title": "…", "description": "…", "imageUrl": "…", "collectionId": 2, "createdAt": "…"}]
}
```

Keep `version` so later app versions can migrate old backups.

---

## 8. Implementation notes

Build and test each of these on a real Android phone, not only the emulator.

### Share intent
- `AndroidManifest.xml`: intent filter for `ACTION_SEND`, mime `text/plain`.
- Separate transparent activity theme for the share entry (`share_main.dart`), so 07/22 show over the other app.
- Extract the first match of `https?://\S+` from shared text.
- Save first (`fetch_status = pending`), show "Saved!", then fetch the preview.

### Link preview
1. GET with 10 s timeout, normal mobile User-Agent, follow redirects.
2. Read at most ~512 KB of HTML.
3. Title: `og:title` → `twitter:title` → `<title>`.
4. Summary: `og:description` → `twitter:description` → `meta name=description`.
5. Image: `og:image` → `twitter:image` → largest `apple-touch-icon`; make relative URLs absolute.
6. Kind: YouTube/Vimeo or `og:type=video` → video; Reddit/X → post; else article.
7. On error/timeout: `fetch_status = failed` → "Try again" card (23).
8. YouTube: `https://www.youtube.com/oembed?url=…&format=json` gives a reliable title + thumbnail.

Queue fetches, max 3 at once.

### Duplicate check (normalize URL)
- Lowercase scheme + host; drop `www.`
- Remove `#fragment` and trailing `/`
- Remove `utm_*`, `fbclid`, `gclid`, `si`, `igshid`, `ref`
- `youtu.be/ID` and `m.youtube.com` → `youtube.com/watch?v=ID`

### Clipboard prompt
- Check in `didChangeAppLifecycleState` on resume (Android 10+ only allows reading in foreground).
- Android 12+ shows a system "pasted from clipboard" toast — read at most once per resume.
- Save the last offered URL in `last_clipboard_url`.

### Import browser bookmarks
- Netscape format: `<DT><A HREF="…" ADD_DATE="…">Title</A>` inside `<DL>` folders.
- Parse with `html`; each `<H3>` folder → collection; `ADD_DATE` (Unix s) → `created_at`.
- Skip duplicates, insert in one transaction, then queue preview fetches.

### Export and backup
- Export HTML = Netscape format. Export JSON / Back up now = backup format above.
- Backups → `Download/Linkly/linkly-backup-YYYY-MM-DD-HHmm.json` via MediaStore (no storage permission).
- Restore: "Add to my links" (default, skips duplicates) or "Replace everything" (wipe + insert in one transaction).

### Undo delete
Set `deleted_at`; hide those rows in every query. Undo clears it. After 5 s, or on next start, delete rows with `deleted_at` set.

### Home-screen widgets (P3)
`home_widget` + native Android layouts. After each save/delete, write the latest 4 links and the
Read later count, then `HomeWidget.updateWidget`. Widget taps open deep links `linkbox://link/<id>`.

---

## 9. Project structure

```
linkbox/
├─ CLAUDE.md
├─ docs/                      # BUILD_SPEC.md, SCREENS.md, THEME.md
├─ design/                    # screens/*.png, html/*.html
├─ android/                   # share activity, widget layouts, manifest
├─ assets/
│  ├─ fonts/                  # Bricolage Grotesque, Outfit, Hind Siliguri
│  ├─ mascot/                 # happy, surprised, sad, confused, sleepy, cheer .svg
│  └─ icon/                   # app icon
├─ lib/
│  ├─ main.dart               # app entry
│  ├─ share_main.dart         # share overlay entry
│  ├─ app/
│  │  ├─ router.dart
│  │  └─ theme/               # tokens.dart, typography.dart, app_theme.dart
│  ├─ core/
│  │  ├─ db/                  # drift tables, database.dart, migrations
│  │  ├─ services/            # metadata, clipboard, backup, import_export, widget
│  │  ├─ utils/               # url_normalizer.dart, debouncer.dart
│  │  └─ widgets/             # BoldCard, BoldButton, BoldChip, BoldSheet, Mascot, SceneArt…
│  ├─ features/
│  │  ├─ links/               # home, quick look, add, edit, search, multi-select
│  │  ├─ collections/         # list, detail, new, options, move sheet
│  │  ├─ settings/            # settings, theme picker, about
│  │  ├─ data/                # backup, restore, import, export
│  │  ├─ onboarding/
│  │  └─ share/               # overlay: saved + duplicate
│  └─ l10n/                   # app_en.arb, app_bn.arb
└─ test/
```

---

## 10. Build plan

One milestone at a time. Each ends with something you can run on the phone.

### M0 · Setup
- [ ] Create the Flutter project inside this folder (keep CLAUDE.md, docs/, design/, assets/)
- [ ] Download the fonts listed in `assets/fonts/README.md` into `assets/fonts/`
- [ ] Add packages from section 6; set up Riverpod, go_router, Drift code generation
- [ ] Register fonts and assets in `pubspec.yaml` (see THEME.md section 7)
- [ ] Build `AppTheme` with every token from THEME.md (light + dark + AMOLED)
- [ ] Build the core widgets from THEME.md section 8
- [ ] App icon from `assets/icon/app_icon.svg` (flutter_launcher_icons)
- **Done when:** an app with the 3-tab bottom bar runs in light and dark mode, and a test page shows every core widget matching the mockups.

### M1 · Save and show links
- [ ] Drift tables `links`, `collections`
- [ ] URL normalizer + unit tests
- [ ] Metadata service with fallbacks, timeout, queue
- [ ] Add link sheet (06) with live preview
- [ ] Home grid (01) and list (02) with `SceneArt` for cards without images
- [ ] Card states: loading, preview failed + Try again (23)
- **Done when:** you can paste 10 links and see them as cards after restarting the app.

### M2 · Share sheet and clipboard
- [ ] Intent filter + transparent share activity
- [ ] Saved overlay (22) and duplicate overlay (07)
- [ ] Clipboard prompt (02)
- **Done when:** sharing from YouTube and Chrome saves a link in under 2 seconds.

### M3 · View, edit, find
- [ ] Quick look (04) and link menu (21)
- [ ] Edit link (08) with custom image and Fetch again
- [ ] Search with highlight + empty result (03, 23)
- [ ] Sort sheet and grid/list toggle, saved in settings
- **Done when:** every action in Quick look works.

### M4 · Collections and multi-select
- [ ] Collections (12), detail (19), new (20), options (27)
- [ ] Move sheet (09) for one or many links
- [ ] Multi-select (10), delete dialog (11), soft delete + Undo (29)
- **Done when:** you can sort 30 links into 4 collections and delete 3 with Undo.

### M5 · Data
- [ ] Import browser HTML; export HTML and JSON (14)
- [ ] Backup to Download/Linkly; restore Add / Replace (28)
- **Done when:** a Chrome export imports correctly, and backup → uninstall → reinstall → restore brings everything back.

### M6 · Settings, onboarding, polish
- [ ] Settings (13), theme picker (25), dynamic color, AMOLED (15, 30)
- [ ] Onboarding (16–18), empty state (05), About (24)
- [ ] All motion from THEME.md; Bangla `.arb`; accessibility pass (section 11)
- **Done when:** a new user can install, follow the intro and save a link without help.

### M7 · Release
- [ ] Home-screen widgets (26) if there's time; otherwise version 1.1
- [ ] Tests and release checklist (section 12)
- [ ] Play Store listing, screenshots, privacy policy
- **Done when:** the app is live on the Play Store.

---

## 11. Copy, language, accessibility

Friendly and short; buttons start with a verb. Always "link" (never bookmark/URL) and
"collection" (never folder). Every string lives in `.arb` files.

| Where | Text |
| --- | --- |
| Empty state | Save it now. Find it later. / Share a link from any app, or paste one here. Your links stay on this phone. |
| Search placeholder | Search by name or link |
| No results | No links match “{query}”. Try a shorter word, or search part of the link itself. |
| Clipboard prompt | Save the link you copied? [Not now] [Save link] |
| Saved overlay | Saved! / {domain} · added to {collection} [Change collection] [Done] |
| Duplicate | You already saved this one / Saved on {date} in {collection} [Save a copy] [Open saved link] |
| Preview failed | Couldn’t get a preview. Your link is saved, and you can add a title yourself. |
| Offline | You’re offline. We saved the link and will get the preview when you’re back online. |
| Invalid link | That doesn’t look like a link. It should start with http:// or https:// |
| Delete dialog | Delete {n} links? / They’ll be removed from this phone. This can’t be undone unless you have a backup. [Delete {n} links] [Keep them] |
| Undo bar | Deleted {n} links [Undo] |
| Copied | Link copied |
| Import done | Imported {n} links. Skipped {m} you already had. |
| Import error | We couldn’t read that file. Pick the .html file your browser exported. |
| Backup failed | Backup didn’t finish. Free up some space on your phone and try again. |
| Delete collection | Links move to “No collection”, nothing is lost. |

### Bangla
- Display/body fonts have no Bengali glyphs → `fontFamilyFallback: ['HindSiliguri']`.
- Bangla runs ~20–30 % longer: buttons and chips grow or wrap, never clip.
- Line height 1.6 for Bangla body text.
- `intl` plurals for "{n} links"; `DateFormat` with the device locale.

### Accessibility
- Icon-only buttons: `Semantics` label or `tooltip`.
- Tap targets ≥ 44 × 44 (pad 38-high chips).
- Contrast ≥ 4.5:1 (ink on every palette color passes).
- Selection is never color-only: check mark or thicker border too.
- Announce "{n} selected" in multi-select.
- Text scale up to 1.3× without broken layouts.

---

## 12. Testing, release, open questions

### Unit and widget tests
- [ ] URL normalizer: tracking params, youtu.be, trailing slash, www, fragments
- [ ] Metadata parser: og tags, twitter tags, `<title>`, relative image URLs, broken HTML
- [ ] Netscape import: nested folders, missing titles, 1,000+ links
- [ ] Backup → restore round trip, both modes
- [ ] Repository: soft delete, undo, purge; deleting a collection keeps its links
- [ ] Widget tests: Home grid/list, Add link sheet, multi-select bar

### Manual checks
- [ ] Share from YouTube, Chrome, Reddit, Instagram, X, Facebook
- [ ] Airplane mode: saving works; previews fill in later
- [ ] Light, dark, AMOLED and Bangla on every screen
- [ ] Text 1.3× and TalkBack on Home, Add link, Settings
- [ ] 2,000 links: smooth scrolling; search under 300 ms

### Play Store
- [ ] App name, icon, package name (e.g. `com.yourname.linkbox`)
- [ ] Signed release `.aab`, R8 shrinking on
- [ ] Privacy policy: the app collects nothing; it only fetches link pages for previews
- [ ] Data safety form matching the policy
- [ ] Store screenshots from the mockups
- [ ] Internal testing → closed testing → production

### Open questions
- [ ] Final app name (check it's free on the Play Store)
- [ ] Open source or not? Any reused Savr code forces GPL v3
- [ ] Widgets in 1.0 or 1.1?
- [ ] Bangla in 1.0, or English first?
- [ ] iOS later?
