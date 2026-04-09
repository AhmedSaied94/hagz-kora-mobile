# Phase 5 — Player Profile & Booking History

**Duration:** Week 6–7  
**Priority:** P0 (launch blocker)

**Goal:** Player can view and edit their profile, see their booking and tournament history.

---

## API Endpoints Used

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/players/me/` | GET, PATCH | View and edit profile |
| `/api/players/me/bookings/` | GET | Booking history |
| `/api/players/me/tournaments/` | GET | Tournament participation history |

---

## Screen: Profile (`/profile`)

**Content:**
- Profile photo (circle avatar) with "Edit" overlay tap → image picker
- Full name
- Phone number (read-only — shown with lock icon)
- City
- Preferred position badge (optional): GK · DEF · MID · FWD
- Stats row: Bookings played · Tournaments participated
- Menu items:
  - Edit Profile → `/profile/edit`
  - My Bookings → `/bookings`
  - My Tournaments → `/tournaments` (filtered to player's teams)
  - Language toggle: العربية / English
  - Logout (with confirmation dialog)

---

## Screen: Edit Profile (`/profile/edit`)

**Editable fields:**
- Full name (required)
- Profile photo — `image_picker`: camera or gallery; upload to API via `PATCH /api/players/me/`
- Preferred position — `DropdownButton`: Goalkeeper / Defender / Midfielder / Forward
- Date of birth — `DatePicker`
- City — text field

**Non-editable (displayed as read-only):**
- Phone number — "Contact support to change your number"

**Save button:**
- `PATCH /api/players/me/` with only changed fields
- Show success snackbar on completion
- `mounted` guard before snackbar

---

## State & Domain

```
domain/
  entities/
    player_profile.dart   # id, fullName, phone, profilePhotoUrl,
                          #  preferredPosition, dateOfBirth, city,
                          #  bookingCount, tournamentCount
  repositories/
    profile_repository.dart  # abstract: getProfile(), updateProfile(), uploadPhoto()
  usecases/
    get_my_profile.dart
    update_profile.dart

data/
  models/
    player_profile_dto.dart     # @freezed + @JsonSerializable
    update_profile_request.dart
  datasources/
    profile_remote_datasource.dart  # Retrofit
  repositories/
    profile_repository_impl.dart

presentation/
  providers/
    current_user_provider.dart   # Shared with auth — single source of truth
    profile_notifier.dart        # Handles PATCH + photo upload
  screens/
    profile_screen.dart
    edit_profile_screen.dart
  widgets/
    profile_avatar.dart
    profile_stat_row.dart
```

---

## Language Toggle

- Stored in Hive (persists across sessions)
- Toggling updates `MaterialApp`'s locale via a Riverpod provider
- Does not require a restart — `MaterialApp` rebuilds with new locale

```dart
// core/providers/locale_provider.dart
final localeProvider = StateProvider<Locale>((ref) => const Locale('ar'));
```

---

## Deliverable

Player can view their profile, edit all editable fields, and upload a profile photo.  
Language toggle between Arabic and English persists across app restarts.  
Booking and tournament history accessible from profile.
