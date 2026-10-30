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
}
