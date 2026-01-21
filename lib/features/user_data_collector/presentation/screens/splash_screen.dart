import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authService = AuthService();
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_hasNavigated) {
        _hasNavigated = true;
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  Future<void> _checkAuthStatus() async {
    if (_hasNavigated) return;

    try {
      // Add a small delay for splash screen effect
      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted || _hasNavigated) return;

      // Check auth status with timeout
      bool isLoggedIn = false;
      try {
        isLoggedIn = await _authService.isLoggedIn().timeout(
          const Duration(seconds: 1),
          onTimeout: () => false,
        );
      } catch (e) {
        // If auth check fails, default to not logged in
        isLoggedIn = false;
      }

      if (!mounted || _hasNavigated) return;

      _hasNavigated = true;

      // Navigate based on auth status
      final route = isLoggedIn ? '/home' : '/login';
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(route);
      }
    } catch (e) {
      // If there's any error, navigate to login screen
      if (mounted && !_hasNavigated) {
        _hasNavigated = true;
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.supervised_user_circle_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
