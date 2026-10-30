// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Linkbox';

  @override
  String get navLinks => 'Links';

  @override
  String get navCollections => 'Collections';

  @override
  String get navSettings => 'Settings';

  @override
  String get homeTitle => 'Your links';

  @override
  String get collectionsTitle => 'Collections';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get searchHint => 'Search by name or link';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get sortTooltip => 'Sort';

  @override
  String get switchToList => 'Switch to list view';

  @override
  String get switchToGrid => 'Switch to grid view';

  @override
  String get addLink => 'Add link';

  @override
  String get chipAll => 'All';

  @override
  String get chipNone => 'None';

  @override
  String get chipNew => 'New';

  @override
  String get moreOptions => 'More options';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get kindVideo => 'Video';

  @override
  String get kindArticle => 'Article';

  @override
  String get kindPost => 'Post';

  @override
  String linkNumber(String number) {
    return 'NO.$number';
  }

  @override
  String get noPreview => 'No preview';

  @override
  String get tryAgain => 'Try again';

  @override
  String get gettingPreview => 'Getting the preview…';

  @override
  String get saveLink => 'Save link';

  @override
  String get notNow => 'Not now';

  @override
  String get paste => 'Paste';

  @override
  String get keepThem => 'Keep them';

  @override
  String deleteLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $count links',
      one: 'Delete 1 link',
    );
    return '$_temp0';
  }

  @override
  String comingSoon(String milestone) {
    return 'This part arrives in milestone $milestone.';
  }

  @override
  String get widgetGallery => 'Widget gallery';

  @override
  String get widgetGalleryHint => 'Every core widget, in light and dark';

  @override
  String get galleryTheme => 'Theme';

  @override
  String get galleryButtons => 'Buttons';

  @override
  String get galleryIconBoxes => 'Icon boxes';

  @override
  String get galleryChips => 'Chips';

  @override
  String get galleryInputs => 'Search, switch, picker';

  @override
  String get galleryCards => 'Link cards';

  @override
  String get galleryCardStates => 'Card states';

  @override
  String get galleryList => 'List rows';

  @override
  String get galleryMascot => 'Mascot';

  @override
  String get gallerySheet => 'Bottom sheet';

  @override
  String get galleryOpenSheet => 'Open a sheet';

  @override
  String get gallerySelecting => 'Multi-select look';

  @override
  String get sheetDemoTitle => 'Add a link';

  @override
  String get sheetDemoBody =>
      'Sheets slide up over a dimmed screen, with a grabber on top.';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get pureBlack => 'Pure black dark mode';

  @override
  String get pureBlackHint => 'Saves battery on AMOLED screens';

  @override
  String get accentColor => 'Accent color';

  @override
  String get tapActionLabel => 'When I tap a link';

  @override
  String get tapQuickLook => 'Quick look';

  @override
  String get tapOpen => 'Open site';

  @override
  String get tapCopy => 'Copy link';

  @override
  String get addLinkTitle => 'Add a link';

  @override
  String get linkLabel => 'Link';

  @override
  String get linkFieldHint => 'Paste or type a link';

  @override
  String get previewLabel => 'Preview';

  @override
  String get collectionLabel => 'Collection';

  @override
  String get previewFound => 'Found the title, summary and image';

  @override
  String get previewLoading => 'Getting the preview…';

  @override
  String get previewFailed =>
      'Couldn’t get a preview. Your link is saved, and you can add a title yourself.';

  @override
  String get previewOffline =>
      'You’re offline. We saved the link and will get the preview when you’re back online.';

  @override
  String get invalidLink =>
      'That doesn’t look like a link. It should start with http:// or https://';

  @override
  String get alreadySaved => 'You already saved this one';

  @override
  String get emptyTitle => 'Save it now. Find it later.';

  @override
  String get emptyBody =>
      'Share a link from any app, or paste one here. Your links stay on this phone.';

  @override
  String get emptyCollection => 'No links in this collection yet.';

  @override
  String linkSubtitle(String domain, String collection) {
    return '$domain · $collection';
  }

  @override
  String get couldNotOpen => 'Couldn’t open this link.';

  @override
  String get savedTitle => 'Saved!';

  @override
  String savedMeta(String domain, String collection) {
    return '$domain · added to $collection';
  }

  @override
  String get changeCollection => 'Change collection';

  @override
  String get done => 'Done';

  @override
  String get closesSoon => 'Closes by itself in a few seconds';

  @override
  String get duplicateTitle => 'You already saved this one';

  @override
  String savedOnIn(String date, String collection) {
    return 'Saved on $date in $collection';
  }

  @override
  String savedOn(String date) {
    return 'Saved on $date';
  }

  @override
  String get saveCopy => 'Save a copy';

  @override
  String get openSaved => 'Open saved link';

  @override
  String get noLinkShared => 'We couldn’t find a link in what you shared.';

  @override
  String moveTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Move $count links to…',
      one: 'Move this link to…',
    );
    return '$_temp0';
  }

  @override
  String get moveHelp => 'Pick a collection. Links can only be in one.';

  @override
  String get noCollection => 'No collection';

  @override
  String linkCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count links',
      one: '1 link',
    );
    return '$_temp0';
  }

  @override
  String moveTo(String name) {
    return 'Move to $name';
  }

  @override
  String get clipboardTitle => 'Save the link you copied?';
}
