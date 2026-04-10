import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hagz_kora/core/domain/failures.dart';
import 'package:hagz_kora/core/network/error_handler.dart';

// Helper to build a DioException with the given type and optional response.
DioException _dioException(
  DioExceptionType type, {
  Response<dynamic>? response,
  Object? error,
}) {
  return DioException(
    requestOptions: RequestOptions(path: '/test'),
    type: type,
    response: response,
    error: error,
  );
}

Response<dynamic> _response(int statusCode, dynamic data) => Response(
      requestOptions: RequestOptions(path: '/test'),
      statusCode: statusCode,
      data: data,
    );

void main() {
  group('ErrorHandler.handle — connection errors', () {
    test('connectionTimeout → NetworkFailure', () {
      final result = ErrorHandler.handle(
        _dioException(DioExceptionType.connectionTimeout),
      );
      expect(result, isA<NetworkFailure>());
    });

    test('sendTimeout → NetworkFailure', () {
      final result = ErrorHandler.handle(
        _dioException(DioExceptionType.sendTimeout),
      );
      expect(result, isA<NetworkFailure>());
    });

    test('receiveTimeout → NetworkFailure', () {
      final result = ErrorHandler.handle(
        _dioException(DioExceptionType.receiveTimeout),
      );
      expect(result, isA<NetworkFailure>());
    });

    test('connectionError → NetworkFailure', () {
      final result = ErrorHandler.handle(
        _dioException(DioExceptionType.connectionError),
      );
      expect(result, isA<NetworkFailure>());
    });

    test('unknown with SocketException message → NetworkFailure', () {
      final result = ErrorHandler.handle(
        _dioException(
          DioExceptionType.unknown,
          error: Exception('SocketException: connection refused'),
        ),
      );
      expect(result, isA<NetworkFailure>());
    });
  });

  group('ErrorHandler.handle — cancel / cert', () {
    test('cancel → UnexpectedFailure with cancelled message', () {
      final result = ErrorHandler.handle(
        _dioException(DioExceptionType.cancel),
      );
      expect(result, isA<UnexpectedFailure>());
      expect(result.message, 'Request cancelled.');
    });

    test('badCertificate → UnexpectedFailure with SSL message', () {
      final result = ErrorHandler.handle(
        _dioException(DioExceptionType.badCertificate),
      );
      expect(result, isA<UnexpectedFailure>());
      expect(result.message, 'SSL certificate error.');
    });
  });

  group('ErrorHandler.handle — HTTP status codes', () {
    test('400 with detail field → ValidationFailure with message', () {
      final result = ErrorHandler.handle(
        _dioException(
          DioExceptionType.badResponse,
          response: _response(400, {'detail': 'Email already exists.'}),
        ),
      );
      expect(result, isA<ValidationFailure>());
      expect(result.message, 'Email already exists.');
    });

    test('400 with field errors → ValidationFailure with fieldErrors', () {
      final result = ErrorHandler.handle(
        _dioException(
          DioExceptionType.badResponse,
          response: _response(400, {
            'email': ['Enter a valid email address.'],
            'phone': ['This field is required.'],
          }),
        ),
      );
      expect(result, isA<ValidationFailure>());
      final failure = result as ValidationFailure;
      expect(failure.fieldErrors['email'], contains('Enter a valid email address.'));
      expect(failure.fieldErrors['phone'], contains('This field is required.'));
    });

    test('401 → UnauthorizedFailure', () {
      final result = ErrorHandler.handle(
        _dioException(
          DioExceptionType.badResponse,
          response: _response(401, null),
        ),
      );
      expect(result, isA<UnauthorizedFailure>());
    });

    test('404 → NotFoundFailure', () {
      final result = ErrorHandler.handle(
        _dioException(
          DioExceptionType.badResponse,
          response: _response(404, null),
        ),
      );
      expect(result, isA<NotFoundFailure>());
    });

    test('422 → ValidationFailure', () {
      final result = ErrorHandler.handle(
        _dioException(
          DioExceptionType.badResponse,
          response: _response(422, {'message': 'Unprocessable.'}),
        ),
      );
      expect(result, isA<ValidationFailure>());
      expect(result.message, 'Unprocessable.');
    });

    test('500 → ServerFailure with status code', () {
      final result = ErrorHandler.handle(
        _dioException(
          DioExceptionType.badResponse,
          response: _response(500, {'detail': 'Internal error.'}),
        ),
      );
      expect(result, isA<ServerFailure>());
      final failure = result as ServerFailure;
      expect(failure.statusCode, 500);
      expect(failure.message, 'Internal error.');
    });

    test('503 with no body → ServerFailure with generic message', () {
      final result = ErrorHandler.handle(
        _dioException(
          DioExceptionType.badResponse,
          response: _response(503, null),
        ),
      );
      expect(result, isA<ServerFailure>());
      final failure = result as ServerFailure;
      expect(failure.statusCode, 503);
      expect(failure.message, contains('503'));
    });

    test('null response → UnexpectedFailure', () {
      final result = ErrorHandler.handle(
        _dioException(DioExceptionType.badResponse),
      );
      expect(result, isA<UnexpectedFailure>());
    });
  });

  group('ErrorHandler.handle — non-Dio errors', () {
    test('plain Exception → UnexpectedFailure', () {
      final result = ErrorHandler.handle(Exception('boom'));
      expect(result, isA<UnexpectedFailure>());
    });

    test('StateError → UnexpectedFailure', () {
      final result = ErrorHandler.handle(StateError('bad state'));
      expect(result, isA<UnexpectedFailure>());
    });
  });
}
