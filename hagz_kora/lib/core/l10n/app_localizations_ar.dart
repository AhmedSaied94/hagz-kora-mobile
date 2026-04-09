// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'حجز كورة';

  @override
  String get continueButton => 'متابعة';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get saveButton => 'حفظ';

  @override
  String get editButton => 'تعديل';

  @override
  String get deleteButton => 'حذف';

  @override
  String get confirmButton => 'تأكيد';

  @override
  String get retryButton => 'إعادة المحاولة';

  @override
  String get backButton => 'رجوع';

  @override
  String get loading => 'جاري التحميل…';

  @override
  String get errorGeneric => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get errorNetwork => 'لا يوجد اتصال بالإنترنت.';

  @override
  String get errorUnauthorized => 'انتهت الجلسة. يرجى تسجيل الدخول مجددًا.';

  @override
  String get errorNotFound => 'العنصر المطلوب غير موجود.';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navSearch => 'البحث';

  @override
  String get navBookings => 'حجوزاتي';

  @override
  String get navTournaments => 'البطولات';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get authPhoneTitle => 'أدخل رقم هاتفك';

  @override
  String get authPhoneSubtitle => 'سنرسل لك رمز التحقق.';

  @override
  String get authPhonePlaceholder => 'رقم الهاتف';

  @override
  String get authOtpTitle => 'تحقق من رقمك';

  @override
  String authOtpSubtitle(String phone) {
    return 'أدخل الرمز المكون من 6 أرقام المُرسَل إلى $phone.';
  }

  @override
  String get authOtpResend => 'إعادة إرسال الرمز';

  @override
  String authOtpResendIn(int seconds) {
    return 'إعادة الإرسال خلال $secondsث';
  }

  @override
  String get homeNearbyStadiums => 'ملاعب قريبة منك';

  @override
  String get homePopularStadiums => 'الأكثر حجزًا';

  @override
  String get homeSeeAll => 'عرض الكل';

  @override
  String get searchPlaceholder => 'ابحث عن ملعب…';

  @override
  String get searchFilters => 'تصفية';

  @override
  String get searchNoResults => 'لا توجد ملاعب.';

  @override
  String get stadiumBookNow => 'احجز الآن';

  @override
  String stadiumReviews(int count) {
    return '$count تقييم';
  }

  @override
  String get stadiumOpen => 'مفتوح';

  @override
  String get stadiumClosed => 'مغلق';

  @override
  String get bookingSummaryTitle => 'ملخص الحجز';

  @override
  String get bookingConfirmTitle => 'تم تأكيد الحجز!';

  @override
  String get bookingDateLabel => 'التاريخ';

  @override
  String get bookingTimeLabel => 'الوقت';

  @override
  String get bookingDurationLabel => 'المدة';

  @override
  String get bookingPriceLabel => 'السعر';

  @override
  String get bookingDepositNote => 'ادفع العربون نقدًا في الملعب.';

  @override
  String get myBookingsTitle => 'حجوزاتي';

  @override
  String get myBookingsEmpty => 'لا توجد حجوزات بعد.';

  @override
  String get bookingStatusUpcoming => 'قادم';

  @override
  String get bookingStatusCompleted => 'مكتمل';

  @override
  String get bookingStatusCancelled => 'ملغي';

  @override
  String get profileTitle => 'ملفي الشخصي';

  @override
  String get profileEditTitle => 'تعديل الملف';

  @override
  String get profileNameLabel => 'الاسم الكامل';

  @override
  String get profileLogout => 'تسجيل الخروج';

  @override
  String get profileLogoutConfirm => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get tournamentsTitle => 'البطولات';

  @override
  String get tournamentDetailsTitle => 'تفاصيل البطولة';

  @override
  String get tournamentStandingsTitle => 'الترتيب';

  @override
  String get tournamentMyTeamTitle => 'فريقي';

  @override
  String get tournamentRegisterTeam => 'تسجيل فريق';

  @override
  String get tournamentJoinTeam => 'انضمام لفريق';

  @override
  String get reviewsTitle => 'التقييمات';

  @override
  String get reviewLeaveTitle => 'أضف تقييمًا';

  @override
  String get reviewRatingLabel => 'التقييم';

  @override
  String get reviewCommentLabel => 'التعليق';

  @override
  String get reviewSubmit => 'إرسال التقييم';

  @override
  String get reviewEmpty => 'لا توجد تقييمات بعد.';
}
