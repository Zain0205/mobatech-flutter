import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import 'pulsing_location_dot.dart';

class LocationCard extends StatelessWidget {
  final double? userLat;
  final double? userLng;
  final bool isLocating;
  final String? locationError;
  final MapController formMapController;
  final VoidCallback onDetectLocation;

  const LocationCard({
    super.key,
    required this.userLat,
    required this.userLng,
    required this.isLocating,
    required this.locationError,
    required this.formMapController,
    required this.onDetectLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: AppColors.backgroundWhite.withAlpha(217),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: SizedBox(
                    height: 180,
                    child: _buildMapPreview(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: userLat != null
                              ? AppColors.successGreen.withAlpha(25)
                              : AppColors.errorRed.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          userLat != null ? Icons.location_on : Icons.location_searching,
                          color: userLat != null ? AppColors.successGreen : AppColors.errorRed,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isLocating
                                  ? AppStrings.detectingLocation
                                  : locationError != null
                                      ? AppStrings.detectFailed
                                      : AppStrings.locationDetected,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: locationError != null ? AppColors.errorRed : AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isLocating
                                  ? AppStrings.usingGps
                                  : locationError ?? '${userLat?.toStringAsFixed(6)}, ${userLng?.toStringAsFixed(6)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: locationError != null ? AppColors.errorRed : AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (locationError != null || isLocating)
                        IconButton(
                          onPressed: isLocating ? null : onDetectLocation,
                          icon: Icon(
                            Icons.refresh,
                            color: isLocating ? AppColors.textLightGrey : AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
    if (isLocating) {
      return Container(
        color: AppColors.backgroundLightGrey,
        child: const SkeletonLoader(width: double.infinity, height: double.infinity, borderRadius: 0),
      );
    }
    if (locationError != null) {
      return Container(
        color: AppColors.backgroundLightGrey,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off, size: 36, color: AppColors.textLightGrey),
              SizedBox(height: 8),
              Text(AppStrings.locationUnavailable, style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
            ],
          ),
        ),
      );
    }
    if (userLat != null && userLng != null) {
      return FlutterMap(
        mapController: formMapController,
        options: MapOptions(
          initialCenter: LatLng(userLat!, userLng!),
          initialZoom: 16.0,
          interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
        ),
        children: [
          TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.mobatech.app'),
          MarkerLayer(markers: [Marker(point: LatLng(userLat!, userLng!), width: 50, height: 50, child: const PulsingLocationDot())]),
        ],
      );
    }
    return Container(color: AppColors.backgroundLightGrey);
  }
}
