import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hagz_kora/core/network/auth_interceptor.dart';
import 'package:hagz_kora/core/storage/secure_storage.dart';

/// Singleton Dio instance. Call [initialize] once at startup.
class DioClient {
  DioClient._({required this.dio});

  final Dio dio;

  static DioClient? _instance;

  static DioClient get instance {
    assert(_instance != null, 'DioClient.initialize() must be called before use.');
    return _instance!;
  }

  static DioClient initialize({
    required String baseUrl,
    required SecureStorage storage,
  }) {
    if (_instance != null) return _instance!;

    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    final dio = Dio(options);

    dio.interceptors.addAll([
      AuthInterceptor(dio: dio, storage: storage),
      if (kDebugMode)
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
    ]);

    _instance = DioClient._(dio: dio);
    return _instance!;
  }

  /// Resets the singleton — use only in tests.
  static void reset() => _instance = null;
}
