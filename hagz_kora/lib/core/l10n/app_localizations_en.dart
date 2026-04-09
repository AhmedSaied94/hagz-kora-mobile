// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Hagz Kora';

  @override
  String get continueButton => 'Continue';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get saveButton => 'Save';

  @override
  String get editButton => 'Edit';

  @override
  String get deleteButton => 'Delete';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get retryButton => 'Retry';

  @override
  String get backButton => 'Back';

  @override
  String get loading => 'Loading…';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork => 'No internet connection.';

  @override
  String get errorUnauthorized => 'Session expired. Please log in again.';

  @override
  String get errorNotFound => 'The requested item was not found.';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navBookings => 'Bookings';

  @override
  String get navTournaments => 'Tournaments';

  @override
  String get navProfile => 'Profile';

  @override
  String get authPhoneTitle => 'Enter your phone number';

  @override
  String get authPhoneSubtitle => 'We\'ll send you a verification code.';

  @override
  String get authPhonePlaceholder => 'Phone number';

  @override
  String get authOtpTitle => 'Verify your number';

  @override
  String authOtpSubtitle(String phone) {
    return 'Enter the 6-digit code sent to $phone.';
  }

  @override
  String get authOtpResend => 'Resend code';

  @override
  String authOtpResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get homeNearbyStadiums => 'Nearby Stadiums';

  @override
  String get homePopularStadiums => 'Popular';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get searchPlaceholder => 'Search stadiums…';

  @override
  String get searchFilters => 'Filters';

  @override
  String get searchNoResults => 'No stadiums found.';

  @override
  String get stadiumBookNow => 'Book Now';

  @override
  String stadiumReviews(int count) {
    return '$count reviews';
  }

  @override
  String get stadiumOpen => 'Open';

  @override
  String get stadiumClosed => 'Closed';

  @override
  String get bookingSummaryTitle => 'Booking Summary';

  @override
  String get bookingConfirmTitle => 'Booking Confirmed!';

  @override
  String get bookingDateLabel => 'Date';

  @override
  String get bookingTimeLabel => 'Time';

  @override
  String get bookingDurationLabel => 'Duration';

  @override
  String get bookingPriceLabel => 'Price';

  @override
  String get bookingDepositNote => 'Pay deposit in cash at the venue.';

  @override
  String get myBookingsTitle => 'My Bookings';

  @override
  String get myBookingsEmpty => 'You have no bookings yet.';

  @override
  String get bookingStatusUpcoming => 'Upcoming';

  @override
  String get bookingStatusCompleted => 'Completed';

  @override
  String get bookingStatusCancelled => 'Cancelled';

  @override
  String get profileTitle => 'My Profile';

  @override
  String get profileEditTitle => 'Edit Profile';

  @override
  String get profileNameLabel => 'Full name';

  @override
  String get profileLogout => 'Log out';

  @override
  String get profileLogoutConfirm => 'Are you sure you want to log out?';

  @override
  String get tournamentsTitle => 'Tournaments';

  @override
  String get tournamentDetailsTitle => 'Tournament Details';

  @override
  String get tournamentStandingsTitle => 'Standings';

  @override
  String get tournamentMyTeamTitle => 'My Team';

  @override
  String get tournamentRegisterTeam => 'Register Team';

  @override
  String get tournamentJoinTeam => 'Join Team';

  @override
  String get reviewsTitle => 'Reviews';

  @override
  String get reviewLeaveTitle => 'Leave a Review';

  @override
  String get reviewRatingLabel => 'Rating';

  @override
  String get reviewCommentLabel => 'Comment';

  @override
  String get reviewSubmit => 'Submit Review';

  @override
  String get reviewEmpty => 'No reviews yet.';
}
