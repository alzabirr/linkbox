import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/models/link_item.dart';
import '../../core/services/link_opener.dart';
import '../../l10n/app_localizations.dart';
import '../settings/theme_settings.dart';
import 'delete_dialog.dart';
import 'links_providers.dart';
import 'quick_look_sheet.dart';

/// Actions shared by Quick look (04) and the link menu (21).
class LinkActions {
  LinkActions._();

  static Future<void> open(BuildContext context, LinkItem link) async {
    final ok = await openLink(link.url);
    if (!ok && context.mounted) {
      _toast(context, AppLocalizations.of(context).couldNotOpen);
    }
  }

  /// Copies the link. With [toast], also says "Link copied" (the link
  /// menu closes, so it needs a message; Quick look changes its button).
  static Future<void> copy(BuildContext context, LinkItem link,
      {bool toast = true}) async {
    await Clipboard.setData(ClipboardData(text: link.url));
    if (toast && context.mounted) {
      _toast(context, AppLocalizations.of(context).linkCopied);
    }
  }

  /// Tapping a link: Quick look, open the site, or copy (Settings, 13).
  static Future<void> tap(
      BuildContext context, WidgetRef ref, LinkItem link) async {
    switch (ref.read(tapActionSettingProvider)) {
      case TapAction.quickLook:
        await showQuickLook(context, link.id);
      case TapAction.open:
        await open(context, link);
      case TapAction.copy:
        await copy(context, link);
    }
  }

  static Future<void> share(LinkItem link) =>
      SharePlus.instance.share(ShareParams(text: link.url, subject: link.title));

  /// Asks first (11), then soft-deletes with Undo (29).
  static Future<bool> delete(
      BuildContext context, UndoDelete undo, List<int> ids) async {
    final ok = await showDeleteDialog(context, count: ids.length);
    if (ok) await undo.delete(ids);
    return ok;
  }

  static void _toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }
}

/// "Saved today", "Saved 2 days ago", "Saved on 12 Oct".
String savedAgo(BuildContext context, DateTime createdUtc) {
  final l = AppLocalizations.of(context);
  final local = createdUtc.toLocal();
  final now = DateTime.now();
  final days = DateTime(now.year, now.month, now.day)
      .difference(DateTime(local.year, local.month, local.day))
      .inDays;
  if (days <= 0) return l.savedToday;
  if (days == 1) return l.savedYesterday;
  if (days < 7) return l.savedDaysAgo(days);
  final locale = Localizations.localeOf(context).toString();
  return l.savedOnDate(DateFormat('d MMM', locale).format(local));
}

/// "today", "yesterday", "3 days ago", "last week", "3 weeks ago", or a date.
String relativeDay(BuildContext context, DateTime? utc) {
  final l = AppLocalizations.of(context);
  if (utc == null) return l.whenNever;
  final local = utc.toLocal();
  final now = DateTime.now();
  final days = DateTime(now.year, now.month, now.day)
      .difference(DateTime(local.year, local.month, local.day))
      .inDays;
  if (days <= 0) return l.whenToday;
  if (days == 1) return l.whenYesterday;
  if (days < 7) return l.whenDaysAgo(days);
  if (days < 14) return l.whenLastWeek;
  if (days < 35) return l.whenWeeksAgo(days ~/ 7);
  final locale = Localizations.localeOf(context).toString();
  return DateFormat('d MMM', locale).format(local);
}
