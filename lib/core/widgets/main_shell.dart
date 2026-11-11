import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/account/cloud_controller.dart';
import '../l10n/localization.dart';
import 'profile_avatar.dart';

/// Bottom tabs: Today, Calendar, Learn, Help. Each tab keeps its own scroll
/// position through the indexed stack.
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
    final accountIcon = cloud.signedIn
        ? ProfileAvatar(photoUrl: cloud.photoUrl, name: name, radius: 12)
        : const Icon(Icons.account_circle_outlined);
    final accountSelected = cloud.signedIn
        ? ProfileAvatar(photoUrl: cloud.photoUrl, name: name, radius: 12)
        : const Icon(Icons.account_circle);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.circle_outlined),
            selectedIcon: const Icon(Icons.circle),
            label: l.todayTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: l.calendarTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l.learnTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.place_outlined),
            selectedIcon: const Icon(Icons.place),
            label: l.helpTab,
          ),
          NavigationDestination(
            icon: accountIcon,
            selectedIcon: accountSelected,
            label: cloud.signedIn && shortName.isNotEmpty ? shortName : l.navAccount,
          ),
        ],
      ),
    );
  }
}
