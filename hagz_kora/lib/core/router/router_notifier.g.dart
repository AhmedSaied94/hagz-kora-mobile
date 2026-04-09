// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routerNotifierHash() => r'c4adbdfedbdd454522841324ba7ce56a61c4a076';

/// Bridge between Riverpod auth state and go_router's [refreshListenable].
///
/// Implements [Listenable] so go_router re-evaluates [redirect] whenever
/// the auth state changes. Replace [_isAuthenticated] stub with real
/// auth provider in Phase 1.
///
/// Copied from [RouterNotifier].
@ProviderFor(RouterNotifier)
final routerNotifierProvider =
    AutoDisposeNotifierProvider<RouterNotifier, void>.internal(
      RouterNotifier.new,
      name: r'routerNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$routerNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RouterNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
