/// Flavor-specific configuration injected at app startup.
///
/// Values are set via --dart-define at build time:
///   flutter run -t lib/main_dev.dart --dart-define=FLAVOR=development
///   flutter run -t lib/main_prod.dart --dart-define=FLAVOR=production
enum AppFlavor { development, production }

enum AuthMode { emailPassword, phoneOtp }

class AppConfig {
  const AppConfig._({
    required this.flavor,
    required this.apiBaseUrl,
    required this.authMode,
  });

  final AppFlavor flavor;
  final String apiBaseUrl;
  final AuthMode authMode;

  static AppConfig? _instance;

  static AppConfig get instance {
    assert(
      _instance != null,
      'AppConfig not initialized. Call AppConfig.setup() first.',
    );
    return _instance!;
  }

  static void setup(AppConfig config) {
    _instance = config;
  }

  static const AppConfig development = AppConfig._(
    flavor: AppFlavor.development,
    apiBaseUrl: 'http://10.0.2.2:8000/api/v1/',
    authMode: AuthMode.emailPassword,
  );

  static const AppConfig production = AppConfig._(
    flavor: AppFlavor.production,
    apiBaseUrl: 'https://api.hagzkora.com/api/v1/',
    authMode: AuthMode.phoneOtp,
  );

  bool get isProduction => flavor == AppFlavor.production;
  bool get isDevelopment => flavor == AppFlavor.development;
  bool get usesPhoneOtp => authMode == AuthMode.phoneOtp;
}
