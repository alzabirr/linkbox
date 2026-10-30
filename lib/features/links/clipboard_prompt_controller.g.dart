// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clipboard_prompt_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The link offered in "Save the link you copied?" (02), or null.

@ProviderFor(ClipboardPrompt)
final clipboardPromptProvider = ClipboardPromptProvider._();

/// The link offered in "Save the link you copied?" (02), or null.
final class ClipboardPromptProvider
    extends $NotifierProvider<ClipboardPrompt, String?> {
  /// The link offered in "Save the link you copied?" (02), or null.
  ClipboardPromptProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clipboardPromptProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clipboardPromptHash();

  @$internal
  @override
  ClipboardPrompt create() => ClipboardPrompt();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$clipboardPromptHash() => r'21fc11179726107ebc301d989e423bf27e293ac8';

/// The link offered in "Save the link you copied?" (02), or null.

abstract class _$ClipboardPrompt extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
