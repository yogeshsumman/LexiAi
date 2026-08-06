/// Typed application exception with a user-friendly message.
///
/// All error mapping (DioException -> AppException) happens once, in
/// [BaseController.run], so screens only ever deal with readable messages.
class AppException implements Exception {
  const AppException(
    this.message, {
    this.statusCode,
    this.isNetworkError = false,
  });

  final String message;
  final int? statusCode;
  final bool isNetworkError;

  @override
  String toString() => message;
}

/// Friendly messages mapped from common failure modes.
class ErrorMessages {
  const ErrorMessages._();

  static const String timeout =
      'The connection timed out. Please check your network and try again.';
  static const String noInternet =
      'No internet connection. Connect and pull to refresh.';
  static const String unauthorized =
      'Your session has expired. Please sign in again.';
  static const String forbidden = 'You do not have permission to do that.';
  static const String notFound = 'The requested resource was not found.';
  static const String server =
      'Something went wrong on our side. Please try again shortly.';
  static const String generic = 'Something went wrong. Please try again.';
}
