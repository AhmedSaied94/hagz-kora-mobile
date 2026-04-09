import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hagz_kora/core/router/app_routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_notifier.g.dart';

/// Bridge between Riverpod auth state and go_router's [refreshListenable].
///
/// Implements [Listenable] so go_router re-evaluates [redirect] whenever
/// the auth state changes. Replace [_isAuthenticated] stub with real
/// auth provider in Phase 1.
@riverpod
class RouterNotifier extends _$RouterNotifier implements ChangeNotifier {
  final _listeners = ObserverList<VoidCallback>();

  // Auth state stub — Phase 1 replaces this with real provider.
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  /// Called by the auth provider when the user signs in/out.
  void setAuthenticated({required bool value}) {
    if (_isAuthenticated == value) return;
    _isAuthenticated = value;
    notifyListeners();
  }

  @override
  void build() {
    // Watch auth state in Phase 1:
    // final authState = ref.watch(authStateProvider);
    // _isAuthenticated = authState.isAuthenticated;
  }

  String? redirect(GoRouterState state) {
    final location = state.matchedLocation;
    final isOnAuth = location.startsWith('/auth') || location == AppRoutes.splash;

    if (!_isAuthenticated && !isOnAuth) {
      return AppRoutes.authPhone;
    }
    if (_isAuthenticated && isOnAuth && location != AppRoutes.splash) {
      return AppRoutes.homeFeed;
    }
    return null;
  }

  // --- ChangeNotifier implementation ---

  @override
  void addListener(VoidCallback listener) => _listeners.add(listener);

  @override
  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  @override
  void notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  @override
  bool get hasListeners => _listeners.isNotEmpty;

  @override
  void dispose() {}
}
