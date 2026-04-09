# Phase 1 — Auth & Onboarding

**Duration:** Week 2–3  
**Priority:** P0 (launch blocker)

**Goal:** Player can register and log in via phone OTP (production) or email/password (dev/staging). JWT tokens stored securely. FCM device token registered on login.

---

## API Endpoints Used

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/auth/otp/request/` | POST | Request OTP — prod flavor only |
| `/api/auth/otp/verify/` | POST | Verify OTP → receive JWT pair |
| `/api/auth/register/` | POST | Email registration — dev flavor only |
| `/api/auth/login/` | POST | Email login — dev flavor only |
| `/api/auth/token/refresh/` | POST | Refresh access token |
| `/api/auth/logout/` | POST | Blacklist refresh token |
| `/api/devices/` | POST | Register FCM token after login |
| `/api/players/me/` | GET | Fetch own profile after login |

---

## Screens

### Splash Screen (`/splash`)
- Check `SecureStorage` for existing tokens
- If valid token exists → navigate to `/home/feed`
- If no token → navigate to `/onboarding` (first launch) or `/auth/phone`

### Onboarding Screen (`/onboarding`)
- Shown on first launch only (persisted via Hive)
- 3-slide carousel: value proposition in Arabic and English
- "Get Started" → `/auth/phone`

### Phone Entry Screen (`/auth/phone`) — Production
- Egyptian phone number input (`+20` prefix locked)
- Validate format before submitting
- Show loading state on submit
- On success → navigate to `/auth/otp` passing phone number

### OTP Verify Screen (`/auth/otp`) — Production
- 6-box OTP input (auto-advance on digit entry)
- 5-minute countdown timer; "Resend" button enabled after expiry
- After 3 failed attempts: show error "Too many attempts, try again in 15 minutes"
- On success → store tokens → register FCM token → fetch profile → navigate to `/home/feed`

### Email Login Screen — Dev Flavor Only
- Email + password fields
- Shown in development flavor instead of OTP screens
- Same post-login flow as OTP success

---

## State & Domain

```
domain/
  entities/
    user.dart           # id, fullName, phone, role, city, profilePhotoUrl
  repositories/
    auth_repository.dart  # abstract
  usecases/
    request_otp.dart
    verify_otp.dart
    logout.dart
    get_current_user.dart

data/
  models/
    auth_response_dto.dart    # @freezed: accessToken, refreshToken, user
    user_dto.dart
  datasources/
    auth_remote_datasource.dart   # Retrofit interface
  repositories/
    auth_repository_impl.dart

presentation/
  providers/
    auth_notifier.dart      # AsyncNotifier: idle | loading | authenticated | error
    current_user_provider.dart
  screens/
    splash_screen.dart
    onboarding_screen.dart
    phone_screen.dart
    otp_screen.dart
```

---

## Post-Login Flow

```
OTP verified
  → Save access + refresh token to SecureStorage
  → POST /api/devices/ with FCM token
  → GET /api/players/me/ → cache user in Riverpod provider
  → go_router redirects to /home/feed
```

---

## Logout Flow

```
User taps Logout
  → POST /api/auth/logout/ with refresh token (blacklist server-side)
  → SecureStorage.clearTokens()
  → Hive cache cleared
  → FCM token deregistered
  → go_router redirects to /auth/phone
```

---

## Rules & Guards

- `mounted` check required after every `await` before using `BuildContext`
- Token refresh happens transparently in `AuthInterceptor` — screens never handle 401 manually
- Auth guard in go_router: any route under `/home` redirects to `/auth/phone` if no token found

---

## Deliverable

Player can log in with phone OTP (prod) or email (dev).  
Tokens stored in `flutter_secure_storage`.  
FCM device token registered immediately after login.  
Unauthenticated navigation attempts are intercepted and redirected.
