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
