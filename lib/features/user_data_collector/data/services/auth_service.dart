import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _usernameKey = 'username';
  static const String _tokenKey = 'token';
  
  // In-memory fallback for demo mode
  static bool _inMemoryLoggedIn = false;
  static String? _inMemoryUsername;
  static String? _inMemoryToken;

  Future<bool> login(String username, String password) async {
    // For demo purposes, accept any non-empty credentials
    // In production, this would call an API endpoint
    if (username.isNotEmpty && password.isNotEmpty) {
      // Try to save to SharedPreferences, but don't fail if it doesn't work
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_isLoggedInKey, true);
        await prefs.setString(_usernameKey, username);
        await prefs.setString(_tokenKey, 'token_${DateTime.now().millisecondsSinceEpoch}');
      } catch (e) {
        // SharedPreferences failed (MissingPluginException or other), use in-memory storage
        // This is OK for demo mode
      }
      
      // Always set in-memory values (fallback)
      _inMemoryLoggedIn = true;
      _inMemoryUsername = username;
      _inMemoryToken = 'token_${DateTime.now().millisecondsSinceEpoch}';
      
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_usernameKey);
      await prefs.remove(_tokenKey);
    } catch (e) {
      // Ignore errors
    }
    
    // Clear in-memory values
    _inMemoryLoggedIn = false;
    _inMemoryUsername = null;
    _inMemoryToken = null;
  }

  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getBool(_isLoggedInKey);
      if (stored != null) {
        return stored;
      }
    } catch (e) {
      // SharedPreferences failed (MissingPluginException or other), check in-memory
    }
    return _inMemoryLoggedIn;
  }

  Future<String?> getUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_usernameKey);
      if (stored != null) {
        return stored;
      }
    } catch (e) {
      // SharedPreferences failed (MissingPluginException or other), check in-memory
    }
    return _inMemoryUsername;
  }

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_tokenKey);
      if (stored != null) {
        return stored;
      }
    } catch (e) {
      // SharedPreferences failed (MissingPluginException or other), check in-memory
    }
    return _inMemoryToken;
  }
}
