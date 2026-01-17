import 'package:flutter/material.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({
    super.key,
    required this.name,
    required this.stock,
    required this.isRestocking,
    required this.isLowStock,
    required this.isOutOfStock,
    required this.onRestock,
    this.onTap,
  });

  final String name;
  final int stock;
  final bool isRestocking;
  final bool isLowStock;
  final bool isOutOfStock;
  final VoidCallback onRestock;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    if (isOutOfStock) {
      statusColor = Colors.red;
      statusText = "Out of Stock";
    } else if (isLowStock) {
      statusColor = Colors.orange;
      statusText = "Low Stock";
    } else {
      statusColor = Colors.green;
      statusText = "In Stock";
    }

    return Transform.scale(
      scale: 1,
      child: Opacity(
        opacity: 1,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: statusColor.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 6),
                spreadRadius: 0,
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onTap ?? onRestock,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "$stock units",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Restock button
                  Container(
                    decoration: BoxDecoration(
                      gradient: isRestocking
                          ? null
                          : LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                            ),
                      color: isRestocking ? Colors.grey.shade300 : null,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isRestocking
                          ? null
                          : [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: isRestocking ? null : onRestock,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!isRestocking) ...[
                                const Icon(
                                  Icons.add_shopping_cart_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                isRestocking ? "Restocking..." : "Restock",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
