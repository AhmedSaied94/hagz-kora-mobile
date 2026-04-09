# Hagz Kora — Mobile (Flutter) Implementation Docs

This directory contains the phase-by-phase Flutter mobile implementation plan derived from the PRD and SRS.

## Documents

| File | Phase | Topic |
|------|-------|-------|
| [00_implementation_plan.md](00_implementation_plan.md) | Overview | Full phase summary, navigation structure, critical path, deferred features |
| [01_phase0_foundation.md](01_phase0_foundation.md) | Phase 0 | Project setup, architecture scaffold, Dio client, routing, theming |
| [02_phase1_auth.md](02_phase1_auth.md) | Phase 1 | Phone OTP / email auth, JWT storage, FCM token registration |
| [03_phase2_home_search.md](03_phase2_home_search.md) | Phase 2 | Home feed, search filters, results list + map view |
| [04_phase3_stadium_detail.md](04_phase3_stadium_detail.md) | Phase 3 | Gallery, slots, reviews, contact deeplinks |
| [05_phase4_booking_flow.md](05_phase4_booking_flow.md) | Phase 4 | Booking summary, confirmation, My Bookings, cancellation |
| [06_phase5_profile.md](06_phase5_profile.md) | Phase 5 | Player profile, edit, language toggle |
| [07_phase6_tournaments.md](07_phase6_tournaments.md) | Phase 6 | Browse, register, join via code, fixtures, standings |
| [08_phase7_reviews.md](08_phase7_reviews.md) | Phase 7 | Leave review (post completed booking), review display |
| [09_phase8_notifications_deeplinks.md](09_phase8_notifications_deeplinks.md) | Phase 8 | FCM setup, notification handling (3 states), deep links |
| [10_phase9_localization_rtl.md](10_phase9_localization_rtl.md) | Phase 9 | ARB files, RTL layout rules, Cairo timezone, locale persistence |
| [11_phase10_polish_testing.md](11_phase10_polish_testing.md) | Phase 10 | Unit/widget/integration tests, performance, accessibility, pre-release checklist |

## Source Documents

The original PRD and SRS are at the project root:
- `../../HAGZKORA_PRD.docx`
- `../../HAGZKORA_SRS.docx`

## Tech Stack

- **Flutter 3.x** (latest stable) — Android 8.0+ · iOS 15+
- **Riverpod** — state management (AsyncNotifier, StateNotifier providers)
- **go_router** — navigation with ShellRoute for bottom nav + deep link support
- **Dio + Retrofit** — networking with code generation
- **Freezed + JsonSerializable** — immutable DTOs and entities
- **flutter_secure_storage** — JWT token storage (never SharedPreferences)
- **Hive** — local cache for non-sensitive data (locale, onboarding flag, search cache)
- **google_maps_flutter** — stadium map display and map results view
- **firebase_messaging** — FCM push notifications
- **cached_network_image** — remote image loading with disk cache
- **url_launcher** — WhatsApp deeplinks (`wa.me/`) and phone deeplinks (`tel:`)
- **flutter_localizations + intl** — Arabic (RTL) and English (LTR) support

## Architecture

Feature-first clean architecture — each feature has `data/`, `domain/`, and `presentation/` layers:

```
lib/
  features/
    auth/         data/ domain/ presentation/
    stadiums/     data/ domain/ presentation/
    bookings/     data/ domain/ presentation/
    tournaments/  data/ domain/ presentation/
    reviews/      data/ domain/ presentation/
    profile/      data/ domain/ presentation/
  core/
    network/      # Dio client, interceptors, token refresh
    storage/      # SecureStorage, Hive service
    router/       # go_router config + auth guards
    l10n/         # ARB files
    theme/        # ThemeData, colors, text styles
    widgets/      # Shared widgets
```
