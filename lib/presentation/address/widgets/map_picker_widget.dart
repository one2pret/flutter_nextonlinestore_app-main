import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/theme/app_colors.dart';

class MapPickerWidget extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final ValueChanged<LatLng> onLocationPicked;

  const MapPickerWidget({
    super.key,
    this.initialLat,
    this.initialLng,
    required this.onLocationPicked,
  });

  @override
  State<MapPickerWidget> createState() => _MapPickerWidgetState();
}

class _MapPickerWidgetState extends State<MapPickerWidget> {
  final _mapController = MapController();
  LatLng _picked = const LatLng(-6.2088, 106.8456); // Jakarta default

  @override
  void initState() {
    super.initState();
    if (widget.initialLat != null && widget.initialLng != null) {
      _picked = LatLng(widget.initialLat!, widget.initialLng!);
    } else {
      _useCurrentLocation();
    }
  }

  Future<void> _useCurrentLocation() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }
    final pos = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() => _picked = LatLng(pos.latitude, pos.longitude));
    _mapController.move(_picked, 16);
    widget.onLocationPicked(_picked);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _picked,
              initialZoom: 15,
              onTap: (_, latlng) {
                setState(() => _picked = latlng);
                widget.onLocationPicked(latlng);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.jagoflutter.nextelektronik',
              ),
              MarkerLayer(markers: [
                Marker(
                  point: _picked,
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_on,
                      color: AppColors.error, size: 40),
                ),
              ]),
            ],
          ),
          Positioned(
            right: 12,
            top: 12,
            child: FloatingActionButton.small(
              backgroundColor: AppColors.white,
              onPressed: _useCurrentLocation,
              child: const Icon(Icons.my_location,
                  color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
