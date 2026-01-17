import 'package:flutter/material.dart';
import 'inventory_screen.dart';
import 'analytics_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const InventoryScreen(),
    const AnalyticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // Removes the ripple
          highlightColor: Colors.transparent, // Removes the click highlight
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          elevation: 8,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),

                child: Icon(
                  _currentIndex == 0
                      ? Icons.inventory_2_rounded
                      : Icons.inventory_2_outlined,
                  size: 24,
                ),
              ),
              label: 'Inventory',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),

                child: Icon(
                  _currentIndex == 1
                      ? Icons.analytics_rounded
                      : Icons.analytics_outlined,
                  size: 24,
                ),
              ),
              label: 'Analytics',
            ),
          ],
        ),
      ),
    );
  }
}
