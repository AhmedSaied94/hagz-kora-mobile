import 'package:equatable/equatable.dart';

/// Base class for all domain-level failures.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// No network connection.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

/// Server returned a non-2xx status.
final class ServerFailure extends Failure {
  const ServerFailure({required String message, this.statusCode})
    : super(message);

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// 401 — access token expired or invalid; refresh also failed.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Session expired. Please log in again.',
  ]);
}

/// 404 — requested resource not found.
final class NotFoundFailure extends Failure {
  const NotFoundFailure([
    super.message = 'The requested resource was not found.',
  ]);
}

/// 422 / 400 — validation error with field-level details.
final class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    this.fieldErrors = const {},
  }) : super(message);

  final Map<String, List<String>> fieldErrors;

  @override
  List<Object?> get props => [message, fieldErrors];
}

/// Local cache read/write error.
final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'A local storage error occurred.']);
}

/// Catch-all for unexpected errors.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);
}
