# Hagz Kora — Mobile (Flutter) Implementation Plan

## Overview

**Target:** Android 8.0+ · iOS 15+  
**Stack:** Flutter 3.x (latest stable) · Dart · Riverpod (state management) · go_router (navigation) · Dio + Retrofit (networking) · flutter_secure_storage · google_maps_flutter · firebase_messaging

**Architecture:** Feature-first clean architecture per feature module:
```
lib/
  features/
    auth/
      data/        # API clients, DTOs, repository implementations
      domain/      # Entities, repository interfaces, use cases
      presentation/ # Screens, widgets, state (Riverpod providers)
    stadiums/
    bookings/
    tournaments/
    reviews/
    profile/
  core/
    network/       # Dio client, interceptors, token refresh
    storage/       # Secure storage, Hive adapters
    router/        # go_router config
    l10n/          # ARB files, locale switching
    theme/         # ThemeData, colors, text styles
    widgets/       # Shared widgets
```

**Guiding principles:**
- Consume the same REST API as web dashboards (`https://api.hagzkora.com/api/v1/`)
- JWT Bearer token in `Authorization` header on every authenticated request
- Arabic (RTL) and English (LTR) — device locale drives language selection
- Phone OTP auth in production; email/password in dev/staging (controlled by build flavor)
- Never store tokens in SharedPreferences — always `flutter_secure_storage`
- Always check `mounted` before using `BuildContext` after any `await`
- Use `const` constructors everywhere they qualify

---

## UI Design References (Stitch)

**Project:** Hagz Kora Player App — ID: `10033991534661459388`

Screens covering all 10 phases — fetch with `mcp__stitch__get_screen` before implementing any mobile screen.

**All screens generated (29 total, ~22 unique):** Splash, Onboarding Step 2, Phone Number Entry, OTP Verification, Home Feed, Search & Filter, Search Results, Stadium Detail, Booking Summary, Booking Confirmation, Booking Details, My Bookings, Player Profile, Edit Profile, Tournaments Tab, Tournament Detail (Overview), Tournament Standings, My Team, Register Team sheet, Join Team sheet, Leave a Review, All Reviews.  
**Note:** Some screens have 2–3 variants from generation retries — pick the best-matching one per screen when implementing.

**Design system:** "The Pitch Curator" — primary `#012d1d`, gold accent `#735c00`, surface `#f8f9fa`, RTL-first Arabic, no 1px borders, tonal surface layering, Manrope headlines + Inter body, dark green bottom nav bar.

Use `mcp__stitch__list_screens` with `projectId: "10033991534661459388"` to see current screens.

---

## Phase Summary

| Phase | Feature Area | Weeks | Priority |
|-------|-------------|-------|----------|
| 0 | Project Foundation & Architecture | 1–2 | P0 |
| 1 | Auth & Onboarding | 2–3 | P0 |
| 2 | Home & Search | 3–5 | P0 |
| 3 | Stadium Detail | 4–5 | P0 |
| 4 | Booking Flow | 5–7 | P0 |
| 5 | Player Profile & Booking History | 6–7 | P0 |
| 6 | Tournament Module | 7–10 | P1 |
| 7 | Ratings & Reviews | 9–10 | P1 |
| 8 | Push Notifications & Deep Links | 8–9 | P0 |
| 9 | Localization & RTL | Throughout | P0 |
| 10 | Polish, Testing & QA | 10–11 | P1 |

---

## Navigation Structure

```
Root
├── /splash              (unauthenticated)
├── /onboarding          (first launch)
├── /auth/phone          (phone entry)
├── /auth/otp            (OTP verify)
└── /home (shell route — bottom nav)
    ├── /home/feed        (tab: Home)
    ├── /search           (tab: Search)
    │   ├── /search/results
    │   └── /stadiums/:id
    │       └── /stadiums/:id/book/:slotId
    │           └── /bookings/:id/confirmation
    ├── /bookings         (tab: My Bookings)
    │   └── /bookings/:id
    ├── /tournaments      (tab: Tournaments)
    │   ├── /tournaments/:id
    │   └── /tournaments/:id/my-team
    └── /profile          (tab: Profile)
        └── /profile/edit
```

---

## Critical Path

```
Phase 0 (Foundation) → Phase 1 (Auth) → Phase 2 (Search) → Phase 3 (Stadium Detail)
                                                                        ↓
                                                            Phase 4 (Booking Flow)
                                                                        ↓
                                                   Phase 5 (Profile) + Phase 8 (Notifications)
                                                                        ↓
                                                            Phase 6 (Tournaments)
                                                                        ↓
                                                   Phase 7 (Reviews) + Phase 9 (L10n)
                                                                        ↓
                                                            Phase 10 (Polish & QA)
```

Phase 9 (Localization) runs throughout all phases — every widget added must support both locales.  
Phase 8 (Notifications) can be developed in parallel with Phase 4.

---

## Deferred to Phase 2 (Post-Launch)

| Feature | Reason |
|---------|--------|
| Online payment (Fawry/instapay) | No payment gateway in Phase 1 |
| Recurring bookings | Backend not implemented in Phase 1 |
| Padel / basketball support | Out of scope for Phase 1 |
| Social features (player connections, chat) | Post-launch roadmap |
