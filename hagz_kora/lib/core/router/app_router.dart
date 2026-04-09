import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hagz_kora/core/router/app_routes.dart';
import 'package:hagz_kora/core/router/router_notifier.dart';
import 'package:hagz_kora/core/widgets/placeholder_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final notifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    redirect: (context, state) => notifier.redirect(state),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) =>
            const PlaceholderScreen(label: 'Splash'),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) =>
            const PlaceholderScreen(label: 'Onboarding'),
      ),
      GoRoute(
        path: AppRoutes.authPhone,
        builder: (context, state) =>
            const PlaceholderScreen(label: 'Phone Entry'),
      ),
      GoRoute(
        path: AppRoutes.authOtp,
        builder: (context, state) =>
            const PlaceholderScreen(label: 'OTP Verify'),
      ),
      ShellRoute(
        builder: (context, state, child) => _AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.homeFeed,
            builder: (context, state) =>
                const PlaceholderScreen(label: 'Home Feed'),
          ),
          GoRoute(
            path: AppRoutes.search,
            builder: (context, state) =>
                const PlaceholderScreen(label: 'Search'),
            routes: [
              GoRoute(
                path: 'results',
                builder: (context, state) =>
                    const PlaceholderScreen(label: 'Search Results'),
              ),
            ],
          ),
          GoRoute(
            path: '/stadiums/:id',
            builder: (context, state) => PlaceholderScreen(
              label: 'Stadium ${state.pathParameters['id']}',
            ),
            routes: [
              GoRoute(
                path: 'book/:slotId',
                builder: (context, state) => PlaceholderScreen(
                  label: 'Book slot ${state.pathParameters['slotId']}',
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.myBookings,
            builder: (context, state) =>
                const PlaceholderScreen(label: 'My Bookings'),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => PlaceholderScreen(
                  label: 'Booking ${state.pathParameters['id']}',
                ),
                routes: [
                  GoRoute(
                    path: 'confirmation',
                    builder: (context, state) =>
                        const PlaceholderScreen(label: 'Booking Confirmation'),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.tournaments,
            builder: (context, state) =>
                const PlaceholderScreen(label: 'Tournaments'),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => PlaceholderScreen(
                  label: 'Tournament ${state.pathParameters['id']}',
                ),
                routes: [
                  GoRoute(
                    path: 'my-team',
                    builder: (context, state) =>
                        const PlaceholderScreen(label: 'My Team'),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) =>
                const PlaceholderScreen(label: 'Profile'),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) =>
                    const PlaceholderScreen(label: 'Edit Profile'),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _AppShell extends StatelessWidget {
  const _AppShell({required this.child});

  final Widget child;

  static const _tabs = [
    (icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', path: AppRoutes.homeFeed),
    (icon: Icons.search_outlined, activeIcon: Icons.search, label: 'Search', path: AppRoutes.search),
    (icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_today, label: 'Bookings', path: AppRoutes.myBookings),
    (icon: Icons.emoji_events_outlined, activeIcon: Icons.emoji_events, label: 'Tournaments', path: AppRoutes.tournaments),
    (icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile', path: AppRoutes.profile),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _tabs.indexWhere((t) => location.startsWith(t.path));

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex < 0 ? 0 : currentIndex,
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        destinations: _tabs
            .map(
              (t) => NavigationDestination(
                icon: Icon(t.icon),
                selectedIcon: Icon(t.activeIcon),
                label: t.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
