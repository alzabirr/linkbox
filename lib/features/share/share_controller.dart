import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/models/link_item.dart';
import '../../core/providers.dart';
import '../../core/repositories/link_repository.dart';
import '../../core/services/share_channel.dart';
import '../../core/utils/url_normalizer.dart';

part 'share_controller.g.dart';

sealed class ShareState {
  const ShareState();
}

class ShareLoading extends ShareState {
  const ShareLoading();
}

/// Nothing link-like in the shared text.
class ShareNoLink extends ShareState {
  const ShareNoLink();
}

/// "Saved!" (22).
@immutable
class ShareSaved extends ShareState {
  const ShareSaved(this.link);
  final LinkItem link;
}

/// "You already saved this one" (07).
@immutable
class ShareDuplicate extends ShareState {
  const ShareDuplicate(this.existing, this.url, this.subject);
  final LinkItem existing;
  final String url;
  final String? subject;
}

@Riverpod(keepAlive: true)
ShareChannel shareChannel(Ref ref) => const ShareChannel();

/// Share flow (BUILD_SPEC 4): extract → duplicate check → save → preview.
@Riverpod(keepAlive: true)
class ShareController extends _$ShareController {
  @override
  ShareState build() {
    _start();
    return const ShareLoading();
  }

  LinkRepository get _repo => ref.read(linkRepositoryProvider);

  Future<void> _start() async {
    final shared = await ref.read(shareChannelProvider).getShared();
    final url = UrlUtils.extractFirst(shared.text ?? '') ??
        UrlUtils.extractFirst(shared.subject ?? '');
    if (url == null) {
      state = const ShareNoLink();
      return;
    }
    final existing = await _repo.findByUrl(url);
    if (existing != null) {
      state = ShareDuplicate(existing, url, shared.subject);
      return;
    }
    await _save(url, shared.subject, allowDuplicate: false);
  }

  Future<void> _save(String url, String? subject,
      {required bool allowDuplicate}) async {
    final id = await _repo.add(url,
        title: subject, allowDuplicate: allowDuplicate);
    final link = await _repo.findById(id);
    if (link != null) state = ShareSaved(link);
  }

  Future<void> saveCopy() async {
    final s = state;
    if (s is ShareDuplicate) {
      await _save(s.url, s.subject, allowDuplicate: true);
    }
  }

  /// Re-read the link after "Change collection".
  Future<void> refresh() async {
    final s = state;
    if (s is! ShareSaved) return;
    final link = await _repo.findById(s.link.id);
    if (link != null) state = ShareSaved(link);
  }
}
