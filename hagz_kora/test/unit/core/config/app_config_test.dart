import 'package:flutter_test/flutter_test.dart';
import 'package:hagz_kora/core/config/app_config.dart';

void main() {
  group('AppConfig.development', () {
    test('has development flavor', () {
      expect(AppConfig.development.flavor, AppFlavor.development);
    });

    test('uses local backend URL', () {
      expect(
        AppConfig.development.apiBaseUrl,
        'http://10.0.2.2:8000/api/v1/',
      );
    });

    test('uses email/password auth', () {
      expect(AppConfig.development.authMode, AuthMode.emailPassword);
    });

    test('isDevelopment returns true', () {
      expect(AppConfig.development.isDevelopment, isTrue);
    });

    test('isProduction returns false', () {
      expect(AppConfig.development.isProduction, isFalse);
    });
  });

  group('AppConfig.production', () {
    test('has production flavor', () {
      expect(AppConfig.production.flavor, AppFlavor.production);
    });

    test('uses production HTTPS URL', () {
      expect(
        AppConfig.production.apiBaseUrl,
        'https://api.hagzkora.com/api/v1/',
      );
    });

    test('uses phone OTP auth', () {
      expect(AppConfig.production.authMode, AuthMode.phoneOtp);
    });

    test('isProduction returns true', () {
      expect(AppConfig.production.isProduction, isTrue);
    });

    test('isDevelopment returns false', () {
      expect(AppConfig.production.isDevelopment, isFalse);
    });
  });

  group('AppConfig.setup / instance', () {
    // Restore development config after every test in this group so that
    // mutations to the global singleton do not bleed into other test files.
    tearDown(() => AppConfig.setup(AppConfig.development));

    test('instance returns the config set via setup()', () {
      AppConfig.setup(AppConfig.development);
      expect(AppConfig.instance.flavor, AppFlavor.development);
    });

    test('setup can be called multiple times (last wins)', () {
      AppConfig.setup(AppConfig.development);
      AppConfig.setup(AppConfig.production);
      expect(AppConfig.instance.flavor, AppFlavor.production);
    });
  });
}
