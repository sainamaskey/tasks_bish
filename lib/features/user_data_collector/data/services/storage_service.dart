import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_data_model.dart';

class StorageService {
  static const String _submissionsKey = 'form_submissions';
  
  // In-memory fallback storage
  static List<UserDataModel> _inMemorySubmissions = [];

  Future<void> saveSubmission(UserDataModel submission) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final submissions = await getSubmissions();
      submissions.add(submission);
      final jsonList = submissions.map((s) => s.toJson()).toList();
      await prefs.setString(_submissionsKey, json.encode(jsonList));
    } catch (e) {
      // SharedPreferences failed, use in-memory storage
      _inMemorySubmissions.add(submission);
    }
  }

  Future<List<UserDataModel>> getSubmissions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_submissionsKey);
      if (jsonString == null) {
        // If no stored data, return in-memory if available
        return _inMemorySubmissions;
      }
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => UserDataModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // SharedPreferences failed, return in-memory storage
      return _inMemorySubmissions;
    }
  }

  Future<void> clearSubmissions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_submissionsKey);
    } catch (e) {
      // Ignore errors
    }
    // Clear in-memory storage too
    _inMemorySubmissions.clear();
  }
}
