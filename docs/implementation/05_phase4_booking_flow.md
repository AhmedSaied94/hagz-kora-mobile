# Phase 4 — Booking Flow

**Duration:** Week 5–7  
**Priority:** P0 (launch blocker)

**Goal:** Player can book a slot, view booking confirmation, manage active bookings, and cancel.

---

## API Endpoints Used

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/bookings/` | POST | Create booking |
| `/api/bookings/` | GET | Player's booking list |
| `/api/bookings/<id>/` | GET | Booking detail |
| `/api/bookings/<id>/cancel/` | POST | Cancel booking |

---

## Flow: Book a Slot

```
Stadium Detail (slot selected)
  → Booking Summary Screen
    → Confirm Booking (POST /api/bookings/)
      → Success: Booking Confirmation Screen
      → Error (SLOT_TAKEN): "Slot just booked" dialog → back to slot picker
```

---

## Screen: Booking Summary (`/stadiums/:id/book/:slotId`)

**Content:**
- Stadium cover photo (thumbnail)
- Stadium name (in device locale)
- Date + time range (formatted in `Africa/Cairo` timezone)
- Duration
- Price per slot
- Deposit amount (50% — displayed as informational, "Pay at venue")
- Disclaimer: "Full payment is cash at the stadium. Deposit is indicative."

**Action:**
- Primary button: "Confirm Booking"
  - Shows loading indicator on tap
  - On success → replace with Booking Confirmation screen
  - On `SLOT_TAKEN` error → show `AlertDialog`: "This slot was just booked by someone else. Would you like to pick another slot?" → pop back to slot picker
  - On network error → show snackbar with retry

---

## Screen: Booking Confirmation (`/bookings/:id/confirmation`)

**Content:**
- Success animation (Lottie or custom)
- Booking reference number
- Stadium name, date, time
- Deposit amount reminder
- Two action buttons:
  - "Chat on WhatsApp" → deeplink (same pre-filled message as stadium detail)
  - "Call Stadium" → phone deeplink
- "View My Bookings" link → `/bookings`

---

## Screen: My Bookings (`/bookings`)

**Tabs:** Active · History

**Active bookings:**
- `ListView.builder` of `BookingCard` widgets
- Each card: stadium name, date, time, status badge
- Tapping → Booking Detail screen
- Swipe-to-cancel or "Cancel" button (if cancellation is still allowed)

**History:**
- Completed and cancelled bookings
- Read-only cards; "Leave a Review" button on completed bookings without a review

---

## Screen: Booking Detail (`/bookings/:id`)

**Content:**
- All booking fields
- Cancellation eligibility: if `slot.startTime - now > 2 hours` → show Cancel button
- If within 2 hours: "Cancellation is no longer available (less than 2 hours before kick-off)"
- Cancelled bookings: show cancellation reason (owner cancellations) or "Cancelled by you"
- WhatsApp + Call buttons always visible

---

## Cancellation Confirmation

Before cancelling:
- `AlertDialog`: "Are you sure you want to cancel this booking?"
- Confirm → `POST /api/bookings/<id>/cancel/`
- On success: refresh booking detail + update My Bookings list

---

## State & Domain

```
domain/
  entities/
    booking.dart        # id, slot, stadium, status, price, depositAmount,
                        #  isLateCancellation, cancellationReason, createdAt
  repositories/
    booking_repository.dart   # abstract: create(), list(), getById(), cancel()
  usecases/
    create_booking.dart
    get_my_bookings.dart
    get_booking_detail.dart
    cancel_booking.dart

data/
  models/
    booking_dto.dart    # @freezed + @JsonSerializable
    create_booking_request.dart
  datasources/
    booking_remote_datasource.dart  # Retrofit
  repositories/
    booking_repository_impl.dart

presentation/
  providers/
    booking_notifier.dart        # AsyncNotifier: handles create + cancel
    my_bookings_provider.dart    # Paginated active + history lists
  screens/
    booking_summary_screen.dart
    booking_confirmation_screen.dart
    my_bookings_screen.dart
    booking_detail_screen.dart
  widgets/
    booking_card.dart
    cancellation_dialog.dart
    slot_taken_dialog.dart
```

---

## Rules

- Never navigate away from Booking Summary on a booking attempt without awaiting the response — prevent double-submit
- After `POST /api/bookings/` succeeds, invalidate the stadium's slot cache for that date so the slot shows as booked if player navigates back
- `mounted` check required after `await` before any `context.go()` or `context.push()`
- Booking confirmation screen is pushed onto the stack (not replaced) — back button goes to stadium detail, not an empty state

---

## Deliverable

Full booking flow from slot selection to confirmation screen.  
`SLOT_TAKEN` error handled gracefully with "pick another slot" recovery.  
My Bookings screen shows active and history tabs.  
Cancellation enforces the 2-hour rule on the client side (double-checked by server).
