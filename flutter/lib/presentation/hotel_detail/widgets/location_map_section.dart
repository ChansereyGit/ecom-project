import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationMapSection extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String hotelName;
  final String address;
  final List<Map<String, dynamic>> nearbyAttractions;

  const LocationMapSection({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.hotelName,
    required this.address,
    required this.nearbyAttractions,
  });

  @override
  State<LocationMapSection> createState() => _LocationMapSectionState();
}

class _LocationMapSectionState extends State<LocationMapSection> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    _markers = {
      Marker(
        markerId: const MarkerId('hotel'),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(
          title: widget.hotelName,
          snippet: widget.address,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
      ...widget.nearbyAttractions.map((attraction) {
        return Marker(
          markerId: MarkerId(attraction['id'].toString()),
          position: LatLng(
            attraction['latitude'] as double,
            attraction['longitude'] as double,
          ),
          infoWindow: InfoWindow(
            title: attraction['name'] as String,
            snippet: '${attraction['distance']} away',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );
      }).toSet(),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _showFullScreenMap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenMapScreen(
          latitude: widget.latitude,
          longitude: widget.longitude,
          hotelName: widget.hotelName,
          address: widget.address,
          nearbyAttractions: widget.nearbyAttractions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Location & Nearby',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: _showFullScreenMap,
                child: Row(
                  children: [
                    Text(
                      'View Full Map',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: 'open_in_new',
                      color: colorScheme.primary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Map preview
          Container(
            height: 25.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.latitude, widget.longitude),
                  zoom: 15.0,
                ),
                markers: _markers,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
                onTap: (_) => _showFullScreenMap(),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Address
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  widget.address,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Nearby attractions
          Text(
            'Nearby Attractions',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          ...widget.nearbyAttractions.take(5).map((attraction) {
            return _buildAttractionItem(context, attraction);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAttractionItem(
      BuildContext context, Map<String, dynamic> attraction) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: _getAttractionIcon(
                attraction['type'] as String, colorScheme.primary),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attraction['name'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  attraction['distance'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (attraction['rating'] != null) ...[
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'star',
                  color: AppTheme.warningLight,
                  size: 14,
                ),
                SizedBox(width: 0.5.w),
                Text(
                  (attraction['rating'] as double).toStringAsFixed(1),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _getAttractionIcon(String type, Color color) {
    String iconName;
    switch (type.toLowerCase()) {
      case 'restaurant':
        iconName = 'restaurant';
        break;
      case 'shopping':
        iconName = 'shopping_bag';
        break;
      case 'museum':
        iconName = 'museum';
        break;
      case 'park':
        iconName = 'park';
        break;
      case 'beach':
        iconName = 'beach_access';
        break;
      case 'airport':
        iconName = 'flight';
        break;
      case 'train':
        iconName = 'train';
        break;
      case 'hospital':
        iconName = 'local_hospital';
        break;
      default:
        iconName = 'place';
    }

    return CustomIconWidget(
      iconName: iconName,
      color: color,
      size: 16,
    );
  }
}

class _FullScreenMapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String hotelName;
  final String address;
  final List<Map<String, dynamic>> nearbyAttractions;

  const _FullScreenMapScreen({
    required this.latitude,
    required this.longitude,
    required this.hotelName,
    required this.address,
    required this.nearbyAttractions,
  });

  @override
  State<_FullScreenMapScreen> createState() => _FullScreenMapScreenState();
}

class _FullScreenMapScreenState extends State<_FullScreenMapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    _markers = {
      Marker(
        markerId: const MarkerId('hotel'),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(
          title: widget.hotelName,
          snippet: widget.address,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
      ...widget.nearbyAttractions.map((attraction) {
        return Marker(
          markerId: MarkerId(attraction['id'].toString()),
          position: LatLng(
            attraction['latitude'] as double,
            attraction['longitude'] as double,
          ),
          infoWindow: InfoWindow(
            title: attraction['name'] as String,
            snippet: '${attraction['distance']} away',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );
      }).toSet(),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.hotelName} - Location'),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'directions',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              // Handle get directions
            },
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 15.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        mapToolbarEnabled: true,
      ),
    );
  }
}
