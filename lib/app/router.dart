import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/app_icon.dart';
import '../core/widgets/main_nav_bar.dart';
import '../features/collections/collections_page.dart';
import '../features/dev/widget_gallery_page.dart';
import '../features/links/home_page.dart';
import '../features/settings/settings_page.dart';
import '../l10n/app_localizations.dart';

class Routes {
  Routes._();

  static const links = '/links';
  static const collections = '/collections';
  static const settings = '/settings';
  static const gallery = '/gallery';
}

final appRouter = GoRouter(
  initialLocation: Routes.links,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _TabShell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: Routes.links,
            builder: (context, state) => const HomePage(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: Routes.collections,
            builder: (context, state) => const CollectionsPage(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: Routes.settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ]),
      ],
    ),
    GoRoute(
      path: Routes.gallery,
      builder: (context, state) => const WidgetGalleryPage(),
    ),
  ],
);

/// Scaffold with the 3-tab bottom bar.
class _TabShell extends StatelessWidget {
  const _TabShell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: shell,
      bottomNavigationBar: MainNavBar(
        currentIndex: shell.currentIndex,
        onTap: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        items: [
          NavItem(icon: AppIcons.link, label: l.navLinks),
          NavItem(icon: AppIcons.folder, label: l.navCollections),
          NavItem(icon: AppIcons.sliders, label: l.navSettings),
        ],
      ),
    );
  }
}
