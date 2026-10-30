import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Linkbox'**
  String get appTitle;

  /// No description provided for @navLinks.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get navLinks;

  /// No description provided for @navCollections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get navCollections;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your links'**
  String get homeTitle;

  /// No description provided for @collectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get collectionsTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or link'**
  String get searchHint;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @sortTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortTooltip;

  /// No description provided for @switchToList.
  ///
  /// In en, this message translates to:
  /// **'Switch to list view'**
  String get switchToList;

  /// No description provided for @switchToGrid.
  ///
  /// In en, this message translates to:
  /// **'Switch to grid view'**
  String get switchToGrid;

  /// No description provided for @addLink.
  ///
  /// In en, this message translates to:
  /// **'Add link'**
  String get addLink;

  /// No description provided for @chipAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get chipAll;

  /// No description provided for @chipNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get chipNone;

  /// No description provided for @chipNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get chipNew;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @kindVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get kindVideo;

  /// No description provided for @kindArticle.
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get kindArticle;

  /// No description provided for @kindPost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get kindPost;

  /// No description provided for @linkNumber.
  ///
  /// In en, this message translates to:
  /// **'NO.{number}'**
  String linkNumber(String number);

  /// No description provided for @noPreview.
  ///
  /// In en, this message translates to:
  /// **'No preview'**
  String get noPreview;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @gettingPreview.
  ///
  /// In en, this message translates to:
  /// **'Getting the preview…'**
  String get gettingPreview;

  /// No description provided for @saveLink.
  ///
  /// In en, this message translates to:
  /// **'Save link'**
  String get saveLink;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @keepThem.
  ///
  /// In en, this message translates to:
  /// **'Keep them'**
  String get keepThem;

  /// No description provided for @deleteLinks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 link} other{Delete {count} links}}'**
  String deleteLinks(int count);

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'This part arrives in milestone {milestone}.'**
  String comingSoon(String milestone);

  /// No description provided for @widgetGallery.
  ///
  /// In en, this message translates to:
  /// **'Widget gallery'**
  String get widgetGallery;

  /// No description provided for @widgetGalleryHint.
  ///
  /// In en, this message translates to:
  /// **'Every core widget, in light and dark'**
  String get widgetGalleryHint;

  /// No description provided for @galleryTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get galleryTheme;

  /// No description provided for @galleryButtons.
  ///
  /// In en, this message translates to:
  /// **'Buttons'**
  String get galleryButtons;

  /// No description provided for @galleryIconBoxes.
  ///
  /// In en, this message translates to:
  /// **'Icon boxes'**
  String get galleryIconBoxes;

  /// No description provided for @galleryChips.
  ///
  /// In en, this message translates to:
  /// **'Chips'**
  String get galleryChips;

  /// No description provided for @galleryInputs.
  ///
  /// In en, this message translates to:
  /// **'Search, switch, picker'**
  String get galleryInputs;

  /// No description provided for @galleryCards.
  ///
  /// In en, this message translates to:
  /// **'Link cards'**
  String get galleryCards;

  /// No description provided for @galleryCardStates.
  ///
  /// In en, this message translates to:
  /// **'Card states'**
  String get galleryCardStates;

  /// No description provided for @galleryList.
  ///
  /// In en, this message translates to:
  /// **'List rows'**
  String get galleryList;

  /// No description provided for @galleryMascot.
  ///
  /// In en, this message translates to:
  /// **'Mascot'**
  String get galleryMascot;

  /// No description provided for @gallerySheet.
  ///
  /// In en, this message translates to:
  /// **'Bottom sheet'**
  String get gallerySheet;

  /// No description provided for @galleryOpenSheet.
  ///
  /// In en, this message translates to:
  /// **'Open a sheet'**
  String get galleryOpenSheet;

  /// No description provided for @gallerySelecting.
  ///
  /// In en, this message translates to:
  /// **'Multi-select look'**
  String get gallerySelecting;

  /// No description provided for @sheetDemoTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a link'**
  String get sheetDemoTitle;

  /// No description provided for @sheetDemoBody.
  ///
  /// In en, this message translates to:
  /// **'Sheets slide up over a dimmed screen, with a grabber on top.'**
  String get sheetDemoBody;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @pureBlack.
  ///
  /// In en, this message translates to:
  /// **'Pure black dark mode'**
  String get pureBlack;

  /// No description provided for @pureBlackHint.
  ///
  /// In en, this message translates to:
  /// **'Saves battery on AMOLED screens'**
  String get pureBlackHint;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get accentColor;

  /// No description provided for @tapActionLabel.
  ///
  /// In en, this message translates to:
  /// **'When I tap a link'**
  String get tapActionLabel;

  /// No description provided for @tapQuickLook.
  ///
  /// In en, this message translates to:
  /// **'Quick look'**
  String get tapQuickLook;

  /// No description provided for @tapOpen.
  ///
  /// In en, this message translates to:
  /// **'Open site'**
  String get tapOpen;

  /// No description provided for @tapCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get tapCopy;

  /// No description provided for @addLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a link'**
  String get addLinkTitle;

  /// No description provided for @linkLabel.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get linkLabel;

  /// No description provided for @linkFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Paste or type a link'**
  String get linkFieldHint;

  /// No description provided for @previewLabel.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewLabel;

  /// No description provided for @collectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get collectionLabel;

  /// No description provided for @previewFound.
  ///
  /// In en, this message translates to:
  /// **'Found the title, summary and image'**
  String get previewFound;

  /// No description provided for @previewLoading.
  ///
  /// In en, this message translates to:
  /// **'Getting the preview…'**
  String get previewLoading;

  /// No description provided for @previewFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t get a preview. Your link is saved, and you can add a title yourself.'**
  String get previewFailed;

  /// No description provided for @previewOffline.
  ///
  /// In en, this message translates to:
  /// **'You’re offline. We saved the link and will get the preview when you’re back online.'**
  String get previewOffline;

  /// No description provided for @invalidLink.
  ///
  /// In en, this message translates to:
  /// **'That doesn’t look like a link. It should start with http:// or https://'**
  String get invalidLink;

  /// No description provided for @alreadySaved.
  ///
  /// In en, this message translates to:
  /// **'You already saved this one'**
  String get alreadySaved;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Save it now. Find it later.'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In en, this message translates to:
  /// **'Share a link from any app, or paste one here. Your links stay on this phone.'**
  String get emptyBody;

  /// No description provided for @emptyCollection.
  ///
  /// In en, this message translates to:
  /// **'No links in this collection yet.'**
  String get emptyCollection;

  /// No description provided for @linkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{domain} · {collection}'**
  String linkSubtitle(String domain, String collection);

  /// No description provided for @couldNotOpen.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t open this link.'**
  String get couldNotOpen;

  /// No description provided for @savedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved!'**
  String get savedTitle;

  /// No description provided for @savedMeta.
  ///
  /// In en, this message translates to:
  /// **'{domain} · added to {collection}'**
  String savedMeta(String domain, String collection);

  /// No description provided for @changeCollection.
  ///
  /// In en, this message translates to:
  /// **'Change collection'**
  String get changeCollection;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @closesSoon.
  ///
  /// In en, this message translates to:
  /// **'Closes by itself in a few seconds'**
  String get closesSoon;

  /// No description provided for @duplicateTitle.
  ///
  /// In en, this message translates to:
  /// **'You already saved this one'**
  String get duplicateTitle;

  /// No description provided for @savedOnIn.
  ///
  /// In en, this message translates to:
  /// **'Saved on {date} in {collection}'**
  String savedOnIn(String date, String collection);

  /// No description provided for @savedOn.
  ///
  /// In en, this message translates to:
  /// **'Saved on {date}'**
  String savedOn(String date);

  /// No description provided for @saveCopy.
  ///
  /// In en, this message translates to:
  /// **'Save a copy'**
  String get saveCopy;

  /// No description provided for @openSaved.
  ///
  /// In en, this message translates to:
  /// **'Open saved link'**
  String get openSaved;

  /// No description provided for @noLinkShared.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t find a link in what you shared.'**
  String get noLinkShared;

  /// No description provided for @moveTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Move this link to…} other{Move {count} links to…}}'**
  String moveTitle(int count);

  /// No description provided for @moveHelp.
  ///
  /// In en, this message translates to:
  /// **'Pick a collection. Links can only be in one.'**
  String get moveHelp;

  /// No description provided for @noCollection.
  ///
  /// In en, this message translates to:
  /// **'No collection'**
  String get noCollection;

  /// No description provided for @linkCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 link} other{{count} links}}'**
  String linkCount(int count);

  /// No description provided for @moveTo.
  ///
  /// In en, this message translates to:
  /// **'Move to {name}'**
  String moveTo(String name);

  /// No description provided for @clipboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Save the link you copied?'**
  String get clipboardTitle;

  /// No description provided for @sortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort links'**
  String get sortTitle;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get sortOldest;

  /// No description provided for @sortAz.
  ///
  /// In en, this message translates to:
  /// **'Name A–Z'**
  String get sortAz;

  /// No description provided for @sortZa.
  ///
  /// In en, this message translates to:
  /// **'Name Z–A'**
  String get sortZa;

  /// No description provided for @allCollections.
  ///
  /// In en, this message translates to:
  /// **'All collections'**
  String get allCollections;

  /// No description provided for @showLinksFrom.
  ///
  /// In en, this message translates to:
  /// **'Show links from'**
  String get showLinksFrom;

  /// No description provided for @searchResultCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 link matches “{query}”} other{{count} links match “{query}”}}'**
  String searchResultCount(int count, String query);

  /// No description provided for @noResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No links match “{query}”'**
  String noResultsTitle(String query);

  /// No description provided for @noResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try a shorter word, or search part of the link itself.'**
  String get noResultsBody;

  /// No description provided for @searchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search links'**
  String get searchLabel;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get linkCopied;

  /// No description provided for @savedToday.
  ///
  /// In en, this message translates to:
  /// **'Saved today'**
  String get savedToday;

  /// No description provided for @savedYesterday.
  ///
  /// In en, this message translates to:
  /// **'Saved yesterday'**
  String get savedYesterday;

  /// No description provided for @savedDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Saved 1 day ago} other{Saved {count} days ago}}'**
  String savedDaysAgo(int count);

  /// No description provided for @savedOnDate.
  ///
  /// In en, this message translates to:
  /// **'Saved on {date}'**
  String savedOnDate(String date);

  /// No description provided for @openInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in browser'**
  String get openInBrowser;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @moveToCollection.
  ///
  /// In en, this message translates to:
  /// **'Move to collection'**
  String get moveToCollection;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete this link?} other{Delete {count} links?}}'**
  String deleteTitle(int count);

  /// No description provided for @deleteBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{It’ll be removed from this phone. This can’t be undone unless you have a backup.} other{They’ll be removed from this phone. This can’t be undone unless you have a backup.}}'**
  String deleteBody(int count);

  /// No description provided for @deletedLinks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Deleted 1 link} other{Deleted {count} links}}'**
  String deletedLinks(int count);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @editTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit link'**
  String get editTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'Change image'**
  String get changeImage;

  /// No description provided for @fetchAgain.
  ///
  /// In en, this message translates to:
  /// **'Fetch again'**
  String get fetchAgain;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @summaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryLabel;

  /// No description provided for @charCount.
  ///
  /// In en, this message translates to:
  /// **'{count} / {max}'**
  String charCount(int count, int max);

  /// No description provided for @fetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t get a preview. You can still type a title yourself.'**
  String get fetchFailed;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @newShort.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newShort;

  /// No description provided for @newCollectionTitle.
  ///
  /// In en, this message translates to:
  /// **'New collection'**
  String get newCollectionTitle;

  /// No description provided for @editCollectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit collection'**
  String get editCollectionTitle;

  /// No description provided for @createCollection.
  ///
  /// In en, this message translates to:
  /// **'Create collection'**
  String get createCollection;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @namePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Travel, Recipes, Read later…'**
  String get namePlaceholder;

  /// No description provided for @colorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorLabel;

  /// No description provided for @iconLabel.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get iconLabel;

  /// No description provided for @previewMeta.
  ///
  /// In en, this message translates to:
  /// **'{links} · preview'**
  String previewMeta(String links);

  /// No description provided for @duplicateCollectionName.
  ///
  /// In en, this message translates to:
  /// **'You already have a collection with this name'**
  String get duplicateCollectionName;

  /// No description provided for @createACollection.
  ///
  /// In en, this message translates to:
  /// **'Create a collection'**
  String get createACollection;

  /// No description provided for @newCollection.
  ///
  /// In en, this message translates to:
  /// **'New collection'**
  String get newCollection;

  /// No description provided for @allLinks.
  ///
  /// In en, this message translates to:
  /// **'All links'**
  String get allLinks;

  /// No description provided for @updatedWhen.
  ///
  /// In en, this message translates to:
  /// **'Updated {when}'**
  String updatedWhen(String when);

  /// No description provided for @whenToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get whenToday;

  /// No description provided for @whenYesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get whenYesterday;

  /// No description provided for @whenDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String whenDaysAgo(int count);

  /// No description provided for @whenLastWeek.
  ///
  /// In en, this message translates to:
  /// **'last week'**
  String get whenLastWeek;

  /// No description provided for @whenWeeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} weeks ago'**
  String whenWeeksAgo(int count);

  /// No description provided for @whenNever.
  ///
  /// In en, this message translates to:
  /// **'never'**
  String get whenNever;

  /// No description provided for @collectionMeta.
  ///
  /// In en, this message translates to:
  /// **'{links} · updated {when}'**
  String collectionMeta(String links, String when);

  /// No description provided for @addToCollection.
  ///
  /// In en, this message translates to:
  /// **'Add to {name}'**
  String addToCollection(String name);

  /// No description provided for @searchIn.
  ///
  /// In en, this message translates to:
  /// **'Search in {name}'**
  String searchIn(String name);

  /// No description provided for @collectionOptions.
  ///
  /// In en, this message translates to:
  /// **'Collection options'**
  String get collectionOptions;

  /// No description provided for @optRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get optRename;

  /// No description provided for @optRenameSub.
  ///
  /// In en, this message translates to:
  /// **'Change the collection’s name'**
  String get optRenameSub;

  /// No description provided for @optColor.
  ///
  /// In en, this message translates to:
  /// **'Color & icon'**
  String get optColor;

  /// No description provided for @optColorSub.
  ///
  /// In en, this message translates to:
  /// **'Make it easy to spot'**
  String get optColorSub;

  /// No description provided for @optPin.
  ///
  /// In en, this message translates to:
  /// **'Pin to top'**
  String get optPin;

  /// No description provided for @optUnpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get optUnpin;

  /// No description provided for @optPinSub.
  ///
  /// In en, this message translates to:
  /// **'Show first in Collections and on Home'**
  String get optPinSub;

  /// No description provided for @optShare.
  ///
  /// In en, this message translates to:
  /// **'Share all links'**
  String get optShare;

  /// No description provided for @optShareSub.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Send the link} other{Send the {count} links as a list}}'**
  String optShareSub(int count);

  /// No description provided for @optDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete collection'**
  String get optDelete;

  /// No description provided for @optDeleteSub.
  ///
  /// In en, this message translates to:
  /// **'Links move to “No collection”, nothing is lost'**
  String get optDeleteSub;

  /// No description provided for @deleteCollectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”?'**
  String deleteCollectionTitle(String name);

  /// No description provided for @keepIt.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get keepIt;

  /// No description provided for @colorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get colorPink;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get colorYellow;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @colorPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get colorPurple;

  /// No description provided for @colorPeach.
  ///
  /// In en, this message translates to:
  /// **'Peach'**
  String get colorPeach;

  /// No description provided for @iconPlane.
  ///
  /// In en, this message translates to:
  /// **'Plane'**
  String get iconPlane;

  /// No description provided for @iconStar.
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get iconStar;

  /// No description provided for @iconCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get iconCode;

  /// No description provided for @iconBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get iconBook;

  /// No description provided for @iconHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get iconHome;

  /// No description provided for @iconMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get iconMusic;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @cancelSelection.
  ///
  /// In en, this message translates to:
  /// **'Cancel selection'**
  String get cancelSelection;

  /// No description provided for @selectMore.
  ///
  /// In en, this message translates to:
  /// **'Select more'**
  String get selectMore;

  /// No description provided for @iconHeart.
  ///
  /// In en, this message translates to:
  /// **'Heart'**
  String get iconHeart;

  /// No description provided for @iconVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get iconVideo;

  /// No description provided for @iconCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get iconCamera;

  /// No description provided for @iconGame.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get iconGame;

  /// No description provided for @iconFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get iconFood;

  /// No description provided for @iconCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get iconCoffee;

  /// No description provided for @iconBag.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get iconBag;

  /// No description provided for @iconGift.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get iconGift;

  /// No description provided for @iconWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get iconWork;

  /// No description provided for @iconSchool.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get iconSchool;

  /// No description provided for @iconIdea.
  ///
  /// In en, this message translates to:
  /// **'Ideas'**
  String get iconIdea;

  /// No description provided for @iconNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get iconNews;

  /// No description provided for @iconFitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get iconFitness;

  /// No description provided for @iconLeaf.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get iconLeaf;

  /// No description provided for @iconPlace.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get iconPlace;

  /// No description provided for @iconGlobe.
  ///
  /// In en, this message translates to:
  /// **'World'**
  String get iconGlobe;

  /// No description provided for @iconCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get iconCar;

  /// No description provided for @iconPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get iconPeople;

  /// No description provided for @colorOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get colorOrange;

  /// No description provided for @colorLime.
  ///
  /// In en, this message translates to:
  /// **'Lime'**
  String get colorLime;

  /// No description provided for @colorTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get colorTeal;

  /// No description provided for @colorCoral.
  ///
  /// In en, this message translates to:
  /// **'Coral'**
  String get colorCoral;

  /// No description provided for @colorLilac.
  ///
  /// In en, this message translates to:
  /// **'Lilac'**
  String get colorLilac;

  /// No description provided for @colorSand.
  ///
  /// In en, this message translates to:
  /// **'Sand'**
  String get colorSand;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
