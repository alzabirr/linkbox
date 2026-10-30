import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/models/link_item.dart';
import '../../core/services/link_opener.dart';
import '../../l10n/app_localizations.dart';
import 'delete_dialog.dart';
import 'links_providers.dart';

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
