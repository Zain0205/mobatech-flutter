enum EmergencyStatus { form, dispatching, tracking, arrived }

class EmergencyScreenState {
  final EmergencyStatus status;
  final bool isLoading;
  final double? userLat;
  final double? userLng;
  final bool isLocating;
  final String? locationError;
  final double? ambulanceLat;
  final double? ambulanceLng;
  final int estimatedMinutes;

  EmergencyScreenState({
    this.status = EmergencyStatus.form,
    this.isLoading = false,
    this.userLat,
    this.userLng,
    this.isLocating = false,
    this.locationError,
    this.ambulanceLat,
    this.ambulanceLng,
    this.estimatedMinutes = 0,
  });

  EmergencyScreenState copyWith({
    EmergencyStatus? status,
    bool? isLoading,
    double? userLat,
    double? userLng,
    bool? isLocating,
    String? locationError,
    double? ambulanceLat,
    double? ambulanceLng,
    int? estimatedMinutes,
  }) {
    return EmergencyScreenState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      userLat: userLat ?? this.userLat,
      userLng: userLng ?? this.userLng,
      isLocating: isLocating ?? this.isLocating,
      locationError: locationError ?? this.locationError,
      ambulanceLat: ambulanceLat ?? this.ambulanceLat,
      ambulanceLng: ambulanceLng ?? this.ambulanceLng,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    );
  }
}
