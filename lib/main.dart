import 'package:flutter/material.dart';
import 'features/task_manager.dart/presentation/screens/task_manager_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: TaskManagerScreen(),
    );
  }
}
