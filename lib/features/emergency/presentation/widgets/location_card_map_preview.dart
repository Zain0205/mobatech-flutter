import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import 'pulsing_location_dot.dart';

class LocationCardMapPreview extends StatelessWidget {
  final bool isLocating;
  final String? locationError;
  final double? userLat;
  final double? userLng;
  final MapController mapController;

  const LocationCardMapPreview({
    super.key,
    required this.isLocating,
    required this.locationError,
    required this.userLat,
    required this.userLng,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    if (isLocating) {
      return Container(
        color: AppColors.backgroundLightGrey,
        child: const SkeletonLoader(
          width: double.infinity,
          height: double.infinity,
          borderRadius: 0,
        ),
      );
    }
    if (locationError != null) {
      return Container(
        color: AppColors.backgroundLightGrey,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                size: 36,
                color: AppColors.textLightGrey,
              ),
              SizedBox(height: 8),
              Text(
                AppStrings.locationUnavailable,
                style: TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }
    if (userLat != null && userLng != null) {
      return FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: LatLng(userLat!, userLng!),
          initialZoom: 16.0,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.none,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.mobatech.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(userLat!, userLng!),
                width: 50,
                height: 50,
                child: const PulsingLocationDot(),
              ),
            ],
          ),
        ],
      );
    }
    return Container(color: AppColors.backgroundLightGrey);
  }
}
