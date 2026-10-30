import 'package:flutter/material.dart';

import '../../core/widgets/app_icon.dart';
import '../../core/widgets/bold_button.dart';
import '../../core/widgets/bold_chip.dart';
import '../../core/widgets/bold_search_field.dart';
import '../../core/widgets/coming_soon.dart';
import '../../core/widgets/icon_box.dart';
import '../../core/widgets/page_header.dart';
import '../../l10n/app_localizations.dart';

/// Links tab (01). M0 shows only the frame; links arrive in M1.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageHeader(
                title: l.homeTitle,
                actions: [
                  IconBox(
                      icon: AppIcons.sort,
                      tooltip: l.sortTooltip,
                      onPressed: () {}),
                  IconBox(
                    icon: AppIcons.list,
                    tooltip: l.switchToList,
                    kind: IconBoxKind.sun,
                    onPressed: () {},
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: BoldSearchField(
                  hint: l.searchHint,
                  clearLabel: l.clearSearch,
                  readOnly: true,
                ),
              ),
              Padding(
                // 14 / 4 in the mockup, minus the chip's 3 px touch padding.
                padding: const EdgeInsets.fromLTRB(16, 11, 16, 1),
                child: Row(
                  children: [
                    BoldChip(label: l.chipAll, selected: true, onTap: () {}),
                  ],
                ),
              ),
              const Expanded(child: ComingSoon(milestone: 'M1')),
            ],
          ),
          Positioned(
            right: 18,
            bottom: 18,
            child: BoldButton(
              label: l.addLink,
              icon: AppIcons.plus,
              size: BoldButtonSize.fab,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
