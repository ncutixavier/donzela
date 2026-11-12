import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/account/account_screen.dart';
import '../../features/calendar/calendar_screen.dart';
import '../../features/help/help_screen.dart';
import '../../features/learn/learn_screen.dart';
import '../../features/lock/lock_controller.dart';
import '../../features/lock/lock_screen.dart';
import '../../features/logs/logs_screen.dart';
import '../../features/health/health_tools_screen.dart';
import '../../features/onboarding/onboarding_screens.dart';
import '../../features/report/report_screen.dart';
import '../../features/settings/privacy_screen.dart';
import '../../features/settings/settings_controller.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/today/today_screen.dart';
import '../widgets/main_shell.dart';
import 'transitions.dart';

/// Every route in the app (plan: core/router.dart). The redirect listens to
/// settings and the lock, so onboarding and PIN changes take effect at once.
GoRouter buildRouter({
  required SettingsController settings,
  required LockController lock,
}) {
  String? redirect(BuildContext context, GoRouterState state) {
    final loc = state.matchedLocation;
    final s = settings.settings;
    final onOnboarding = loc.startsWith('/onboarding');

    if (!s.onboardingDone) {
      if (onOnboarding) return null;
      return '/onboarding/${s.onboardingStep.clamp(1, 5)}';
    }
    if (onOnboarding) return '/today';

    if (s.pinOn && lock.locked) {
      return loc == '/lock' ? null : '/lock';
    }
    if (loc == '/lock') return '/today';
    return null;
  }

  return GoRouter(
    initialLocation: '/today',
    refreshListenable: Listenable.merge([settings, lock]),
    redirect: redirect,
    routes: [
      GoRoute(
        path: '/onboarding/:step',
        pageBuilder: (context, state) => sharedAxisPage(
          key: state.pageKey,
          child: OnboardingStepScreen(
            step: int.tryParse(state.pathParameters['step'] ?? '') ?? 1,
          ),
        ),
      ),
      GoRoute(
        path: '/lock',
        pageBuilder: (context, state) => simpleFadePage(
          key: state.pageKey,
          child: const LockScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/today', builder: (c, s) => const TodayScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/calendar', builder: (c, s) => const CalendarScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/learn', builder: (c, s) => const LearnScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/help', builder: (c, s) => const HelpScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/account', builder: (c, s) => const AccountScreen()),
          ]),
        ],
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => sharedAxisPage(
          key: state.pageKey,
          child: const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: '/privacy',
        pageBuilder: (context, state) => sharedAxisPage(
          key: state.pageKey,
          child: const PrivacyScreen(),
        ),
      ),
      GoRoute(
        path: '/logs',
        pageBuilder: (context, state) => sharedAxisPage(
          key: state.pageKey,
          child: const LogsScreen(),
        ),
      ),
      GoRoute(
        path: '/health',
        pageBuilder: (context, state) => sharedAxisPage(
          key: state.pageKey,
          child: const HealthToolsScreen(),
        ),
      ),
      GoRoute(
        path: '/report',
        pageBuilder: (context, state) => sharedAxisPage(
          key: state.pageKey,
          child: const ReportScreen(),
        ),
      ),
    ],
  );
}
