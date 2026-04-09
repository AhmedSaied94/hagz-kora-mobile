import 'package:dio/dio.dart';
import 'package:hagz_kora/core/domain/failures.dart';

/// Maps [DioException] to typed [Failure] objects.
class ErrorHandler {
  const ErrorHandler._();

  static Failure handle(Object error) {
    if (error is DioException) {
      return _handleDioException(error);
    }
    return const UnexpectedFailure();
  }

  static Failure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return const UnexpectedFailure('Request cancelled.');

      case DioExceptionType.badCertificate:
        return const UnexpectedFailure('SSL certificate error.');

      case DioExceptionType.unknown:
        if (error.error != null && error.error.toString().contains('SocketException')) {
          return const NetworkFailure();
        }
        return const UnexpectedFailure();
    }
  }

  static Failure _handleResponseError(Response<dynamic>? response) {
    if (response == null) return const UnexpectedFailure();

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    switch (statusCode) {
      case 400:
        return ValidationFailure(
          message: _extractMessage(data) ?? 'Validation error.',
          fieldErrors: _extractFieldErrors(data),
        );

      case 401:
        return const UnauthorizedFailure();

      case 404:
        return const NotFoundFailure();

      case 422:
        return ValidationFailure(
          message: _extractMessage(data) ?? 'Unprocessable entity.',
          fieldErrors: _extractFieldErrors(data),
        );

      default:
        return ServerFailure(
          message: _extractMessage(data) ?? 'Server error ($statusCode).',
          statusCode: statusCode,
        );
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return (data['detail'] ?? data['message'])?.toString();
    }
    return null;
  }

  static Map<String, List<String>> _extractFieldErrors(dynamic data) {
    if (data is! Map<String, dynamic>) return {};
    return data.entries
        .where((e) => e.value is List)
        .fold({}, (acc, e) {
          acc[e.key] = (e.value as List).map((v) => v.toString()).toList();
          return acc;
        });
  }
}
