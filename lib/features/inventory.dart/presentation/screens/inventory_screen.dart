import 'package:flutter/material.dart';
import '../widgets/inventory_header_widget.dart';
import '../widgets/product_list_widget.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            InventoryHeaderWidget(),
            // Product list
            Expanded(child: ProductListWidget(onProductTap: (productName) {})),
          ],
        ),
      ),
    );
  }
}
