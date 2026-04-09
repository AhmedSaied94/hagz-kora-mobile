# Phase 10 — Polish, Testing & QA

**Duration:** Week 10–11  
**Priority:** P1

**Goal:** App is stable, performant, and meets the Definition of Done. 80%+ test coverage on core flows.

---

## Testing Strategy

### Unit Tests (domain + data layers)

Test use cases and repository implementations in isolation. Mock network datasources.

| Module | Key tests |
|--------|-----------|
| Auth | OTP request/verify flow, token refresh logic, logout clears storage |
| Search | Filter params mapped correctly, pagination state, empty results |
| Booking | Create booking success, SLOT_TAKEN error handling, cancellation eligibility |
| Tournaments | Register team, join via code, standings computation (if client-side) |
| Reviews | Eligibility check, submit maps to correct booking |

Framework: `flutter_test` + `mocktail` for mocking.

### Widget Tests (presentation layer)

Key screens tested for correct rendering and interaction:

| Screen | Tests |
|--------|-------|
| `OtpScreen` | 6-digit input, auto-advance, resend timer, error display |
| `StadiumCard` | Renders all fields, tapping navigates to detail |
| `SlotPicker` | Available/booked/blocked states render correctly |
| `BookingSummaryScreen` | Confirm tap triggers API call, loading state shown |
| `StandingsTable` | Rows sorted by points, tiebreakers applied |

### Integration Tests (golden path E2E on emulator)

| Flow | Steps |
|------|-------|
| Book a slot | Login → Search → Stadium detail → Select slot → Confirm → See confirmation |
| Cancel booking | My Bookings → Active → Cancel → Confirm dialog → Booking removed from active |
| Join tournament | Tournament detail → Join with code → See team screen |

Framework: `integration_test` package.

---

## Performance Checklist

- [ ] No `ListView` with children for dynamic lists — always `ListView.builder`
- [ ] `CachedNetworkImage` for all remote images — no `Image.network`
- [ ] `const` constructors on all eligible widgets (run `flutter analyze` — warns on missing `const`)
- [ ] `RepaintBoundary` around `GoogleMap` and gallery carousel widgets
- [ ] No business logic in `build()` methods — only in providers/notifiers
- [ ] Heavy operations (image processing, large JSON parsing) use `compute()` or isolate
- [ ] No `setState` in feature code — all state in Riverpod providers

---

## Accessibility Checklist

- [ ] All interactive widgets have `Semantics` labels (or use widgets that set them automatically)
- [ ] Minimum touch target size: 48×48dp (use `GestureDetector` padding or `InkWell` minimum size)
- [ ] Text contrast ratio ≥ 4.5:1 (WCAG AA)
- [ ] Screen reader tested on both Android (TalkBack) and iOS (VoiceOver)
- [ ] Arabic text in RTL does not overlap or truncate incorrectly

---

## Security Checklist

- [ ] No tokens in `SharedPreferences` — all in `flutter_secure_storage`
- [ ] No API keys or credentials in Dart source files — injected via `--dart-define` or flavor config
- [ ] All API calls use HTTPS only — no HTTP endpoints
- [ ] `flutter_secure_storage` configured with Android `encryptedSharedPreferences: true`
- [ ] Deep link validation — only handle known hosts (`hagzkora.com`)

---

## Pre-Release Checklist

- [ ] Tested on Android emulator (API 26 minimum)
- [ ] Tested on physical Android device
- [ ] Tested on iOS simulator (iOS 15 minimum)
- [ ] Tested on physical iPhone
- [ ] Arabic layout tested (RTL) on all screens
- [ ] English layout tested (LTR) on all screens
- [ ] Notification handling tested in foreground, background, and terminated states
- [ ] Deep links tested (tournament share URL)
- [ ] No `flutter analyze` warnings
- [ ] No `dart format` issues
- [ ] `flutter build apk --flavor production` succeeds
- [ ] `flutter build ipa --flavor production` succeeds

---

## Definition of Done (from PRD)

Before any feature is considered complete:

- [ ] Passing unit/widget tests with coverage ≥ 80% for the feature module
- [ ] UI tested on Android emulator and physical device
- [ ] Arabic and English copy reviewed and approved
- [ ] Relevant push notification paths tested end-to-end
- [ ] Code reviewed and approved by at least one peer
- [ ] No hardcoded strings — all in ARB files
- [ ] RTL layout verified for all new screens

---

## Deliverable

App passes all tests. No P0 bugs. Runs on minimum supported OS versions (Android 8.0, iOS 15).  
Arabic RTL fully functional. Push notifications working end-to-end.  
`flutter build` succeeds for both flavors on both platforms.
