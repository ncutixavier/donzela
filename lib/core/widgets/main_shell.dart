import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/account/cloud_controller.dart';
import '../l10n/localization.dart';
import 'profile_avatar.dart';

/// Widest the content gets on a large screen, so text lines stay readable.
const maxContentWidth = 900.0;

/// Bottom tabs on every screen size: Today, Calendar, Learn, Help, Account. Each tab keeps its own scroll position through the indexed stack.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // The fifth tab shows the signed-in person's photo and first name.
    final cloud = context.watch<CloudController>();
    final name = cloud.displayName ?? cloud.email ?? '';
    // The tab label is at most five characters, so long names stay short.
    final firstName = name.trim().split(' ').first;
    final shortName = firstName.length > 5 ? firstName.substring(0, 5) : firstName;
    final accountLabel = cloud.signedIn && shortName.isNotEmpty ? shortName : l.navAccount;

    final destinations = <_Tab>[
      _Tab(const Icon(Icons.circle_outlined), const Icon(Icons.circle), l.todayTitle),
      _Tab(const Icon(Icons.calendar_month_outlined), const Icon(Icons.calendar_month), l.calendarTab),
      _Tab(const Icon(Icons.menu_book_outlined), const Icon(Icons.menu_book), l.learnTab),
      _Tab(const Icon(Icons.place_outlined), const Icon(Icons.place), l.helpTab),
      _Tab(
        cloud.signedIn
            ? ProfileAvatar(photoUrl: cloud.photoUrl, name: name, radius: 12)
            : const Icon(Icons.account_circle_outlined),
        cloud.signedIn
            ? ProfileAvatar(photoUrl: cloud.photoUrl, name: name, radius: 12)
            : const Icon(Icons.account_circle),
        accountLabel,
      ),
    ];

    void select(int i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        );

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: select,
        destinations: [
          for (final t in destinations)
            NavigationDestination(icon: t.icon, selectedIcon: t.selectedIcon, label: t.label),
        ],
      ),
    );
  }
}

class _Tab {
  const _Tab(this.icon, this.selectedIcon, this.label);

  final Widget icon;
  final Widget selectedIcon;
  final String label;
}
