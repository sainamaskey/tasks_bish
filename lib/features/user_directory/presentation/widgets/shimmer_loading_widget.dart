import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A shimmer loading widget that displays placeholder cards while data loads
class ShimmerLoadingWidget extends StatelessWidget {
  final int itemCount;

  const ShimmerLoadingWidget({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) => const _ShimmerCard(),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surface,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar placeholder
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              const SizedBox(width: 16),
              // Text content placeholder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name placeholder
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Email placeholder
                    Container(
                      height: 12,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Post count placeholder
                    Container(
                      height: 12,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapShimmerLoadingWidget extends StatelessWidget {
  const MapShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surface,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
