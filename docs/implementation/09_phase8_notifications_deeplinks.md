# Phase 8 — Push Notifications & Deep Links

**Duration:** Week 8–9 (parallel with Phase 4–5)  
**Priority:** P0 (launch blocker)

**Goal:** App receives and handles FCM push notifications. Deep links open the correct in-app screen.

---

## API Endpoints Used

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/devices/` | POST | Register FCM token after login |
| `/api/devices/<token>/` | DELETE | Deregister on logout |

---

## Firebase Setup

- Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) — gitignored, injected via CI secrets
- Initialize `Firebase.initializeApp()` in `main_dev.dart` and `main_prod.dart` before `runApp()`
- Request notification permission on first launch (after auth)

---

## FCM Token Lifecycle

```
App launch → Firebase.initializeApp()
Auth success → FirebaseMessaging.instance.getToken()
            → POST /api/devices/ { token, platform }
            → store token in SecureStorage

Token refresh (FirebaseMessaging.instance.onTokenRefresh)
            → POST /api/devices/ (upsert)

Logout → DELETE /api/devices/<token>/
       → SecureStorage.clearTokens()
```

---

## Notification Triggers & Payloads

| Event | Payload `data` fields | Action on tap |
|-------|----------------------|---------------|
| Booking confirmed | `type: booking_confirmed`, `booking_id` | Open `/bookings/:id` |
| Booking cancelled by owner | `type: booking_cancelled`, `booking_id` | Open `/bookings/:id` |
| Stadium approved | `type: stadium_approved`, `stadium_id` | (Owner only — mobile may receive but no dedicated owner screen) |
| Tournament registration opens | `type: tournament_open`, `tournament_id` | Open `/tournaments/:id` |
| Tournament match scored | `type: fixture_scored`, `tournament_id` | Open `/tournaments/:id` (standings tab) |

---

## Notification Handling

Three states to handle:

**1. App in foreground** (`FirebaseMessaging.onMessage`)
- Show in-app banner using `overlay_support` or a custom `OverlayEntry`
- Tapping banner → navigate to relevant screen

**2. App in background, notification tapped** (`FirebaseMessaging.onMessageOpenedApp`)
- Navigate to relevant screen based on `data.type`

**3. App terminated, notification tapped** (`FirebaseMessaging.instance.getInitialMessage()`)
- Check on app launch in `main` — if a message is waiting, navigate after app is fully initialized

```dart
// core/notifications/notification_handler.dart
class NotificationHandler {
  void handleMessage(RemoteMessage message) {
    final type = message.data['type'];
    switch (type) {
      case 'booking_confirmed':
      case 'booking_cancelled':
        router.push('/bookings/${message.data['booking_id']}');
      case 'tournament_open':
      case 'fixture_scored':
        router.push('/tournaments/${message.data['tournament_id']}');
    }
  }
}
```

---

## Deep Links

**Scheme:** `https://hagzkora.com` (universal links / app links)

| URL | In-app route |
|-----|-------------|
| `hagzkora.com/tournaments/:id` | `/tournaments/:id` |
| `hagzkora.com/stadiums/:id` | `/stadiums/:id` |

**Setup:**
- Android: `AssetLinks.json` served from backend at `/.well-known/assetlinks.json`
- iOS: `apple-app-site-association` file served from backend
- go_router handles both deep link and push notification navigation via the same `GoRouter` instance

---

## iOS Permission

```dart
await FirebaseMessaging.instance.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);
```

Request after successful login — not on first app launch.

---

## Deliverable

FCM token registered on login and refreshed automatically.  
All notification types handled in foreground, background, and terminated states.  
Tapping a notification navigates to the correct screen.  
Tournament share links open in-app via deep link.
