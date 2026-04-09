# Phase 0 — Project Foundation & Architecture

**Duration:** Week 1–2  
**Priority:** P0 (launch blocker)

**Goal:** A runnable Flutter project with clean architecture scaffold, flavors, networking layer, secure storage, routing, and theming in place. Every future phase plugs into this foundation.

---

## 0.1 Flutter Project Setup

```bash
flutter create hagz_kora --org com.hagzkora --platforms android,ios
```

- Remove default counter app
- Set minimum SDK: Android `minSdk 26` (Android 8.0), iOS deployment target `15.0`
- Enable null safety (Dart 3.x — enabled by default)

---

## 0.2 Build Flavors

Two flavors, controlled by `--dart-define` or flavor configuration:

| Flavor | Auth Mode | API Base URL | Notes |
|--------|-----------|-------------|-------|
| `development` | Email + password | `http://10.0.2.2:8000/api/v1/` (emulator) | Dev/staging backend |
| `production` | Phone OTP | `https://api.hagzkora.com/api/v1/` | Live backend |

- Use `flutter_flavorizr` or manual flavor setup with separate `main_dev.dart` / `main_prod.dart` entry points
- `AppConfig` singleton injected at startup with flavor-specific values

---

## 0.3 Package Dependencies

```yaml
dependencies:
  # State management
  flutter_riverpod: ^2.x
  riverpod_annotation: ^2.x

  # Navigation
  go_router: ^14.x

  # Networking
  dio: ^5.x
  retrofit: ^4.x

  # Serialization
  freezed_annotation: ^2.x
  json_annotation: ^4.x

  # Secure storage
  flutter_secure_storage: ^9.x

  # Local DB (caching)
  hive_flutter: ^1.x

  # Maps
  google_maps_flutter: ^2.x

  # Push notifications
  firebase_messaging: ^15.x
  firebase_core: ^3.x

  # Image loading
  cached_network_image: ^3.x

  # Internationalization
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.x

  # Deep links / URL launcher
  url_launcher: ^6.x

  # Photo carousel
  carousel_slider: ^5.x

  # Misc utils
  equatable: ^2.x
  dartz: ^0.10.x  # Either type for error handling

dev_dependencies:
  build_runner: ^2.x
  riverpod_generator: ^2.x
  retrofit_generator: ^8.x
  freezed: ^2.x
  json_serializable: ^6.x
  flutter_lints: ^4.x
  mocktail: ^1.x
```

---

## 0.4 Clean Architecture Scaffold

Feature-first structure. Each feature follows the same three-layer pattern:

```
lib/
  features/
    auth/
      data/
        datasources/    # remote_datasource.dart (Retrofit client)
        models/         # DTOs with @freezed + @JsonSerializable
        repositories/   # AuthRepositoryImpl
      domain/
        entities/       # Pure Dart classes (no JSON)
        repositories/   # AuthRepository (abstract)
        usecases/       # RequestOtp, VerifyOtp, Logout, ...
      presentation/
        screens/        # PhoneScreen, OtpScreen
        widgets/        # Feature-specific widgets
        providers/      # Riverpod providers / notifiers
    stadiums/
    bookings/
    tournaments/
    reviews/
    profile/
  core/
    network/
      dio_client.dart         # Base Dio instance + interceptors
      auth_interceptor.dart   # Attaches Bearer token; handles 401 refresh
      error_handler.dart      # Maps DioException → domain Failure
    storage/
      secure_storage.dart     # flutter_secure_storage wrapper
      hive_service.dart       # Hive initialization + box accessors
    router/
      app_router.dart         # go_router configuration
      route_guards.dart       # Auth guard, redirect logic
    l10n/
      app_en.arb
      app_ar.arb
    theme/
      app_theme.dart          # ThemeData light/dark
      app_colors.dart         # Color constants (no hex hardcoding elsewhere)
      app_text_styles.dart
    widgets/
      app_button.dart
      app_text_field.dart
      stadium_card.dart
      loading_overlay.dart
      error_view.dart
```

---

## 0.5 Networking Layer (Dio + Retrofit)

**`DioClient`** — single instance, configured at startup:
- `BaseOptions`: base URL from `AppConfig`, connection timeout 30s, receive timeout 30s
- Interceptors (in order):
  1. `AuthInterceptor` — adds `Authorization: Bearer <token>` header; on 401, calls refresh endpoint, retries original request once
  2. `LoggingInterceptor` — debug flavor only
  3. `ErrorHandlingInterceptor` — converts `DioException` to domain `Failure` types

**Token refresh flow (AuthInterceptor):**
1. On 401 response, read refresh token from `flutter_secure_storage`
2. Call `POST /api/auth/token/refresh/` directly (no interceptor on this call)
3. On success: store new access token, retry original request
4. On failure (refresh expired): clear tokens → redirect to auth screen

---

## 0.6 Secure Token Storage

```dart
// core/storage/secure_storage.dart
class SecureStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  Future<void> saveTokens({required String access, required String refresh});
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
}
```

Never use `SharedPreferences` for tokens.

---

## 0.7 Routing (go_router)

- `ShellRoute` for bottom navigation (Home, Search, Bookings, Tournaments, Profile)
- Auth guard: redirect unauthenticated users to `/auth/phone`
- Deep link support for tournament share URLs (`/tournaments/:id`)

---

## 0.8 Theming & Localization Foundation

- `AppTheme.light()` and `AppTheme.dark()` — no hardcoded hex values in widgets
- `MaterialApp.router` with `localizationsDelegates` and `supportedLocales: [ar, en]`
- `Directionality` driven by locale — Arabic triggers RTL automatically
- ARB files: `app_en.arb` and `app_ar.arb` — all user-facing strings externalized from day one

---

## 0.9 CI Pipeline

- GitHub Actions: `flutter analyze` → `flutter test` → `flutter build apk --flavor development`
- Linting: `flutter_lints` package enforced in CI

---

## Deliverable

`flutter run --flavor development -t lib/main_dev.dart` runs the app on emulator/device.  
Clean architecture scaffold in place. Dio client, secure storage, routing, and theming all wired up.  
No placeholder screens needed — foundation only.
