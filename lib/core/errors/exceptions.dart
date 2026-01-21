/// Base exception class for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Exception thrown when there is a network error
class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'Network error occurred'});

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when the request times out
class TimeoutException implements Exception {
  final String message;

  const TimeoutException({this.message = 'Request timed out'});

  @override
  String toString() => 'TimeoutException: $message';
}

/// Exception thrown when JSON parsing fails
class ParseException implements Exception {
  final String message;

  const ParseException({this.message = 'Failed to parse response'});

  @override
  String toString() => 'ParseException: $message';
}
