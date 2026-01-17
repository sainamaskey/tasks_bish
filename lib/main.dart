import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/inventory.dart/presentation/providers/inventory_provider.dart';
import 'features/inventory.dart/presentation/screens/main_navigation_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InventoryProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: Brightness.light,
          ),
        ),
        home: const MainNavigationScreen(),
      ),
    );
  }
}
