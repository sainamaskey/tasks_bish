import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../providers/user_directory_provider.dart';

class PostsMapWidget extends StatefulWidget {
  final List<LocationPostCount> locations;

  const PostsMapWidget({super.key, required this.locations});

  @override
  State<PostsMapWidget> createState() => _PostsMapWidgetState();
}

class _PostsMapWidgetState extends State<PostsMapWidget> {
  final MapController _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.locations.isEmpty) {
      return const _EmptyMapState();
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(initialZoom: 2.0, minZoom: 1.0, maxZoom: 18.0),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.task1',
        ),

        MarkerLayer(markers: widget.locations.map(_buildMarker).toList()),
      ],
    );
  }

  Marker _buildMarker(LocationPostCount locationData) {
    return Marker(
      point: LatLng(locationData.location.lat, locationData.location.lng),
      width: 120,
      height: 80,
      child: _LocationMarker(locationData: locationData),
    );
  }
}

class _LocationMarker extends StatelessWidget {
  final LocationPostCount locationData;

  const _LocationMarker({required this.locationData});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${locationData.postCount} posts',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 2),

        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.location_on,
            color: colorScheme.onPrimary,
            size: 20,
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            locationData.cityName,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _EmptyMapState extends StatelessWidget {
  const _EmptyMapState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No location data available',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Location markers will appear once data is loaded',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
