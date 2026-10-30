import 'package:flutter/material.dart';

import '../../core/widgets/coming_soon.dart';
import '../../core/widgets/page_header.dart';
import '../../l10n/app_localizations.dart';

/// Collections tab (12). Filled in M4.
class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeader(title: l.collectionsTitle),
          const Expanded(child: ComingSoon(milestone: 'M4')),
        ],
      ),
    );
  }
}
