import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../data/models/post_model.dart';
import '../../data/models/user_model.dart';
import 'loading_widget.dart';

/// Data class representing a location with post count.
class LocationWithPostCount {
  final User user;
  final int postCount;
  final LatLng coordinates;

  const LocationWithPostCount({
    required this.user,
    required this.postCount,
    required this.coordinates,
  });
}

class LocationMapWidget extends StatefulWidget {
  final List<Post> posts;
  final List<User> users;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRetry;

  const LocationMapWidget({
    super.key,
    required this.posts,
    required this.users,
    this.isLoading = false,
    this.error,
    this.onRetry,
  });

  @override
  State<LocationMapWidget> createState() => _LocationMapWidgetState();
}

class _LocationMapWidgetState extends State<LocationMapWidget> {
  final MapController _mapController = MapController();
  LocationWithPostCount? _selectedLocation;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  /// Calculates post counts per user location.
  List<LocationWithPostCount> _calculateLocationData() {
    // Count posts per user
    final postCountByUser = <int, int>{};
    for (final post in widget.posts) {
      postCountByUser[post.userId] = (postCountByUser[post.userId] ?? 0) + 1;
    }

    // Create location data with post counts
    final locations = <LocationWithPostCount>[];
    for (final user in widget.users) {
      final postCount = postCountByUser[user.id] ?? 0;
      if (postCount > 0) {
        locations.add(
          LocationWithPostCount(
            user: user,
            postCount: postCount,
            coordinates: LatLng(user.address.geo.lat, user.address.geo.lng),
          ),
        );
      }
    }

    return locations;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const LoadingWidget(message: 'Loading map data...');
    }

    if (widget.error != null) {
      return AppErrorWidget(message: widget.error!, onRetry: widget.onRetry);
    }

    if (widget.users.isEmpty || widget.posts.isEmpty) {
      return const EmptyStateWidget(
        title: 'No location data',
        subtitle: 'There is no location data to display on the map.',
        icon: Icons.map_outlined,
      );
    }

    final locationData = _calculateLocationData();

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: const LatLng(20, 0),
            initialZoom: 2,
            minZoom: 1,
            maxZoom: 18,
            onTap: (_, __) {
              setState(() {
                _selectedLocation = null;
              });
            },
          ),
          children: [
            // OpenStreetMap tile layer
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.task1',
            ),
            // Markers layer
            MarkerLayer(
              markers: locationData.map((location) {
                return Marker(
                  point: location.coordinates,
                  width: 80,
                  height: 80,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLocation = location;
                      });
                    },
                    child: _buildMarker(location),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        // Legend
        Positioned(
          top: 16,
          right: 16,
          child: _buildLegend(context, locationData.length),
        ),
        // Selected location info card
        if (_selectedLocation != null)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildLocationInfoCard(context, _selectedLocation!),
          ),
      ],
    );
  }

  Widget _buildMarker(LocationWithPostCount location) {
    final isSelected = _selectedLocation?.user.id == location.user.id;
    final size = _getMarkerSize(location.postCount);
    final markerColor = isSelected
        ? const Color(0xFFF59E0B) // Amber when selected
        : const Color(0xFF6366F1); // Indigo default

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [markerColor, markerColor.withValues(alpha: 0.8)],
            ),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: markerColor.withValues(alpha: 0.4),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '${location.postCount}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: size * 0.38,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
        // Triangle pointer
        CustomPaint(
          size: const Size(14, 10),
          painter: _TrianglePainter(color: markerColor),
        ),
      ],
    );
  }

  double _getMarkerSize(int postCount) {
    // Scale marker size based on post count
    if (postCount <= 5) return 36;
    if (postCount <= 10) return 44;
    if (postCount <= 15) return 52;
    return 60;
  }

  Widget _buildLegend(BuildContext context, int totalLocations) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'Post Locations',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$totalLocations users',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tap marker for details',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfoCard(
    BuildContext context,
    LocationWithPostCount location,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
                  ),
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.transparent,
                  child: Text(
                    location.user.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.user.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '@${location.user.username}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () {
                    setState(() {
                      _selectedLocation = null;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            Icons.article_rounded,
            'Posts',
            '${location.postCount} posts',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            Icons.location_on_rounded,
            'Location',
            '${location.user.address.city}, ${location.user.address.street}',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            Icons.email_rounded,
            'Email',
            location.user.email,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            Icons.business_rounded,
            'Company',
            location.user.company.name,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Custom painter for the triangle pointer below the marker.
class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
