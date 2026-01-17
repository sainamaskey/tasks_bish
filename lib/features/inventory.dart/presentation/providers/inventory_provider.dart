import 'package:flutter/foundation.dart';

class InventoryProvider extends ChangeNotifier {
  // Mock Data: Product Name and Current Stock
  final Map<String, int> _inventory = {
    "MacBook Pro": 5,
    "iPhone 15": 12,
    "AirPods": 0,
  };

  // Track which items are currently being restocked
  final Set<String> _restockingItems = {};

  Map<String, int> get inventory => Map.unmodifiable(_inventory);

  Set<String> get restockingItems => Set.unmodifiable(_restockingItems);

  bool isRestocking(String name) => _restockingItems.contains(name);

  int getTotalStock() {
    return _inventory.values.fold(0, (sum, stock) => sum + stock);
  }

  int getLowStockCount() {
    return _inventory.values.where((stock) => stock < 5).length;
  }

  int getOutOfStockCount() {
    return _inventory.values.where((stock) => stock == 0).length;
  }

  Future<void> restockItem(String name) async {
    // Prevent multiple simultaneous restocks of the same item
    if (_restockingItems.contains(name)) {
      return;
    }

    // Add item to restocking set
    _restockingItems.add(name);
    notifyListeners();

    try {
      // Simulate async restocking operation
      await Future.delayed(const Duration(seconds: 2));

      // Update inventory
      _inventory[name] = (_inventory[name] ?? 0) + 1;
      _restockingItems.remove(name);
      notifyListeners();
    } catch (e) {
      // Handle any errors and ensure we remove from restocking set
      _restockingItems.remove(name);
      notifyListeners();
      rethrow;
    }
  }
}
