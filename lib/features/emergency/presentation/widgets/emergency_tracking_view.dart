import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import 'tracking_info_sheet.dart';

class EmergencyTrackingView extends StatelessWidget {
  final double? userLat;
  final double? userLng;
  final double? ambulanceLat;
  final double? ambulanceLng;
  final int estimatedMinutes;
  final MapController trackingMapController;

  const EmergencyTrackingView({
    super.key,
    required this.userLat,
    required this.userLng,
    required this.ambulanceLat,
    required this.ambulanceLng,
    required this.estimatedMinutes,
    required this.trackingMapController,
  });

  @override
  Widget build(BuildContext context) {
    final patientPos = LatLng(userLat ?? -6.2088, userLng ?? 106.8456);
    final ambPos = LatLng(
      ambulanceLat ?? patientPos.latitude + 0.01,
      ambulanceLng ?? patientPos.longitude + 0.01,
    );

    return Stack(
      key: const ValueKey('tracking'),
      children: [
        FlutterMap(
          mapController: trackingMapController,
          options: MapOptions(
            initialCenter: LatLng(
              (patientPos.latitude + ambPos.latitude) / 2,
              (patientPos.longitude + ambPos.longitude) / 2,
            ),
            initialZoom: 14.5,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.mobatech.app',
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: [patientPos, ambPos],
                  strokeWidth: 4.0,
                  color: AppColors.primary,
                  pattern: StrokePattern.dashed(segments: [12, 8]),
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: patientPos,
                  width: 80,
                  height: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.errorRed,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 4)],
                        ),
                        child: const Text(
                          AppStrings.you,
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Icon(Icons.location_on, color: AppColors.errorRed, size: 36),
                    ],
                  ),
                ),
                Marker(
                  point: ambPos,
                  width: 80,
                  height: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.ambulanceBlue,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 4)],
                        ),
                        child: const Text(
                          AppStrings.ambulance,
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.ambulanceBlue,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: AppColors.ambulanceBlue.withAlpha(100), blurRadius: 8, spreadRadius: 2)],
                        ),
                        child: const Icon(Icons.local_shipping, color: Colors.white, size: 22),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withAlpha(160), Colors.transparent],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.emergency, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    AppStrings.ambulanceTracking,
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: Colors.white, size: 8),
                      SizedBox(width: 6),
                      Text(
                        AppStrings.live,
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: TrackingInfoSheet(estimatedMinutes: estimatedMinutes),
        ),
      ],
    );
  }
}
