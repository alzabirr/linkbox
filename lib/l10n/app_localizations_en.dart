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
}
