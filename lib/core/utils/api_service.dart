import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

/// Centralized API service for making HTTP requests
class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Performs a GET request to the specified endpoint
  ///
  /// Returns the decoded JSON response
  /// Throws [ApiException], [NetworkException], [TimeoutException], or [ParseException]
  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    try {
      final response = await _client.get(uri).timeout(
            ApiConstants.requestTimeout,
            onTimeout: () => throw const TimeoutException(),
          );

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException(
        message: 'No internet connection. Please check your network.',
      );
    } on TimeoutException {
      throw const TimeoutException(
        message: 'Request timed out. Please try again.',
      );
    } on FormatException {
      throw const ParseException(
        message: 'Invalid response format from server.',
      );
    }
  }

  /// Handles the HTTP response and returns decoded JSON
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return json.decode(response.body);
      } on FormatException {
        throw const ParseException(
          message: 'Failed to parse server response.',
        );
      }
    } else if (response.statusCode == 404) {
      throw const ApiException(
        message: 'Resource not found.',
        statusCode: 404,
      );
    } else if (response.statusCode >= 500) {
      throw ApiException(
        message: 'Server error. Please try again later.',
        statusCode: response.statusCode,
      );
    } else {
      throw ApiException(
        message: 'Request failed.',
        statusCode: response.statusCode,
      );
    }
  }

  /// Disposes the HTTP client
  void dispose() {
    _client.close();
  }
}
