# Phase 2 — Home & Search

**Duration:** Week 3–5  
**Priority:** P0 (launch blocker)

**Goal:** Player can browse featured stadiums on the home feed and search for stadiums by location, date, time, and sport type. Results shown as a list and on a map.

---

## API Endpoints Used

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/stadiums/search/` | GET | Search with filters |
| `/api/stadiums/` | GET | Featured stadiums (homepage, no filters) |

---

## Screens

### Home Feed (`/home/feed`)

**Layout:**
- Top: greeting + city label
- Search bar (tapping navigates to Search screen with filter panel open)
- Horizontal section: "Featured Stadiums" — `ListView.builder` horizontal scroll
- Vertical section: "Near You" — `ListView.builder` with `StadiumCard` widgets

**Data:** Featured and nearby stadiums fetched on screen init using player's GPS location.  
Location permission requested on first load; fallback to Cairo center if denied.

---

### Search Screen (`/search`)

**Filter panel (sheet or inline form):**

| Field | Widget | Notes |
|-------|--------|-------|
| Location | Text field + "Use GPS" button | GPS → lat/lng; text → geocoded by backend |
| Date | Date picker | Min: today, max: today+60 |
| Time range | Two time pickers (From / To) | Optional |
| Sport type | Segmented button: 5v5 / 7v7 / Any | |
| Max price | Slider | Optional |
| Radius | Dropdown: 5km / 10km / 20km / 50km | Default 10km |

"Search" button triggers API call and navigates to results.

---

### Search Results Screen (`/search/results`)

**List view (default):**
- `ListView.builder` — never `ListView` with children
- Each item: `StadiumCard` widget
- Pagination: load-more on scroll (cursor-based, 20 items per page)
- Empty state: illustration + "No stadiums found near you"
- Error state: retry button

**Map view (toggle):**
- `google_maps_flutter` `GoogleMap` widget
- Each stadium = `Marker` with cover photo thumbnail as custom marker icon
- Tapping marker → bottom sheet with stadium card + "View Details" button
- Map bounds auto-fit to all result markers

**`StadiumCard` widget:**
```
┌─────────────────────────────────────┐
│  [Cover Photo]                      │
│  Stadium Name          ⭐ 4.3 (12) │
│  5v5  ·  1.4 km  ·  150 EGP/slot  │
│  5 slots available                  │
└─────────────────────────────────────┘
```

---

## State & Domain

```
domain/
  entities/
    stadium_summary.dart  # id, nameAr, nameEn, coverPhotoUrl, sportType,
                          #  pricePerSlot, distanceKm, avgRating, availableSlotCount,
                          #  lat, lng
  repositories/
    stadium_repository.dart   # abstract: search(), getFeatured()
  usecases/
    search_stadiums.dart
    get_featured_stadiums.dart

data/
  models/
    stadium_summary_dto.dart   # @freezed + @JsonSerializable
  datasources/
    stadium_remote_datasource.dart  # Retrofit
  repositories/
    stadium_repository_impl.dart

presentation/
  providers/
    search_provider.dart          # StateNotifier: idle | loading | results | error
    location_provider.dart        # Current GPS position
  screens/
    home_feed_screen.dart
    search_screen.dart
    search_results_screen.dart
  widgets/
    stadium_card.dart
    search_filter_panel.dart
    map_results_view.dart
```

---

## Location Handling

- Use `geolocator` package
- Request `locationWhenInUse` permission on first search
- Cache last known position in Riverpod provider
- If permission denied: show "Enable location for better results" banner; allow manual city/address entry

---

## Rules

- `ListView.builder` always — never `Column` with `.map()` for dynamic lists
- Map view only renders when user taps toggle — lazy initialization to avoid loading Maps SDK unnecessarily
- Search results cached in Riverpod state; navigating back to results screen does not re-fetch

---

## Deliverable

Player can search stadiums using GPS or manual location.  
Results shown as paginated list and as map pins.  
Featured stadiums shown on home feed without search filters.
