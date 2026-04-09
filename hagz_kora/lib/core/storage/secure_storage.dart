import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wrapper around [FlutterSecureStorage] for token management.
///
/// Uses Keychain on iOS and EncryptedSharedPreferences on Android.
/// Never store tokens in SharedPreferences.
class SecureStorage {
  const SecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await Future.wait<void>([
      _storage.write(key: _kAccessToken, value: access),
      _storage.write(key: _kRefreshToken, value: refresh),
    ]);
  }

  Future<String?> getAccessToken() => _storage.read(key: _kAccessToken);

  Future<String?> getRefreshToken() => _storage.read(key: _kRefreshToken);

  Future<void> clearTokens() async {
    await Future.wait<void>([
      _storage.delete(key: _kAccessToken),
      _storage.delete(key: _kRefreshToken),
    ]);
  }

  Future<bool> hasTokens() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
