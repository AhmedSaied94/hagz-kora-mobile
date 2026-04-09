import 'package:dio/dio.dart';
import 'package:hagz_kora/core/storage/secure_storage.dart';

/// Attaches Bearer token to every request.
///
/// On 401: reads refresh token → calls token refresh endpoint →
/// stores new tokens → retries original request once.
/// On refresh failure: clears tokens and rethrows so callers can redirect to auth.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required Dio dio,
    required SecureStorage storage,
  })  : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final SecureStorage _storage;

  static const _kTokenRefreshPath = 'auth/token/refresh/';
  static const _kRetryKey = '__auth_retry__';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final isUnauthorized = response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra[_kRetryKey] == true;

    if (!isUnauthorized || alreadyRetried) {
      handler.next(err);
      return;
    }

    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await _storage.clearTokens();
        handler.next(err);
        return;
      }

      // Use a plain Dio instance to avoid interceptor loops.
      final refreshDio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));
      final refreshResponse = await refreshDio.post<Map<String, dynamic>>(
        _kTokenRefreshPath,
        data: {'refresh': refreshToken},
      );

      final newAccess = refreshResponse.data?['access'] as String?;
      final newRefresh = refreshResponse.data?['refresh'] as String?;

      if (newAccess == null) {
        await _storage.clearTokens();
        handler.next(err);
        return;
      }

      await _storage.saveTokens(
        access: newAccess,
        refresh: newRefresh ?? refreshToken,
      );

      // Retry original request with new token.
      final retryOptions = err.requestOptions
        ..headers['Authorization'] = 'Bearer $newAccess'
        ..extra[_kRetryKey] = true;

      final retryResponse = await _dio.fetch<dynamic>(retryOptions);
      handler.resolve(retryResponse);
    } on DioException {
      await _storage.clearTokens();
      handler.next(err);
    }
  }
}
