import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import '../../app/theme/typography.dart';
import 'app_icon.dart';

class NavItem {
  const NavItem({required this.icon, required this.label});

  final AppIconData icon;
  final String label;
}

/// Bottom bar with 3 tabs. The active tab gets a 60 × 32 sun pill.
class MainNavBar extends StatelessWidget {
  const MainNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      height: AppSizes.navHeight + bottom,
      padding: EdgeInsets.only(bottom: bottom),
      decoration: BoxDecoration(
        color: t.isDark ? t.background : t.surface,
        border: Border(
          top: BorderSide(color: t.outline, width: AppShape.stroke),
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: _NavButton(
                item: items[i],
                active: i == currentIndex,
                onTap: () => onTap(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final NavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final duration = AppMotion.reduce(context)
        ? AppMotion.reduced
        : AppMotion.select;
    return Semantics(
      button: true,
      selected: active,
      label: item.label,
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: duration,
              width: AppSizes.navPillW,
              height: AppSizes.navPillH,
              decoration: BoxDecoration(
                color: active ? AppColors.sun : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSizes.navPillH / 2),
                border: Border.all(
                  color: active && !t.isDark ? t.outline : Colors.transparent,
                  width: AppShape.strokeThin,
                ),
              ),
              child: Center(
                child: AppIcon(
                  item.icon,
                  size: active ? 20 : 22,
                  strokeWidth: active ? 2.4 : 2.2,
                  color: active ? AppColors.ink : t.muted,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              maxLines: 1,
              style: AppText.body(
                12,
                weight: active ? FontWeight.w700 : FontWeight.w600,
                color: active ? t.text : t.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
