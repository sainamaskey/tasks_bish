import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post_model.dart';
import '../models/user_model.dart';

/// Custom exception for API errors.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Service for interacting with the JSONPlaceholder API.
class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  
  final http.Client _client;

  /// Creates an [ApiService] with an optional HTTP client for testing.
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches all posts from the API.
  /// 
  /// Throws [ApiException] if the request fails.
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/posts'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body) as List<dynamic>;
        return jsonList
            .map((json) => Post.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          'Failed to load posts',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw ApiException('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException('Invalid response format: ${e.message}');
    }
  }

  /// Fetches all users from the API.
  /// 
  /// Throws [ApiException] if the request fails.
  Future<List<User>> fetchUsers() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/users'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body) as List<dynamic>;
        return jsonList
            .map((json) => User.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          'Failed to load users',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw ApiException('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException('Invalid response format: ${e.message}');
    }
  }

  /// Fetches both posts and users concurrently.
  /// 
  /// Returns a record containing both lists.
  /// Throws [ApiException] if either request fails.
  Future<({List<Post> posts, List<User> users})> fetchPostsAndUsers() async {
    final results = await Future.wait([
      fetchPosts(),
      fetchUsers(),
    ]);

    return (
      posts: results[0] as List<Post>,
      users: results[1] as List<User>,
    );
  }

  /// Disposes the HTTP client.
  void dispose() {
    _client.close();
  }
}
