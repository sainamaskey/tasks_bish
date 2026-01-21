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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFFBF5),
              const Color(0xFFFFF8F0),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9CAF88).withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.local_florist,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'User Data Collector',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF5A5A5A),
                      letterSpacing: 0.5,
                    ),
              ),
              const SizedBox(height: 16),
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
