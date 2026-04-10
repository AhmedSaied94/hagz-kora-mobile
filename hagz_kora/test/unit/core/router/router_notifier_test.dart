import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hagz_kora/core/router/app_routes.dart';
import 'package:hagz_kora/core/router/router_notifier.dart';
import 'package:mocktail/mocktail.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

GoRouterState _stateAt(String location) {
  final state = _MockGoRouterState();
  when(() => state.matchedLocation).thenReturn(location);
  return state;
}

/// Builds a [RouterNotifier] from a fresh [ProviderContainer].
///
/// The container is registered for disposal via [addTearDown], so this must
/// only be called from within a [test] or [setUp] body.
RouterNotifier _buildNotifier({bool authenticated = false}) {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  final notifier = container.read(routerNotifierProvider.notifier);
  if (authenticated) {
    notifier.setAuthenticated(value: true);
  }
  return notifier;
}

void main() {
  setUpAll(() => registerFallbackValue(_MockGoRouterState()));

  group('RouterNotifier.redirect — unauthenticated user', () {
    late RouterNotifier notifier;

    setUp(() => notifier = _buildNotifier());

    test('redirects to authPhone when accessing a protected route', () {
      final result = notifier.redirect(_stateAt(AppRoutes.homeFeed));
      expect(result, AppRoutes.authPhone);
    });

    test('redirects to authPhone for any non-auth route', () {
      expect(notifier.redirect(_stateAt(AppRoutes.myBookings)), AppRoutes.authPhone);
      expect(notifier.redirect(_stateAt(AppRoutes.profile)), AppRoutes.authPhone);
      expect(notifier.redirect(_stateAt(AppRoutes.search)), AppRoutes.authPhone);
    });

    test('allows splash through without redirect', () {
      expect(notifier.redirect(_stateAt(AppRoutes.splash)), isNull);
    });

    test('allows /auth/phone through without redirect', () {
      expect(notifier.redirect(_stateAt(AppRoutes.authPhone)), isNull);
    });

    test('allows /auth/otp through without redirect', () {
      expect(notifier.redirect(_stateAt(AppRoutes.authOtp)), isNull);
    });
  });

  group('RouterNotifier.redirect — authenticated user', () {
    late RouterNotifier notifier;

    setUp(() => notifier = _buildNotifier(authenticated: true));

    test('redirects away from authPhone to homeFeed', () {
      expect(
        notifier.redirect(_stateAt(AppRoutes.authPhone)),
        AppRoutes.homeFeed,
      );
    });

    test('redirects away from authOtp to homeFeed', () {
      expect(
        notifier.redirect(_stateAt(AppRoutes.authOtp)),
        AppRoutes.homeFeed,
      );
    });

    test('does not redirect from splash', () {
      expect(notifier.redirect(_stateAt(AppRoutes.splash)), isNull);
    });

    test('allows protected routes through', () {
      expect(notifier.redirect(_stateAt(AppRoutes.homeFeed)), isNull);
      expect(notifier.redirect(_stateAt(AppRoutes.profile)), isNull);
    });
  });

  group('RouterNotifier.setAuthenticated', () {
    test('notifies listeners when state changes', () {
      final notifier = _buildNotifier();
      var callCount = 0;
      notifier.addListener(() => callCount++);

      notifier.setAuthenticated(value: true);
      expect(callCount, 1);
    });

    test('does not notify when state is unchanged', () {
      final notifier = _buildNotifier(authenticated: true);
      var callCount = 0;
      notifier.addListener(() => callCount++);

      notifier.setAuthenticated(value: true); // same value
      expect(callCount, 0);
    });

    test('hasListeners reflects added listeners', () {
      final notifier = _buildNotifier();
      expect(notifier.hasListeners, isFalse);
      notifier.addListener(() {});
      expect(notifier.hasListeners, isTrue);
    });

    test('removeListener stops notifications', () {
      final notifier = _buildNotifier();
      var callCount = 0;
      void listener() => callCount++;

      notifier.addListener(listener);
      notifier.setAuthenticated(value: true);
      expect(callCount, 1);

      notifier.removeListener(listener);
      notifier.setAuthenticated(value: false);
      expect(callCount, 1); // unchanged
    });
  });
}
