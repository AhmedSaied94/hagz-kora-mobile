# Phase 9 — Localization & RTL

**Duration:** Throughout all phases (not a separate sprint — enforced from Phase 0)  
**Priority:** P0 (launch blocker)

**Goal:** App renders correctly in Arabic (RTL) and English (LTR). All user-facing strings externalized. Date/time shown in Cairo timezone.

---

## Setup (Phase 0 prerequisite)

```yaml
# pubspec.yaml
flutter:
  generate: true  # enables flutter gen-l10n

dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.x
```

```yaml
# l10n.yaml
arb-dir: lib/core/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

```dart
// main_*.dart
MaterialApp.router(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,  // [ar, en]
  locale: ref.watch(localeProvider),
  ...
)
```

---

## ARB File Structure

```json
// lib/core/l10n/app_en.arb
{
  "@@locale": "en",
  "searchStadiums": "Search Stadiums",
  "bookNow": "Book Now",
  "confirmBooking": "Confirm Booking",
  "slotTaken": "This slot was just booked. Please choose another.",
  "chatOnWhatsapp": "Chat on WhatsApp",
  "callStadium": "Call Stadium",
  "depositNote": "Deposit is informational. Pay full amount in cash at the stadium.",
  ...
}

// lib/core/l10n/app_ar.arb
{
  "@@locale": "ar",
  "searchStadiums": "ابحث عن ملاعب",
  "bookNow": "احجز الآن",
  "confirmBooking": "تأكيد الحجز",
  "slotTaken": "تم حجز هذا الموعد للتو. يرجى اختيار موعد آخر.",
  "chatOnWhatsapp": "تواصل عبر واتساب",
  "callStadium": "اتصل بالملعب",
  "depositNote": "المبلغ المبدئي تقريبي. يتم الدفع الكامل نقداً في الملعب.",
  ...
}
```

**Rule:** Never use hardcoded strings in widget code. Always use `AppLocalizations.of(context)!.key`.

---

## RTL Layout

Flutter handles RTL automatically when locale is `ar` via `Directionality`.

**Checklist per screen:**
- [ ] `TextAlign` not hardcoded to `left` — use `TextAlign.start` or omit (defaults to LTR/RTL)
- [ ] `EdgeInsets` uses `.symmetric` or `.only(start/end)` — not `left/right`
- [ ] `Row` children order: visually correct in both directions (use `Directionality.of(context)` if needed)
- [ ] Icons that convey direction (arrows, chevrons) use `Icons.arrow_forward` which auto-mirrors in RTL
- [ ] `ListTile` leading/trailing: correct in both directions

---

## Date & Time Formatting

All times stored in UTC by the backend. Display in `Africa/Cairo` (UTC+2).

```dart
// core/utils/date_formatter.dart
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

String formatSlotTime(DateTime utcTime, String locale) {
  final cairo = tz.getLocation('Africa/Cairo');
  final local = tz.TZDateTime.from(utcTime, cairo);
  final format = locale == 'ar'
    ? DateFormat('hh:mm a', 'ar')
    : DateFormat('hh:mm a', 'en');
  return format.format(local);
}
```

- Use `intl` package for locale-aware number formatting (Arabic-Indic numerals when `locale=ar` if required by design)
- Registration deadline dates: format as `dd/MM/yyyy` in both locales for consistency

---

## API Bilingual Fields

API returns `name_ar` and `name_en` separately. Select based on current locale:

```dart
// domain/entities/localized_string.dart
extension StadiumLocale on StadiumDetail {
  String localizedName(String locale) =>
    locale == 'ar' ? nameAr : nameEn;

  String localizedDescription(String locale) =>
    locale == 'ar' ? descriptionAr : descriptionEn;
}
```

Access via `ref.watch(localeProvider).languageCode`.

---

## Locale Persistence

```dart
// core/providers/locale_provider.dart
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final saved = Hive.box('settings').get('locale', defaultValue: 'ar');
  return LocaleNotifier(Locale(saved));
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(super.state);
  void toggle() {
    final next = state.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    Hive.box('settings').put('locale', next.languageCode);
    state = next;
  }
}
```

Default locale: Arabic (`ar`) — primary market.

---

## Deliverable

All strings in ARB files — no hardcoded user-facing text in widgets.  
Arabic RTL layout renders correctly on every screen.  
Locale toggle in profile persists across restarts.  
Dates and times displayed in Cairo timezone.
