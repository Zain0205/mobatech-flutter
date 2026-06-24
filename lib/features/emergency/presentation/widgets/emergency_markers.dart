import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

Marker buildPatientMarker(LatLng position) {
  return Marker(
    point: position,
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
            boxShadow: [
              BoxShadow(color: AppColors.textDark.withAlpha(40), blurRadius: 4),
            ],
          ),
          child: const Text(
            AppStrings.you,
            style: TextStyle(
              color: AppColors.backgroundWhite,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Icon(Icons.location_on, color: AppColors.errorRed, size: 36),
      ],
    ),
  );
}

Marker buildAmbulanceMarker(LatLng position) {
  return Marker(
    point: position,
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
            boxShadow: [
              BoxShadow(color: AppColors.textDark.withAlpha(40), blurRadius: 4),
            ],
          ),
          child: const Text(
            AppStrings.ambulance,
            style: TextStyle(
              color: AppColors.backgroundWhite,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.ambulanceBlue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.ambulanceBlue.withAlpha(100),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.local_shipping,
            color: AppColors.backgroundWhite,
            size: 22,
          ),
        ),
      ],
    ),
  );
}
