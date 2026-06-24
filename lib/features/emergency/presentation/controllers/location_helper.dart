import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/app_strings.dart';

class LocationHelper {
  static Future<String?> checkLocationServices() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return AppStrings.locationServiceDisabled;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return AppStrings.locationPermissionDenied;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return AppStrings.locationPermissionDeniedForever;
    }
    return null; // indicates success
  }
}
