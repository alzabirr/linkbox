# Releasing Linkbox

Do these in order. Steps marked 🧑 need you; nothing here is automatic.

## 1. Before the first upload (can't be changed later)

### 1a. App ID → `com.alzabir.linkbox` 🧑
Ask Claude Code: "Change the package name to com.alzabir.linkbox". It must
update:
- `android/app/build.gradle.kts`: `namespace` and `applicationId`
- Move `android/app/src/main/kotlin/com/example/linkbox/` to
  `.../com/alzabir/linkbox/` and change the `package` line in both `.kt` files
- `AppInfo.packageName` in `lib/features/settings/about_page.dart`

### 1b. Your details 🧑
In `lib/features/settings/about_page.dart` (`AppInfo`): `author`,
`feedbackEmail`. Put the same name, email and today's date in
`docs/PRIVACY_POLICY.md`.

### 1c. Upload key 🧑
Run this once, choose a strong password, and **back up the file and the
password** (if you lose them you can't update the app):

```
keytool -genkey -v -keystore ~/linkbox-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Then create `android/key.properties` (it is git-ignored):

```
storeFile=/Users/<you>/linkbox-upload.jks
storePassword=<your password>
keyAlias=upload
keyPassword=<your password>
```

## 2. Build

```
flutter test
flutter build appbundle --release
```

Upload `build/app/outputs/bundle/release/app-release.aab`.
(The file is ~68 MB because it holds every phone type; each phone downloads
only its own part, about 10–12 MB.)

For every later update, raise `version:` in `pubspec.yaml`
(e.g. `1.0.1+2` — the number after `+` must always go up).

## 3. Manual checks on a real phone (BUILD_SPEC §12) 🧑
- [ ] Share from YouTube, Chrome, Reddit, Instagram, X, Facebook
- [ ] Airplane mode: saving works; previews fill in after reconnecting
- [ ] Light, dark, pure black, and Bangla (phone language) on every screen
- [ ] Text size at the largest setting, and TalkBack on Home, Add link, Settings
- [ ] Back up → uninstall → reinstall → Restore (Choose a backup file)

Already checked by Claude Code: release share overlay opens in ~0.3 s;
2,000 links search in under 300 ms (test); all automated tests pass.

## 4. Play Console 🧑
1. Create a developer account at https://play.google.com/console (one-time fee).
2. **Create app** → name "Linkbox", app, free.
3. **App content**:
   - Privacy policy: publish `docs/PRIVACY_POLICY.md` somewhere public
     (e.g. GitHub Pages or a Google Doc shared publicly) and paste the URL.
   - Ads: **No ads**.
   - Data safety: **No data collected, no data shared.** (Fetching a web page
     the user chose to save is not data collection.)
   - Content rating questionnaire: Utility, no objectionable content.
   - Target audience: 13+ (not designed for children).
4. **Store listing**: texts from `docs/STORE_LISTING.md`, icon, feature
   graphic, screenshots.
5. **Testing → Internal testing**: upload the `.aab`, add your email as a
   tester, install from the link and try it.
6. **Closed testing**: Google may require new personal accounts to run a
   closed test (recently: at least 12 testers for 14 days) before
   production. The Play Console shows the current rule for your account.
7. **Production**: promote the tested release, submit for review.

## 5. Version 1.1 ideas
- Home-screen widgets (screen 26)
- Card delete animation (shrink + fade)
- Android 9 and older: ask for storage permission for backups
