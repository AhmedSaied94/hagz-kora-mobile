# Phase 7 — Ratings & Reviews

**Duration:** Week 9–10  
**Priority:** P1

**Goal:** Player can submit a review for a stadium after a completed booking. All reviews visible on stadium detail.

**Dependency:** Phase 4 (Booking Flow) — the "Leave a Review" entry point is in My Bookings history.

---

## API Endpoints Used

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/bookings/<id>/review/` | POST | Submit review for a completed booking |
| `/api/stadiums/<id>/reviews/` | GET | All reviews for a stadium (paginated) |

---

## Entry Points

1. **My Bookings → History tab** — completed bookings without a review show a "Leave a Review" button
2. **Stadium Detail → Reviews section** — "View all reviews" → full reviews bottom sheet or screen

---

## Screen: Leave a Review (bottom sheet or `/bookings/:id/review`)

**Fields:**

| Field | Widget | Notes |
|-------|--------|-------|
| Overall rating | Star row (1–5, required) | Tappable stars, large touch targets |
| Pitch Quality | Star row (1–5, optional) | Sub-rating |
| Facilities | Star row (1–5, optional) | Sub-rating |
| Value for Money | Star row (1–5, optional) | Sub-rating |
| Written review | `TextField` multiline, max 500 chars | Optional, char counter shown |

**Submit:**
- `POST /api/bookings/<id>/review/`
- On success: dismiss sheet, show snackbar "Your review has been submitted", update booking card (remove "Leave a Review" button)
- On error (already reviewed / booking not completed): show appropriate message

---

## Reviews Display on Stadium Detail

**Rating summary section** (Phase 3 addition):
- Overall average: large number + star row
- Sub-rating bars:
  - Pitch Quality: `LinearProgressIndicator` + average value
  - Facilities
  - Value for Money
- Total review count

**Inline reviews (top 5):**
- `ReviewCard` widget: reviewer name (first name only), date, overall stars, review text, owner response (if any)
- "View all N reviews" → full list

**Full reviews screen / bottom sheet:**
- `ListView.builder` (paginated, 20/page, load-more on scroll)
- `ReviewCard` per item

---

## State & Domain

```
domain/
  entities/
    review.dart             # id, reviewerName, overallRating, pitchQuality, facilities,
                            #  valueForMoney, text, ownerResponse, createdAt
  repositories/
    review_repository.dart  # abstract: submitReview(), getStadiumReviews()
  usecases/
    submit_review.dart
    get_stadium_reviews.dart

data/
  models/
    review_dto.dart
    submit_review_request.dart   # @freezed
  datasources/
    review_remote_datasource.dart  # Retrofit
  repositories/
    review_repository_impl.dart

presentation/
  providers/
    submit_review_notifier.dart
    stadium_reviews_provider.dart   # Paginated
  widgets/
    star_rating_input.dart
    sub_rating_row.dart
    review_card.dart
    rating_summary_widget.dart   # Used in stadium detail
  screens/
    leave_review_screen.dart
    all_reviews_screen.dart
```

---

## Deliverable

"Leave a Review" button appears on completed bookings without an existing review.  
Review form validates required overall rating before submission.  
Sub-ratings and text are optional.  
Reviews and rating summary display correctly on stadium detail.
