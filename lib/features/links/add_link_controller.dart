import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers.dart';
import '../../core/repositories/link_repository.dart';
import '../../core/services/metadata_parser.dart';
import '../../core/services/metadata_service.dart';
import '../../core/utils/debouncer.dart';
import '../../core/utils/url_normalizer.dart';

part 'add_link_controller.g.dart';

enum AddLinkStatus { empty, invalid, duplicate, loading, found, failed, offline }

@immutable
class AddLinkState {
  const AddLinkState({
    this.url = '',
    this.status = AddLinkStatus.empty,
    this.meta,
    this.collectionId,
    this.saving = false,
  });

  final String url;
  final AddLinkStatus status;
  final LinkMetadata? meta;
  final int? collectionId;
  final bool saving;

  bool get canSave =>
      !saving &&
      status != AddLinkStatus.empty &&
      status != AddLinkStatus.invalid &&
      status != AddLinkStatus.duplicate;

  bool get showPreview =>
      status == AddLinkStatus.loading ||
      status == AddLinkStatus.found ||
      status == AddLinkStatus.failed ||
      status == AddLinkStatus.offline;

  String get domain => UrlUtils.domainOf(url);

  AddLinkState copyWith({
    String? url,
    AddLinkStatus? status,
    LinkMetadata? meta,
    bool clearMeta = false,
    int? collectionId,
    bool clearCollection = false,
    bool? saving,
  }) =>
      AddLinkState(
        url: url ?? this.url,
        status: status ?? this.status,
        meta: clearMeta ? null : (meta ?? this.meta),
        collectionId:
            clearCollection ? null : (collectionId ?? this.collectionId),
        saving: saving ?? this.saving,
      );
}

/// State of the Add link sheet (06): validation, live preview, collection.
@riverpod
class AddLinkController extends _$AddLinkController {
  final _debounce = Debouncer(const Duration(milliseconds: 500));
  var _request = 0;

  @override
  AddLinkState build(int? initialCollectionId) {
    ref.onDispose(_debounce.cancel);
    return AddLinkState(collectionId: initialCollectionId);
  }

  void setUrl(String input) {
    // Drop invisible control characters some keyboards insert.
    final url = input.replaceAll(RegExp(r'[\u0000-\u001F\u007F-\u009F\u200B-\u200D\uFEFF]'), '').trim();
    _request++;
    _debounce.cancel();
    if (url.isEmpty) {
      state = state.copyWith(url: '', status: AddLinkStatus.empty, clearMeta: true);
      return;
    }
    if (!UrlUtils.isValid(url)) {
      state = state.copyWith(url: url, status: AddLinkStatus.invalid, clearMeta: true);
      return;
    }
    state = state.copyWith(url: url, status: AddLinkStatus.loading, clearMeta: true);
    final request = _request;
    _debounce(() => _check(url, request));
  }

  Future<void> _check(String url, int request) async {
    final repo = ref.read(linkRepositoryProvider);
    if (await repo.findByUrl(url) != null) {
      if (request == _request) {
        state = state.copyWith(status: AddLinkStatus.duplicate);
      }
      return;
    }
    try {
      final meta = await ref.read(metadataServiceProvider).fetch(url);
      if (request != _request) return;
      state = state.copyWith(status: AddLinkStatus.found, meta: meta);
    } on MetadataException catch (e) {
      if (request != _request) return;
      state = state.copyWith(
          status: e.offline ? AddLinkStatus.offline : AddLinkStatus.failed);
    }
  }

  void selectCollection(int? id) => state =
      id == null ? state.copyWith(clearCollection: true) : state.copyWith(collectionId: id);

  /// Saves the link. Returns false when it was already saved.
  Future<bool> save() async {
    if (!state.canSave) return false;
    state = state.copyWith(saving: true);
    try {
      await ref.read(linkRepositoryProvider).add(
            state.url,
            collectionId: state.collectionId,
            meta: state.status == AddLinkStatus.found ? state.meta : null,
          );
      return true;
    } on DuplicateLinkException {
      state = state.copyWith(status: AddLinkStatus.duplicate, saving: false);
      return false;
    }
  }
}
