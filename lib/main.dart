import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/user_directory/presentation/providers/user_directory_provider.dart';
import 'features/user_directory/presentation/screens/user_directory_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Directory',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
      ),
      home: ChangeNotifierProvider(
        create: (_) => UserDirectoryProvider(),
        child: const UserDirectoryScreen(),
      ),
    );
  }
}
