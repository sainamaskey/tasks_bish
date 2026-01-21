import 'package:flutter/material.dart';
import 'features/user_data_collector/presentation/screens/splash_screen.dart';
import 'features/user_data_collector/presentation/screens/login_screen.dart';
import 'features/user_data_collector/presentation/screens/home_screen.dart';
import 'features/user_data_collector/presentation/screens/form_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Data Collector',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF9CAF88), // Sage green
          secondary: const Color(0xFFE8B4B8), // Soft pink
          surface: const Color(0xFFFFF8F0), // Cream
          background: const Color(0xFFFFFBF5), // Warm white
          error: const Color(0xFFD4A5A5), // Soft red
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: const Color(0xFF5A5A5A), // Warm gray
          onBackground: const Color(0xFF5A5A5A),
          onError: Colors.white,
          tertiary: const Color(0xFFD4C5B9), // Beige
        ),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: const Color(0xFFFFF8F0),
          foregroundColor: const Color(0xFF9CAF88),
          titleTextStyle: const TextStyle(
            color: Color(0xFF5A5A5A),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9CAF88),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF9CAF88), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFD4A5A5), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xFFE8B4B8),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/form': (context) => const FormScreen(),
      },
    );
  }
}
