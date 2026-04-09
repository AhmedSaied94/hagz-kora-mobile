/// Centralized route path constants.
abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';

  // Auth
  static const authPhone = '/auth/phone';
  static const authOtp = '/auth/otp';

  // Shell tabs
  static const homeFeed = '/home/feed';
  static const search = '/search';
  static const searchResults = '/search/results';
  static const stadiumDetail = '/stadiums/:id';
  static const bookSlot = '/stadiums/:id/book/:slotId';
  static const bookingConfirmation = '/bookings/:id/confirmation';
  static const myBookings = '/bookings';
  static const bookingDetail = '/bookings/:id';
  static const tournaments = '/tournaments';
  static const tournamentDetail = '/tournaments/:id';
  static const myTeam = '/tournaments/:id/my-team';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';

  // Helpers for parameterised paths
  static String stadiumDetailPath(String id) => '/stadiums/$id';
  static String bookSlotPath(String stadiumId, String slotId) =>
      '/stadiums/$stadiumId/book/$slotId';
  static String bookingConfirmationPath(String bookingId) =>
      '/bookings/$bookingId/confirmation';
  static String bookingDetailPath(String bookingId) => '/bookings/$bookingId';
  static String tournamentDetailPath(String id) => '/tournaments/$id';
  static String myTeamPath(String id) => '/tournaments/$id/my-team';
}
