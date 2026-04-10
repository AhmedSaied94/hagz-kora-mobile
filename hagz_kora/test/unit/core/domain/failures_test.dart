import 'package:flutter_test/flutter_test.dart';
import 'package:hagz_kora/core/domain/failures.dart';

void main() {
  group('Failure equality (Equatable)', () {
    test('NetworkFailure equal when same message', () {
      expect(const NetworkFailure(), equals(const NetworkFailure()));
    });

    test('NetworkFailure not equal to different message', () {
      expect(
        const NetworkFailure('timeout'),
        isNot(equals(const NetworkFailure())),
      );
    });

    test('ServerFailure includes statusCode in props', () {
      const a = ServerFailure(message: 'oops', statusCode: 500);
      const b = ServerFailure(message: 'oops', statusCode: 502);
      expect(a, isNot(equals(b)));
    });

    test('ServerFailure equal when message and statusCode match', () {
      const a = ServerFailure(message: 'oops', statusCode: 500);
      const b = ServerFailure(message: 'oops', statusCode: 500);
      expect(a, equals(b));
    });

    test('ValidationFailure includes fieldErrors in props', () {
      const a = ValidationFailure(
        message: 'bad input',
        fieldErrors: {
          'email': ['invalid'],
        },
      );
      const b = ValidationFailure(message: 'bad input');
      expect(a, isNot(equals(b)));
    });

    test('different Failure subclasses are not equal', () {
      expect(
        const NetworkFailure(),
        isNot(equals(const UnexpectedFailure())),
      );
    });
  });

  group('Failure default messages', () {
    test('NetworkFailure has expected default', () {
      expect(const NetworkFailure().message, 'No internet connection.');
    });

    test('UnauthorizedFailure has expected default', () {
      expect(
        const UnauthorizedFailure().message,
        'Session expired. Please log in again.',
      );
    });

    test('NotFoundFailure has expected default', () {
      expect(
        const NotFoundFailure().message,
        'The requested resource was not found.',
      );
    });

    test('CacheFailure has expected default', () {
      expect(
        const CacheFailure().message,
        'A local storage error occurred.',
      );
    });

    test('UnexpectedFailure has expected default', () {
      expect(
        const UnexpectedFailure().message,
        'An unexpected error occurred.',
      );
    });
  });

  group('Failure type checks', () {
    test('can switch exhaustively on Failure subtypes', () {
      const failures = <Failure>[
        NetworkFailure(),
        ServerFailure(message: 'err', statusCode: 503),
        UnauthorizedFailure(),
        NotFoundFailure(),
        ValidationFailure(message: 'bad'),
        CacheFailure(),
        UnexpectedFailure(),
      ];

      for (final f in failures) {
        final label = switch (f) {
          NetworkFailure() => 'network',
          ServerFailure() => 'server',
          UnauthorizedFailure() => 'unauthorized',
          NotFoundFailure() => 'notFound',
          ValidationFailure() => 'validation',
          CacheFailure() => 'cache',
          UnexpectedFailure() => 'unexpected',
        };
        expect(label, isNotEmpty);
      }
    });
  });
}
