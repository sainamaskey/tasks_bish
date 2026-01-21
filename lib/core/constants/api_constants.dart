/// API constants for the JSONPlaceholder API
class ApiConstants {
  ApiConstants._();

  /// Base URL for the JSONPlaceholder API
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Users endpoint
  static const String usersEndpoint = '/users';

  /// Posts endpoint
  static const String postsEndpoint = '/posts';

  /// Request timeout duration
  static const Duration requestTimeout = Duration(seconds: 30);
}
