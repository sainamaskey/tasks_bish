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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 1,
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
