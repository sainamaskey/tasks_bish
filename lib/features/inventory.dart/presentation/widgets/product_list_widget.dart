import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import 'product_card_widget.dart';

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({super.key, this.onProductTap});

  final void Function(String productName)? onProductTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        final inventory = provider.inventory;

        if (inventory.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'No products in inventory',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          itemCount: inventory.length,
          itemBuilder: (context, index) {
            final key = inventory.keys.elementAt(index);
            final stock = inventory[key] ?? 0;
            final isRestocking = provider.isRestocking(key);
            final isLowStock = stock < 5;
            final isOutOfStock = stock == 0;

            return ProductCardWidget(
              name: key,
              stock: stock,
              isRestocking: isRestocking,
              isLowStock: isLowStock,
              isOutOfStock: isOutOfStock,
              onRestock: () => provider.restockItem(key),
              onTap: onProductTap != null ? () => onProductTap!(key) : null,
            );
          },
        );
      },
    );
  }
}
