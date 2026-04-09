# Phase 3 — Stadium Detail

**Duration:** Week 4–5  
**Priority:** P0 (launch blocker)

**Goal:** Player can view a stadium's full profile — gallery, description, amenities, map, available slots, ratings, and contact options.

---

## API Endpoints Used

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/stadiums/<id>/` | GET | Full stadium detail |
| `/api/stadiums/<id>/slots/?date=YYYY-MM-DD` | GET | Slot availability for a date |
| `/api/stadiums/<id>/reviews/` | GET | Paginated reviews |

---

## Screen: Stadium Detail (`/stadiums/:id`)

### Layout (single `CustomScrollView` with `SliverAppBar`)

**1. Gallery Carousel (SliverAppBar)**
- `carousel_slider` or `PageView` — swipeable photo carousel
- Dot indicator for current photo position
- Cover photo shown first

**2. Stadium Info Section**
- Name (Arabic or English based on device locale)
- Sport type badge (5v5 / 7v7)
- Price per slot
- Distance from player (from search result context or computed)
- Star rating + review count → tapping scrolls to reviews section

**3. Description**
- Full text in device locale (Arabic RTL / English LTR)
- Expandable if longer than 3 lines

**4. Amenities**
- Horizontal chip row with icons: Parking, Showers, Floodlights, Café, Changing Rooms, etc.
- Icons + localized labels

**5. Location Map**
- Embedded `GoogleMap` — non-scrollable, fixed height (200px)
- Stadium pin centered
- "Open in Maps" button → `url_launcher` to Google Maps / Apple Maps deep link

**6. Available Slots**
- Date selector: horizontal scrollable strip, today + 14 days
- Slot list: horizontal `ListView.builder` of time chips
  - Green = available (tappable → booking flow)
  - Grey = booked (non-tappable)
  - Orange = blocked (non-tappable)
- Fetches slots when date changes (cached per date in provider)

**7. Ratings Summary**
- Overall average with star display
- Sub-rating bars: Pitch Quality · Facilities · Value for Money
- 5 most recent reviews inline
- "View all reviews" → full reviews bottom sheet

**8. Contact Buttons** (sticky bottom bar)
- "Chat on WhatsApp" → `url_launcher`: `wa.me/<number>?text=<pre-filled Arabic message>`
  - Pre-filled message includes: stadium name, selected date, selected time slot
- "Call Stadium" → `url_launcher`: `tel:<phone_number>`

---

## Pre-filled WhatsApp Message (Arabic)

```
مرحباً، أريد الاستفسار عن حجز ملعب [اسم الملعب]
التاريخ: [DD/MM/YYYY]
الوقت: [HH:MM]
```

Generated dynamically from selected slot context.

---

## State & Domain

```
domain/
  entities/
    stadium_detail.dart     # Full stadium entity including gallery, amenities, operatingHours
    slot.dart               # id, startTime, endTime, status, price
    review.dart             # id, overallRating, text, subRatings, ownerResponse, createdAt
  repositories/
    stadium_repository.dart  # getDetail(), getSlots(), getReviews()
  usecases/
    get_stadium_detail.dart
    get_slots_for_date.dart
    get_stadium_reviews.dart

presentation/
  providers/
    stadium_detail_provider.dart   # AsyncNotifierProvider per stadium id
    slots_provider.dart            # StateNotifierProvider per (stadiumId, date)
    reviews_provider.dart          # Paginated reviews provider
  screens/
    stadium_detail_screen.dart
  widgets/
    gallery_carousel.dart
    amenities_row.dart
    slot_picker.dart
    rating_summary.dart
    review_card.dart
    contact_bottom_bar.dart
```

---

## Rules

- Gallery images loaded via `CachedNetworkImage` — no raw `Image.network`
- Map widget wrapped in `RepaintBoundary` to avoid rebuild cascade
- Slots list re-fetched only when date changes (not on every rebuild)
- `mounted` checked after `await` before any navigation

---

## Deliverable

Full stadium detail screen with all sections.  
Slot availability loads per selected date.  
WhatsApp and call deeplinks work with correct pre-filled context.  
Navigating to this screen from search results or home feed works correctly.
