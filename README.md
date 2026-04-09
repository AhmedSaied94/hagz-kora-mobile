# Hagz Kora — Mobile App

Flutter mobile app for the Hagz Kora football pitch booking platform. Supports Arabic (RTL) and English, built with a clean feature-first architecture.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x / Dart |
| State Management | Riverpod + riverpod_annotation |
| Navigation | go_router with deep link support |
| Networking | Dio + Retrofit (code-generated) |
| Serialization | Freezed + JsonSerializable |
| Local Storage | flutter_secure_storage (JWT), Hive (cache) |
| Maps | google_maps_flutter |
| Push Notifications | firebase_messaging |
| Internationalization | intl + ARB files (Arabic RTL + English) |
| Testing | mocktail |

---

## Project Structure

```
hagz_kora/
├── lib/
│   ├── core/
│   │   ├── config/        # App config per flavor (dev/prod)
│   │   ├── domain/        # Shared failure types
│   │   ├── l10n/          # ARB localization files (ar/en)
│   │   ├── network/       # Dio client, interceptors, auth refresh
│   │   ├── router/        # go_router config + auth guards
│   │   ├── storage/       # Secure storage, Hive service
│   │   ├── theme/         # Colors, text styles, ThemeData
│   │   └── widgets/       # Shared UI components
│   ├── features/
│   │   ├── auth/          # Login, registration, OTP
│   │   ├── stadiums/      # Search, listing, stadium detail
│   │   ├── bookings/      # Booking flow, history
│   │   ├── tournaments/   # Tournament listing, fixtures
│   │   ├── reviews/       # Ratings & reviews
│   │   └── profile/       # User profile, settings
│   ├── app.dart
│   ├── main.dart          # Production entry point
│   └── main_dev.dart      # Development entry point
├── assets/
│   ├── images/
│   └── icons/
└── docs/implementation/   # Phase-by-phase implementation guides
```

Each feature follows clean architecture with three layers:
- `data/` — repositories, data sources, DTOs
- `domain/` — entities, use cases, repository interfaces
- `presentation/` — screens, widgets, Riverpod providers

---

## Getting Started

### Prerequisites

- Flutter 3.x (`flutter --version`)
- Dart SDK (comes with Flutter)
- Android Studio / Xcode for device emulation

### Setup

```bash
# 1. Clone the repo
git clone git@github.com:AhmedSaied94/hagz-kora-mobile.git
cd hagz-kora-mobile/hagz_kora

# 2. Install dependencies
flutter pub get

# 3. Generate code (Riverpod, Freezed, Retrofit, l10n)
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n

# 4. Run on a device or emulator
flutter run -t lib/main_dev.dart   # development
flutter run -t lib/main.dart       # production
```

---

## Flavors

| Flavor | Entry Point | API |
|---|---|---|
| Development | `lib/main_dev.dart` | Dev backend |
| Production | `lib/main.dart` | Production backend |

---

## Design System

| Token | Value |
|---|---|
| Primary | `#012d1d` (dark green) |
| Accent | `#735c00` (gold) |
| Surface | `#f8f9fa` |
| Headline font | Manrope |
| Body font | Inter |

The app is RTL-first for Arabic with full LTR support for English. Language switches at runtime without restart.

---

## Code Generation

Several packages require code generation. Re-run after modifying annotated files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Affected files:
- `*.g.dart` — Riverpod providers, go_router, Retrofit clients
- `*.freezed.dart` — immutable data classes

---

## Running Tests

```bash
# Unit and widget tests
flutter test

# With coverage
flutter test --coverage
```

---

## Implementation Roadmap

| Phase | Scope | Status |
|---|---|---|
| 0 | Foundation (routing, theme, DI, storage) | ✅ Done |
| 1 | Auth (login, registration, OTP flow) | 🔲 Pending |
| 2 | Home & search (map, list, filters) | 🔲 Pending |
| 3 | Stadium detail (gallery, hours, booking CTA) | 🔲 Pending |
| 4 | Booking flow (slot picker, confirmation) | 🔲 Pending |
| 5 | Profile (edit, history, settings) | 🔲 Pending |
| 6 | Tournaments (listing, fixtures, standings) | 🔲 Pending |
| 7 | Reviews (submit, read, owner responses) | 🔲 Pending |
| 8 | Push notifications & deep links | 🔲 Pending |
| 9 | Localization & RTL polish | 🔲 Pending |
| 10 | QA & release prep | 🔲 Pending |

See `docs/implementation/` for detailed phase guides.

---

## Related Repositories

- **Backend API**: [hagz-kora-back](https://github.com/AhmedSaied94/hagz-kora-back)
