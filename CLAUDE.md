# Hagz Kora — Mobile App (Flutter)

Egyptian football pitch booking app for players.

## Quick reference

| Item | Value |
|------|-------|
| Flutter channel | stable (3.38.x) |
| Dart SDK | `^3.10.1` |
| Min Android SDK | 26 (Android 8.0) |
| Min iOS | 15.0 |
| Primary locale | Arabic (RTL) |
| State management | Riverpod 2.x (`flutter_riverpod`, `riverpod_annotation`) |
| Navigation | go_router 14.x |
| Networking | Dio 5.x + Retrofit 4.x |
| Entry points | `main_dev.dart` (dev) · `main_prod.dart` (prod) |

## Running the app

```bash
# Development flavor — email auth, local backend (10.0.2.2:8000)
flutter run --target lib/main_dev.dart

# Production flavor — phone OTP, api.hagzkora.com
flutter run --target lib/main_prod.dart --release
```

## Code generation

All generated files (`.g.dart`, `.freezed.dart`) must be regenerated after
changing annotated source files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Run this after:
- Adding/changing `@riverpod` providers
- Adding/changing `@freezed` models
- Adding/changing `@JsonSerializable` DTOs
- Adding/changing `@RestApi` Retrofit clients

## Project structure

```
lib/
├── app.dart                   # HagzKoraApp root widget
├── main_dev.dart              # Dev entry point (AppConfig.development)
├── main_prod.dart             # Prod entry point (AppConfig.production)
├── core/
│   ├── config/
│   │   └── app_config.dart    # Flavor-injected singleton (baseUrl, authMode)
│   ├── domain/
│   │   └── failures.dart      # Sealed Failure hierarchy (NetworkFailure, etc.)
│   ├── l10n/                  # ARB files — app_en.arb + app_ar.arb
│   ├── network/
│   │   ├── dio_client.dart    # Singleton Dio instance with interceptors
│   │   ├── auth_interceptor.dart  # Bearer token + 401 refresh logic
│   │   └── error_handler.dart # DioException → Failure mapping
│   ├── router/
│   │   ├── app_routes.dart    # Path constants + helper methods
│   │   ├── app_router.dart    # GoRouter config + _AppShell bottom nav
│   │   └── router_notifier.dart  # Auth bridge for go_router refreshListenable
│   ├── storage/
│   │   ├── secure_storage.dart   # JWT token CRUD (flutter_secure_storage)
│   │   └── hive_service.dart     # Hive init + box accessors
│   ├── theme/
│   │   ├── app_colors.dart    # All color constants ("The Pitch Curator" palette)
│   │   ├── app_text_styles.dart  # Text style tokens (Manrope + Inter)
│   │   └── app_theme.dart     # ThemeData composition
│   └── widgets/
│       ├── app_button.dart        # ElevatedButton + OutlinedButton wrappers
│       ├── app_text_field.dart    # TextFormField wrapper
│       ├── error_view.dart        # ErrorView (full-screen) + ErrorBanner (inline)
│       ├── loading_overlay.dart   # Full-screen loading overlay
│       └── placeholder_screen.dart # Phase 0 stub screen
└── features/
    ├── auth/
    ├── bookings/
    ├── profile/
    ├── reviews/
    ├── stadiums/
    └── tournaments/
        # Each feature: data/{datasources,models,repositories}
        #               domain/{entities,repositories,usecases}
        #               presentation/{screens,widgets,providers}
```

## Build flavors

| Flavor | Auth mode | API base URL |
|--------|-----------|--------------|
| `development` | Email + password | `http://10.0.2.2:8000/api/v1/` |
| `production` | Phone OTP | `https://api.hagzkora.com/api/v1/` |

`AppConfig.setup()` is called in the entry point before `runApp`. Never call
`AppConfig.instance` before setup — it throws.

## Design system — "The Pitch Curator"

- **Primary**: `#012D1D` (dark pitch green)
- **Accent**: `#735C00` / `#F0C430` (gold)
- **Surface**: `#F8F9FA`
- **Headlines**: Manrope (700/600 weight)
- **Body/UI**: Inter

Always use `AppColors.*` and `AppTextStyles.*` constants. Never hardcode hex
values or `TextStyle` instances in feature code.

## Routing

Routes live in `AppRoutes` (path constants) and `app_router.dart` (GoRouter).

For parameterised navigation use the helper methods:
```dart
context.go(AppRoutes.stadiumDetailPath('abc123'));
context.go(AppRoutes.bookSlotPath('abc123', 'slot456'));
```

Auth guard lives in `RouterNotifier.redirect`. In Phase 1, replace the
`_isAuthenticated` stub with the real auth provider.

## Networking conventions

- All repositories return `Either<Failure, T>` (dartz).
- `DioClient` is a singleton; call `DioClient.initialize(baseUrl, storage)` once
  at startup (done in `main_dev/prod.dart`).
- The `AuthInterceptor` handles 401 refresh automatically. On persistent 401,
  tokens are cleared and the user must re-authenticate.
- In dev flavor, `LogInterceptor` logs all requests/responses to the console.

## Storage

- **Tokens** → `SecureStorage` (Keychain / EncryptedSharedPreferences). Never
  store tokens in Hive or SharedPreferences.
- **Structured cache** → `HiveService.stadiumCacheBox`, `userPrefsBox`.

## Linting

Analysis options are in `analysis_options.yaml`. Generated files are excluded.
Run before committing:
```bash
flutter analyze
dart format --set-exit-if-changed lib test
```

## Localization

Primary locale is Arabic (RTL). Add strings to both `app_ar.arb` and
`app_en.arb`. After adding keys, regenerate with `flutter pub get` (l10n runs
automatically when `generate: true` is set in pubspec).

Restore `AppLocalizations.delegate` in `app.dart` after first `flutter pub get`
with a valid ARB template.

## Phase notes

- **Phase 0** (current): Foundation scaffold — all screens are `PlaceholderScreen`.
- **Phase 1**: Auth feature — replace `_isAuthenticated` stub in `RouterNotifier`.
- Generated `.g.dart` files are committed to the repo (not gitignored).
