import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import 'tracking_info_sheet.dart';
import 'emergency_tracking_widgets.dart';
import 'emergency_markers.dart';

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
                buildPatientMarker(patientPos),
                buildAmbulanceMarker(ambPos),
              ],
            ),
          ],
        ),

        Positioned(top: 0, left: 0, right: 0, child: const TrackingTopBar()),

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
