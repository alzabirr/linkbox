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

  @override
  String get sortTitle => 'Sort links';

  @override
  String get sortNewest => 'Newest first';

  @override
  String get sortOldest => 'Oldest first';

  @override
  String get sortAz => 'Name A–Z';

  @override
  String get sortZa => 'Name Z–A';

  @override
  String get allCollections => 'All collections';

  @override
  String get showLinksFrom => 'Show links from';

  @override
  String searchResultCount(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count links match “$query”',
      one: '1 link matches “$query”',
    );
    return '$_temp0';
  }

  @override
  String noResultsTitle(String query) {
    return 'No links match “$query”';
  }

  @override
  String get noResultsBody =>
      'Try a shorter word, or search part of the link itself.';

  @override
  String get searchLabel => 'Search links';

  @override
  String get open => 'Open';

  @override
  String get copy => 'Copy';

  @override
  String get share => 'Share';

  @override
  String get edit => 'Edit';

  @override
  String get move => 'Move';

  @override
  String get delete => 'Delete';

  @override
  String get linkCopied => 'Link copied';

  @override
  String get savedToday => 'Saved today';

  @override
  String get savedYesterday => 'Saved yesterday';

  @override
  String savedDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Saved $count days ago',
      one: 'Saved 1 day ago',
    );
    return '$_temp0';
  }

  @override
  String savedOnDate(String date) {
    return 'Saved on $date';
  }

  @override
  String get openInBrowser => 'Open in browser';

  @override
  String get copyLink => 'Copy link';

  @override
  String get moveToCollection => 'Move to collection';

  @override
  String deleteTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $count links?',
      one: 'Delete this link?',
    );
    return '$_temp0';
  }

  @override
  String deleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'They’ll be removed from this phone. This can’t be undone unless you have a backup.',
      one: 'It’ll be removed from this phone. This can’t be undone unless you have a backup.',
    );
    return '$_temp0';
  }

  @override
  String deletedLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Deleted $count links',
      one: 'Deleted 1 link',
    );
    return '$_temp0';
  }

  @override
  String get undo => 'Undo';

  @override
  String get editTitle => 'Edit link';

  @override
  String get save => 'Save';

  @override
  String get changeImage => 'Change image';

  @override
  String get fetchAgain => 'Fetch again';

  @override
  String get titleLabel => 'Title';

  @override
  String get summaryLabel => 'Summary';

  @override
  String charCount(int count, int max) {
    return '$count / $max';
  }

  @override
  String get fetchFailed =>
      'Couldn’t get a preview. You can still type a title yourself.';

  @override
  String get copied => 'Copied';

  @override
  String get newShort => 'New';

  @override
  String get newCollectionTitle => 'New collection';

  @override
  String get editCollectionTitle => 'Edit collection';

  @override
  String get createCollection => 'Create collection';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get nameLabel => 'Name';

  @override
  String get namePlaceholder => 'Travel, Recipes, Read later…';

  @override
  String get colorLabel => 'Color';

  @override
  String get iconLabel => 'Icon';

  @override
  String previewMeta(String links) {
    return '$links · preview';
  }

  @override
  String get duplicateCollectionName =>
      'You already have a collection with this name';

  @override
  String get createACollection => 'Create a collection';

  @override
  String get newCollection => 'New collection';

  @override
  String get allLinks => 'All links';

  @override
  String updatedWhen(String when) {
    return 'Updated $when';
  }

  @override
  String get whenToday => 'today';

  @override
  String get whenYesterday => 'yesterday';

  @override
  String whenDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get whenLastWeek => 'last week';

  @override
  String whenWeeksAgo(int count) {
    return '$count weeks ago';
  }

  @override
  String get whenNever => 'never';

  @override
  String collectionMeta(String links, String when) {
    return '$links · updated $when';
  }

  @override
  String addToCollection(String name) {
    return 'Add to $name';
  }

  @override
  String searchIn(String name) {
    return 'Search in $name';
  }

  @override
  String get collectionOptions => 'Collection options';

  @override
  String get optRename => 'Rename';

  @override
  String get optRenameSub => 'Change the collection’s name';

  @override
  String get optColor => 'Color & icon';

  @override
  String get optColorSub => 'Make it easy to spot';

  @override
  String get optPin => 'Pin to top';

  @override
  String get optUnpin => 'Unpin';

  @override
  String get optPinSub => 'Show first in Collections and on Home';

  @override
  String get optShare => 'Share all links';

  @override
  String optShareSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Send the $count links as a list',
      one: 'Send the link',
    );
    return '$_temp0';
  }

  @override
  String get optDelete => 'Delete collection';

  @override
  String get optDeleteSub => 'Links move to “No collection”, nothing is lost';

  @override
  String deleteCollectionTitle(String name) {
    return 'Delete “$name”?';
  }

  @override
  String get keepIt => 'Keep it';

  @override
  String get colorPink => 'Pink';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorYellow => 'Yellow';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorPurple => 'Purple';

  @override
  String get colorPeach => 'Peach';

  @override
  String get iconPlane => 'Plane';

  @override
  String get iconStar => 'Star';

  @override
  String get iconCode => 'Code';

  @override
  String get iconBook => 'Book';

  @override
  String get iconHome => 'Home';

  @override
  String get iconMusic => 'Music';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get selectAll => 'Select all';

  @override
  String get cancelSelection => 'Cancel selection';

  @override
  String get selectMore => 'Select more';

  @override
  String get iconHeart => 'Heart';

  @override
  String get iconVideo => 'Video';

  @override
  String get iconCamera => 'Camera';

  @override
  String get iconGame => 'Games';

  @override
  String get iconFood => 'Food';

  @override
  String get iconCoffee => 'Coffee';

  @override
  String get iconBag => 'Shopping';

  @override
  String get iconGift => 'Gift';

  @override
  String get iconWork => 'Work';

  @override
  String get iconSchool => 'Study';

  @override
  String get iconIdea => 'Ideas';

  @override
  String get iconNews => 'News';

  @override
  String get iconFitness => 'Fitness';

  @override
  String get iconLeaf => 'Nature';

  @override
  String get iconPlace => 'Places';

  @override
  String get iconGlobe => 'World';

  @override
  String get iconCar => 'Car';

  @override
  String get iconPeople => 'People';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorLime => 'Lime';

  @override
  String get colorTeal => 'Teal';

  @override
  String get colorCoral => 'Coral';

  @override
  String get colorLilac => 'Lilac';

  @override
  String get colorSand => 'Sand';

  @override
  String get dataTitle => 'Your data';

  @override
  String get dataRowTitle => 'Import, export & backup';

  @override
  String lastBackup(String when) {
    return 'Last backup: $when';
  }

  @override
  String get lastBackupNever => 'No backup yet';

  @override
  String get downloadFolder => 'Download/Linkbox';

  @override
  String get backupTitle => 'Backup';

  @override
  String backupBody(String folder) {
    return 'Saves every link and collection to $folder on this phone.';
  }

  @override
  String get backupNow => 'Back up now';

  @override
  String get restore => 'Restore';

  @override
  String get importTitle => 'Import from a browser';

  @override
  String get importBody =>
      'In Chrome, Firefox, Edge or Brave, export your bookmarks as an HTML file. Then pick that file here.';

  @override
  String get chooseHtml => 'Choose HTML file';

  @override
  String get exportTitle => 'Export';

  @override
  String get exportBody =>
      'HTML opens in any browser. JSON keeps everything for re-importing later.';

  @override
  String get exportHtml => 'Export HTML';

  @override
  String get exportJson => 'Export JSON';

  @override
  String importDone(int imported, int skipped) {
    return 'Imported $imported links. Skipped $skipped you already had.';
  }

  @override
  String get importError =>
      'We couldn’t read that file. Pick the .html file your browser exported.';

  @override
  String get backupFailed =>
      'Backup didn’t finish. Free up some space on your phone and try again.';

  @override
  String get backupDone => 'Backup saved to Download/Linkbox';

  @override
  String exportDone(String name) {
    return 'Saved to Download/Linkbox/$name';
  }

  @override
  String restorePick(String folder) {
    return 'Pick a backup from $folder.';
  }

  @override
  String collectionCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count collections',
      one: '1 collection',
    );
    return '$_temp0';
  }

  @override
  String restoreMeta(String links, String collections, String size) {
    return '$links · $collections · $size';
  }

  @override
  String get restoreHow => 'How should we restore?';

  @override
  String get restoreAdd => 'Add to my links';

  @override
  String get restoreAddSub =>
      'Keeps everything you have now. Duplicates are skipped.';

  @override
  String get restoreReplace => 'Replace everything';

  @override
  String restoreReplaceSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your current $count links are removed first.',
      one: 'Your current link is removed first.',
    );
    return '$_temp0';
  }

  @override
  String restoreButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Restore $count links',
      one: 'Restore 1 link',
    );
    return '$_temp0';
  }

  @override
  String get restoreChooseFile => 'Choose a backup file';

  @override
  String get restoreNone =>
      'No backups found here. If you reinstalled the app, choose the backup file yourself.';

  @override
  String get restoreError =>
      'That isn’t a Linkbox backup. Pick a linkbox-backup file (.json).';

  @override
  String restoreDone(int imported, int skipped) {
    return 'Restored $imported links. Skipped $skipped you already had.';
  }

  @override
  String get replaceConfirmTitle => 'Replace everything?';

  @override
  String get replaceConfirmBody =>
      'Your current links and collections are removed, then the backup is restored.';

  @override
  String get chosenFile => 'Chosen file';
}
