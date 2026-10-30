// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'Linkbox';

  @override
  String get navLinks => 'লিংক';

  @override
  String get navCollections => 'কালেকশন';

  @override
  String get navSettings => 'সেটিংস';

  @override
  String get homeTitle => 'আপনার লিংক';

  @override
  String get collectionsTitle => 'কালেকশন';

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get searchHint => 'নাম বা লিংক দিয়ে খুঁজুন';

  @override
  String get clearSearch => 'খোঁজা মুছুন';

  @override
  String get sortTooltip => 'সাজান';

  @override
  String get switchToList => 'তালিকা হিসেবে দেখুন';

  @override
  String get switchToGrid => 'গ্রিড হিসেবে দেখুন';

  @override
  String get addLink => 'লিংক যোগ করুন';

  @override
  String get chipAll => 'সব';

  @override
  String get chipNone => 'কোনোটি না';

  @override
  String get chipNew => 'নতুন';

  @override
  String get moreOptions => 'আরও অপশন';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get back => 'ফিরে যান';

  @override
  String get kindVideo => 'ভিডিও';

  @override
  String get kindArticle => 'লেখা';

  @override
  String get kindPost => 'পোস্ট';

  @override
  String linkNumber(String number) {
    return 'নং.$number';
  }

  @override
  String get noPreview => 'প্রিভিউ নেই';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get gettingPreview => 'প্রিভিউ আনা হচ্ছে…';

  @override
  String get saveLink => 'লিংক সেভ করুন';

  @override
  String get notNow => 'এখন না';

  @override
  String get paste => 'পেস্ট';

  @override
  String get keepThem => 'রেখে দিন';

  @override
  String deleteLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লিংক মুছুন',
      one: '১টি লিংক মুছুন',
    );
    return '$_temp0';
  }

  @override
  String comingSoon(String milestone) {
    return 'এই অংশটি মাইলস্টোন $milestone-এ আসবে।';
  }

  @override
  String get widgetGallery => 'উইজেট গ্যালারি';

  @override
  String get widgetGalleryHint => 'সব মূল উইজেট, লাইট ও ডার্ক মোডে';

  @override
  String get galleryTheme => 'থিম';

  @override
  String get galleryButtons => 'বাটন';

  @override
  String get galleryIconBoxes => 'আইকন বাটন';

  @override
  String get galleryChips => 'চিপ';

  @override
  String get galleryInputs => 'খোঁজা, সুইচ, পিকার';

  @override
  String get galleryCards => 'লিংক কার্ড';

  @override
  String get galleryCardStates => 'কার্ডের অবস্থা';

  @override
  String get galleryList => 'তালিকার সারি';

  @override
  String get galleryMascot => 'মাসকট';

  @override
  String get gallerySheet => 'নিচের শিট';

  @override
  String get galleryOpenSheet => 'একটি শিট খুলুন';

  @override
  String get gallerySelecting => 'একাধিক বাছাই';

  @override
  String get sheetDemoTitle => 'একটি লিংক যোগ করুন';

  @override
  String get sheetDemoBody =>
      'শিট নিচ থেকে উঠে আসে, পেছনের স্ক্রিন একটু অন্ধকার হয়।';

  @override
  String get themeLight => 'লাইট';

  @override
  String get themeDark => 'ডার্ক';

  @override
  String get themeSystem => 'সিস্টেম';

  @override
  String get pureBlack => 'পুরো কালো ডার্ক মোড';

  @override
  String get pureBlackHint => 'AMOLED স্ক্রিনে ব্যাটারি বাঁচায়';

  @override
  String get accentColor => 'অ্যাকসেন্ট রং';

  @override
  String get tapActionLabel => 'লিংকে ট্যাপ করলে';

  @override
  String get tapQuickLook => 'এক নজরে';

  @override
  String get tapOpen => 'সাইট খুলুন';

  @override
  String get tapCopy => 'লিংক কপি';

  @override
  String get addLinkTitle => 'একটি লিংক যোগ করুন';

  @override
  String get linkLabel => 'লিংক';

  @override
  String get linkFieldHint => 'লিংক পেস্ট করুন বা লিখুন';

  @override
  String get previewLabel => 'প্রিভিউ';

  @override
  String get collectionLabel => 'কালেকশন';

  @override
  String get previewFound => 'শিরোনাম, সারাংশ আর ছবি পাওয়া গেছে';

  @override
  String get previewLoading => 'প্রিভিউ আনা হচ্ছে…';

  @override
  String get previewFailed =>
      'প্রিভিউ পাওয়া যায়নি। লিংকটি সেভ হয়েছে, আপনি নিজে শিরোনাম দিতে পারেন।';

  @override
  String get previewOffline =>
      'আপনি অফলাইনে আছেন। লিংকটি সেভ হয়েছে, অনলাইনে এলে প্রিভিউ আনা হবে।';

  @override
  String get invalidLink =>
      'এটা লিংকের মতো দেখাচ্ছে না। লিংক http:// বা https:// দিয়ে শুরু হয়।';

  @override
  String get alreadySaved => 'এই লিংকটি আগেই সেভ করেছেন';

  @override
  String get emptyTitle => 'এখন সেভ করুন। পরে খুঁজে নিন।';

  @override
  String get emptyBody =>
      'যেকোনো অ্যাপ থেকে লিংক শেয়ার করুন, বা এখানে পেস্ট করুন। আপনার লিংক এই ফোনেই থাকে।';

  @override
  String get emptyCollection => 'এই কালেকশনে এখনো কোনো লিংক নেই।';

  @override
  String linkSubtitle(String domain, String collection) {
    return '$domain · $collection';
  }

  @override
  String get couldNotOpen => 'লিংকটি খোলা গেল না।';

  @override
  String get savedTitle => 'সেভ হয়েছে!';

  @override
  String savedMeta(String domain, String collection) {
    return '$domain · $collection-এ যোগ হয়েছে';
  }

  @override
  String get changeCollection => 'কালেকশন বদলান';

  @override
  String get done => 'ঠিক আছে';

  @override
  String get closesSoon => 'কয়েক সেকেন্ডে নিজে থেকেই বন্ধ হবে';

  @override
  String get duplicateTitle => 'এটি আগেই সেভ করেছেন';

  @override
  String savedOnIn(String date, String collection) {
    return '$date তারিখে $collection-এ সেভ করা';
  }

  @override
  String savedOn(String date) {
    return '$date তারিখে সেভ করা';
  }

  @override
  String get saveCopy => 'আরেকটি কপি সেভ করুন';

  @override
  String get openSaved => 'সেভ করা লিংক খুলুন';

  @override
  String get noLinkShared => 'শেয়ার করা লেখায় কোনো লিংক পাওয়া যায়নি।';

  @override
  String moveTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লিংক সরান…',
      one: 'এই লিংকটি সরান…',
    );
    return '$_temp0';
  }

  @override
  String get moveHelp =>
      'একটি কালেকশন বাছুন। একটি লিংক শুধু একটি কালেকশনে থাকে।';

  @override
  String get noCollection => 'কোনো কালেকশন নয়';

  @override
  String linkCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লিংক',
      one: '১টি লিংক',
    );
    return '$_temp0';
  }

  @override
  String moveTo(String name) {
    return '$name-এ সরান';
  }

  @override
  String get clipboardTitle => 'কপি করা লিংকটি সেভ করবেন?';

  @override
  String get sortTitle => 'লিংক সাজান';

  @override
  String get sortNewest => 'নতুনগুলো আগে';

  @override
  String get sortOldest => 'পুরনোগুলো আগে';

  @override
  String get sortAz => 'নাম A–Z';

  @override
  String get sortZa => 'নাম Z–A';

  @override
  String get allCollections => 'সব কালেকশন';

  @override
  String get showLinksFrom => 'যেখান থেকে লিংক দেখাবে';

  @override
  String searchResultCount(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '“$query”-এর সাথে $countটি লিংক মিলেছে',
      one: '“$query”-এর সাথে ১টি লিংক মিলেছে',
    );
    return '$_temp0';
  }

  @override
  String noResultsTitle(String query) {
    return '“$query”-এর সাথে কোনো লিংক মেলেনি';
  }

  @override
  String get noResultsBody =>
      'ছোট কোনো শব্দ দিয়ে, বা লিংকের অংশ দিয়ে খুঁজে দেখুন।';

  @override
  String get searchLabel => 'লিংক খুঁজুন';

  @override
  String get open => 'খুলুন';

  @override
  String get copy => 'কপি';

  @override
  String get share => 'শেয়ার';

  @override
  String get edit => 'এডিট';

  @override
  String get move => 'সরান';

  @override
  String get delete => 'মুছুন';

  @override
  String get linkCopied => 'লিংক কপি হয়েছে';

  @override
  String get savedToday => 'আজ সেভ করা';

  @override
  String get savedYesterday => 'গতকাল সেভ করা';

  @override
  String savedDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন আগে সেভ করা',
      one: '১ দিন আগে সেভ করা',
    );
    return '$_temp0';
  }

  @override
  String savedOnDate(String date) {
    return '$date তারিখে সেভ করা';
  }

  @override
  String get openInBrowser => 'ব্রাউজারে খুলুন';

  @override
  String get copyLink => 'লিংক কপি';

  @override
  String get moveToCollection => 'কালেকশনে সরান';

  @override
  String deleteTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লিংক মুছবেন?',
      one: 'এই লিংকটি মুছবেন?',
    );
    return '$_temp0';
  }

  @override
  String deleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'এগুলো এই ফোন থেকে মুছে যাবে। ব্যাকআপ না থাকলে আর ফেরানো যাবে না।',
      one: 'এটি এই ফোন থেকে মুছে যাবে। ব্যাকআপ না থাকলে আর ফেরানো যাবে না।',
    );
    return '$_temp0';
  }

  @override
  String deletedLinks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লিংক মোছা হয়েছে',
      one: '১টি লিংক মোছা হয়েছে',
    );
    return '$_temp0';
  }

  @override
  String get undo => 'ফেরান';

  @override
  String get editTitle => 'লিংক এডিট';

  @override
  String get save => 'সেভ';

  @override
  String get changeImage => 'ছবি বদলান';

  @override
  String get fetchAgain => 'আবার আনুন';

  @override
  String get titleLabel => 'শিরোনাম';

  @override
  String get summaryLabel => 'সারাংশ';

  @override
  String charCount(int count, int max) {
    return '$count / $max';
  }

  @override
  String get fetchFailed =>
      'প্রিভিউ পাওয়া যায়নি। আপনি নিজে শিরোনাম লিখতে পারেন।';

  @override
  String get copied => 'কপি হয়েছে';

  @override
  String get newShort => 'নতুন';

  @override
  String get newCollectionTitle => 'নতুন কালেকশন';

  @override
  String get editCollectionTitle => 'কালেকশন এডিট';

  @override
  String get createCollection => 'কালেকশন তৈরি করুন';

  @override
  String get saveChanges => 'পরিবর্তন সেভ করুন';

  @override
  String get nameLabel => 'নাম';

  @override
  String get namePlaceholder => 'ভ্রমণ, রান্না, পরে পড়ব…';

  @override
  String get colorLabel => 'রং';

  @override
  String get iconLabel => 'আইকন';

  @override
  String previewMeta(String links) {
    return '$links · প্রিভিউ';
  }

  @override
  String get duplicateCollectionName => 'এই নামে আপনার আগেই একটি কালেকশন আছে';

  @override
  String get createACollection => 'একটি কালেকশন তৈরি করুন';

  @override
  String get newCollection => 'নতুন কালেকশন';

  @override
  String get allLinks => 'সব লিংক';

  @override
  String updatedWhen(String when) {
    return 'আপডেট: $when';
  }

  @override
  String get whenToday => 'আজ';

  @override
  String get whenYesterday => 'গতকাল';

  @override
  String whenDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন আগে',
      one: '১ দিন আগে',
    );
    return '$_temp0';
  }

  @override
  String get whenLastWeek => 'গত সপ্তাহে';

  @override
  String whenWeeksAgo(int count) {
    return '$count সপ্তাহ আগে';
  }

  @override
  String get whenNever => 'কখনো না';

  @override
  String collectionMeta(String links, String when) {
    return '$links · আপডেট: $when';
  }

  @override
  String addToCollection(String name) {
    return '$name-এ যোগ করুন';
  }

  @override
  String searchIn(String name) {
    return '$name-এ খুঁজুন';
  }

  @override
  String get collectionOptions => 'কালেকশন অপশন';

  @override
  String get optRename => 'নাম বদলান';

  @override
  String get optRenameSub => 'কালেকশনের নাম বদলান';

  @override
  String get optColor => 'রং ও আইকন';

  @override
  String get optColorSub => 'সহজে চেনার জন্য';

  @override
  String get optPin => 'উপরে পিন করুন';

  @override
  String get optUnpin => 'পিন সরান';

  @override
  String get optPinSub => 'কালেকশন আর হোমে সবার আগে দেখাবে';

  @override
  String get optShare => 'সব লিংক শেয়ার করুন';

  @override
  String optShareSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লিংক তালিকা করে পাঠান',
      one: 'লিংকটি পাঠান',
    );
    return '$_temp0';
  }

  @override
  String get optDelete => 'কালেকশন মুছুন';

  @override
  String get optDeleteSub =>
      'লিংকগুলো “কোনো কালেকশন নয়”-এ যাবে, কিছুই হারাবে না';

  @override
  String deleteCollectionTitle(String name) {
    return '“$name” মুছবেন?';
  }

  @override
  String get keepIt => 'রেখে দিন';

  @override
  String get colorPink => 'গোলাপি';

  @override
  String get colorBlue => 'নীল';

  @override
  String get colorYellow => 'হলুদ';

  @override
  String get colorGreen => 'সবুজ';

  @override
  String get colorPurple => 'বেগুনি';

  @override
  String get colorPeach => 'পিচ';

  @override
  String get iconPlane => 'প্লেন';

  @override
  String get iconStar => 'তারা';

  @override
  String get iconCode => 'কোড';

  @override
  String get iconBook => 'বই';

  @override
  String get iconHome => 'বাড়ি';

  @override
  String get iconMusic => 'গান';

  @override
  String selectedCount(int count) {
    return '$countটি বাছাই করা';
  }

  @override
  String get selectAll => 'সব বাছুন';

  @override
  String get cancelSelection => 'বাছাই বাতিল';

  @override
  String get selectMore => 'আরও বাছুন';

  @override
  String get iconHeart => 'হৃদয়';

  @override
  String get iconVideo => 'ভিডিও';

  @override
  String get iconCamera => 'ক্যামেরা';

  @override
  String get iconGame => 'গেম';

  @override
  String get iconFood => 'খাবার';

  @override
  String get iconCoffee => 'কফি';

  @override
  String get iconBag => 'কেনাকাটা';

  @override
  String get iconGift => 'উপহার';

  @override
  String get iconWork => 'কাজ';

  @override
  String get iconSchool => 'পড়াশোনা';

  @override
  String get iconIdea => 'আইডিয়া';

  @override
  String get iconNews => 'খবর';

  @override
  String get iconFitness => 'ফিটনেস';

  @override
  String get iconLeaf => 'প্রকৃতি';

  @override
  String get iconPlace => 'জায়গা';

  @override
  String get iconGlobe => 'বিশ্ব';

  @override
  String get iconCar => 'গাড়ি';

  @override
  String get iconPeople => 'মানুষ';

  @override
  String get colorOrange => 'কমলা';

  @override
  String get colorLime => 'লেবু সবুজ';

  @override
  String get colorTeal => 'টিল';

  @override
  String get colorCoral => 'প্রবাল';

  @override
  String get colorLilac => 'হালকা বেগুনি';

  @override
  String get colorSand => 'বালু';

  @override
  String get dataTitle => 'আপনার ডেটা';

  @override
  String get dataRowTitle => 'ইমপোর্ট, এক্সপোর্ট ও ব্যাকআপ';

  @override
  String lastBackup(String when) {
    return 'শেষ ব্যাকআপ: $when';
  }

  @override
  String get lastBackupNever => 'এখনো কোনো ব্যাকআপ নেই';

  @override
  String get downloadFolder => 'Download/Linkbox';

  @override
  String get backupTitle => 'ব্যাকআপ';

  @override
  String backupBody(String folder) {
    return 'সব লিংক আর কালেকশন এই ফোনের $folder-এ সেভ করে।';
  }

  @override
  String get backupNow => 'এখনই ব্যাকআপ';

  @override
  String get restore => 'রিস্টোর';

  @override
  String get importTitle => 'ব্রাউজার থেকে ইমপোর্ট';

  @override
  String get importBody =>
      'Chrome, Firefox, Edge বা Brave-এ আপনার বুকমার্ক HTML ফাইল হিসেবে এক্সপোর্ট করুন। তারপর সেই ফাইলটি এখানে বাছুন।';

  @override
  String get chooseHtml => 'HTML ফাইল বাছুন';

  @override
  String get exportTitle => 'এক্সপোর্ট';

  @override
  String get exportBody =>
      'HTML যেকোনো ব্রাউজারে খোলে। JSON-এ সবকিছু থাকে, পরে আবার ইমপোর্ট করা যায়।';

  @override
  String get exportHtml => 'HTML এক্সপোর্ট';

  @override
  String get exportJson => 'JSON এক্সপোর্ট';

  @override
  String importDone(int imported, int skipped) {
    return '$importedটি লিংক ইমপোর্ট হয়েছে। আগে থেকে থাকা $skippedটি বাদ দেওয়া হয়েছে।';
  }

  @override
  String get importError =>
      'ফাইলটি পড়া গেল না। আপনার ব্রাউজারের এক্সপোর্ট করা .html ফাইলটি বাছুন।';

  @override
  String get backupFailed =>
      'ব্যাকআপ শেষ হয়নি। ফোনে কিছু জায়গা খালি করে আবার চেষ্টা করুন।';

  @override
  String get backupDone => 'ব্যাকআপ Download/Linkbox-এ সেভ হয়েছে';

  @override
  String exportDone(String name) {
    return 'Download/Linkbox/$name-এ সেভ হয়েছে';
  }

  @override
  String restorePick(String folder) {
    return '$folder থেকে একটি ব্যাকআপ বাছুন।';
  }

  @override
  String collectionCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি কালেকশন',
      one: '১টি কালেকশন',
    );
    return '$_temp0';
  }

  @override
  String restoreMeta(String links, String collections, String size) {
    return '$links · $collections · $size';
  }

  @override
  String get restoreHow => 'কীভাবে রিস্টোর করবেন?';

  @override
  String get restoreAdd => 'আমার লিংকের সাথে যোগ করুন';

  @override
  String get restoreAddSub => 'এখন যা আছে সব থাকবে। একই লিংক দুবার আসবে না।';

  @override
  String get restoreReplace => 'সব বদলে দিন';

  @override
  String restoreReplaceSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'আপনার বর্তমান $countটি লিংক আগে মুছে যাবে।',
      one: 'আপনার বর্তমান লিংকটি আগে মুছে যাবে।',
    );
    return '$_temp0';
  }

  @override
  String restoreButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লিংক রিস্টোর করুন',
      one: '১টি লিংক রিস্টোর করুন',
    );
    return '$_temp0';
  }

  @override
  String get restoreChooseFile => 'ব্যাকআপ ফাইল বাছুন';

  @override
  String get restoreNone =>
      'এখানে কোনো ব্যাকআপ পাওয়া যায়নি। অ্যাপ আবার ইনস্টল করে থাকলে ব্যাকআপ ফাইলটি নিজে বাছুন।';

  @override
  String get restoreError =>
      'এটি Linkbox-এর ব্যাকআপ নয়। linkbox-backup (.json) ফাইল বাছুন।';

  @override
  String restoreDone(int imported, int skipped) {
    return '$importedটি লিংক রিস্টোর হয়েছে। আগে থেকে থাকা $skippedটি বাদ দেওয়া হয়েছে।';
  }

  @override
  String get replaceConfirmTitle => 'সব বদলে দেবেন?';

  @override
  String get replaceConfirmBody =>
      'আপনার বর্তমান লিংক আর কালেকশন মুছে যাবে, তারপর ব্যাকআপ রিস্টোর হবে।';

  @override
  String get chosenFile => 'বাছাই করা ফাইল';
}
