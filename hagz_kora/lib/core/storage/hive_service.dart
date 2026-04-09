import 'package:hive_flutter/hive_flutter.dart';

/// Manages Hive initialization and box access.
///
/// Call [initialize] once at app startup before opening any box.
class HiveService {
  HiveService._();

  static const _kStadiumCacheBox = 'stadium_cache';
  static const _kUserPrefsBox = 'user_prefs';

  static Future<void> initialize() async {
    await Hive.initFlutter();
  }

  static Future<Box<T>> openBox<T>(String name) => Hive.openBox<T>(name);

  static Future<Box<Map<dynamic, dynamic>>> get stadiumCacheBox =>
      openBox<Map<dynamic, dynamic>>(_kStadiumCacheBox);

  static Future<Box<dynamic>> get userPrefsBox =>
      openBox<dynamic>(_kUserPrefsBox);

  static Future<void> closeAll() => Hive.close();
}
