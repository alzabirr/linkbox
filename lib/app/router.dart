import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/app_icon.dart';
import '../core/widgets/main_nav_bar.dart';
import '../features/collections/collection_detail_page.dart';
import '../features/collections/collections_page.dart';
import '../features/data/data_page.dart';
import '../features/data/restore_page.dart';
import '../features/dev/widget_gallery_page.dart';
import '../features/links/clipboard_prompt.dart';
import '../features/links/edit_link_page.dart';
import '../features/links/home_page.dart';
import '../features/links/links_providers.dart';
import '../features/links/search_page.dart';
import '../features/onboarding/onboarding_page.dart';
import '../features/settings/theme_settings.dart';
import '../features/links/undo_bar.dart';
import '../features/settings/about_page.dart';
import '../features/settings/settings_page.dart';
import '../features/settings/theme_color_page.dart';
import '../l10n/app_localizations.dart';

class Routes {
  Routes._();

  static const links = '/links';
  static const collections = '/collections';
  static const settings = '/settings';
  static const gallery = '/gallery';
  static const search = '/search';
  static const data = '/settings/data';
  static const restore = '/settings/data/restore';
  static const themeColor = '/settings/theme';
  static const about = '/settings/about';
  static const welcome = '/welcome';

  static String editLink(int id) => '/link/$id/edit';
  static String collection(int id) => '/collections/$id';
}

final appRouter = GoRouter(
  initialLocation: Routes.links,
  // First launch: show the intro (16–18) until it is finished.
  redirect: (context, state) {
    final done = ProviderScope.containerOf(
      context,
      listen: false,
    ).read(onboardingDoneProvider);
    if (!done && state.uri.path != Routes.welcome) return Routes.welcome;
    return null;
  },
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _TabShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.links,
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.collections,
              builder: (context, state) => const CollectionsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.settings,
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
    // linkbox://open/link/<id> (share overlay "Open saved link"):
    // Home opens that link's Quick look.
    GoRoute(
      path: '/link/:id',
      redirect: (context, state) => state.uri.path.endsWith('/edit')
          ? null
          : '${Routes.links}?open=${state.pathParameters['id']}',
      routes: [
        GoRoute(
          path: 'edit',
          builder: (context, state) =>
              EditLinkPage(linkId: int.parse(state.pathParameters['id']!)),
        ),
      ],
    ),
    GoRoute(
      path: Routes.welcome,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: Routes.themeColor,
      builder: (context, state) => const ThemeColorPage(),
    ),
    GoRoute(path: Routes.about, builder: (context, state) => const AboutPage()),
    GoRoute(
      path: Routes.data,
      builder: (context, state) => const DataPage(),
      routes: [
        GoRoute(
          path: 'restore',
          builder: (context, state) => const RestorePage(),
        ),
      ],
    ),
    GoRoute(
      path: Routes.search,
      builder: (context, state) => SearchPage(
        collectionId: int.tryParse(
          state.uri.queryParameters['collection'] ?? '',
        ),
      ),
    ),
    // Full-screen page (no bottom bar), like the mockup (19).
    GoRoute(
      path: '/collections/:id',
      builder: (context, state) => CollectionDetailPage(
        collectionId: int.parse(state.pathParameters['id']!),
      ),
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
      body: ClipboardPromptHost(
        child: Stack(
          children: [
            shell,
            const Positioned(left: 14, right: 16, bottom: 14, child: UndoBar()),
          ],
        ),
      ),
      bottomNavigationBar: MainNavBar(
        currentIndex: shell.currentIndex,
        onTap: (i) {
          // Leaving a tab ends multi-select.
          ProviderScope.containerOf(context)
              .read(selectionProvider.notifier)
              .clear();
          shell.goBranch(i, initialLocation: i == shell.currentIndex);
        },
        items: [
          NavItem(icon: AppIcons.link, label: l.navLinks),
          NavItem(icon: AppIcons.folder, label: l.navCollections),
          NavItem(icon: AppIcons.sliders, label: l.navSettings),
        ],
      ),
    );
  }
}
