import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../core/constants/app_strings.dart';
import '../providers/emergency_provider.dart';
import 'emergency_state.dart';
import 'location_helper.dart';

class EmergencyController extends AutoDisposeNotifier<EmergencyScreenState> {
  WebSocketChannel? _channel;
  StreamSubscription? _wsSubscription;
  Timer? _simulationTimer;

  @override
  EmergencyScreenState build() {
    ref.onDispose(() {
      _wsSubscription?.cancel();
      _channel?.sink.close();
      _simulationTimer?.cancel();
    });
    return EmergencyScreenState();
  }

  Future<void> detectLocation() async {
    state = state.copyWith(isLocating: true, locationError: null);
    try {
      final locError = await LocationHelper.checkLocationServices();
      if (locError != null) {
        state = state.copyWith(locationError: locError, isLocating: false);
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      state = state.copyWith(
        userLat: pos.latitude,
        userLng: pos.longitude,
        isLocating: false,
      );
    } catch (e) {
      state = state.copyWith(
        locationError: '${AppStrings.locationDetectFailed}${e.toString()}',
        isLocating: false,
      );
    }
  }

  Future<void> submitRequest(String name, String condition, String phone) async {
    if (state.userLat == null || state.userLng == null) {
      throw Exception(AppStrings.locationNotDetected);
    }
    state = state.copyWith(isLoading: true, status: EmergencyStatus.dispatching);

    try {
      final response = await ref.read(emergencyRepositoryProvider).submitRequest({
        "patient_name": name,
        "condition": condition,
        "phone_number": phone,
        "latitude": state.userLat,
        "longitude": state.userLng,
      });
      _connectWebSocket((response['id'] ?? response['emergency_id'] ?? '1').toString());
    } catch (e) {
      state = state.copyWith(isLoading: false, status: EmergencyStatus.form);
      rethrow;
    }
  }

  void _connectWebSocket(String emergencyId) {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://10.0.2.2:8080/api/emergencies/$emergencyId/track'),
      );
      _wsSubscription = _channel!.stream.listen(_onWsMessage, onError: (_) => _simulateTracking());
      Future.delayed(const Duration(seconds: 3), () {
        if (state.status == EmergencyStatus.dispatching) _simulateTracking();
      });
    } catch (e) {
      _simulateTracking();
    }
  }

  void _onWsMessage(dynamic message) {
    final data = jsonDecode(message as String) as Map<String, dynamic>;
    if (data['type'] == 'location_update') {
      state = state.copyWith(
        status: EmergencyStatus.tracking,
        isLoading: false,
        ambulanceLat: (data['ambulance_lat'] as num).toDouble(),
        ambulanceLng: (data['ambulance_lng'] as num).toDouble(),
        estimatedMinutes: (data['estimated_minutes'] as num).toInt(),
      );
    } else if (data['type'] == 'status_update' && data['status'] == 'Arrived') {
      state = state.copyWith(status: EmergencyStatus.arrived);
    }
  }

  void _simulateTracking() {
    final baseLat = state.userLat ?? -6.2088;
    final baseLng = state.userLng ?? 106.8456;
    double ambLat = baseLat + 0.015 + Random().nextDouble() * 0.005;
    double ambLng = baseLng + 0.015 + Random().nextDouble() * 0.005;
    int minutes = 8;

    state = state.copyWith(
      status: EmergencyStatus.tracking,
      ambulanceLat: ambLat,
      ambulanceLng: ambLng,
      estimatedMinutes: minutes,
      isLoading: false,
    );

    _simulationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      ambLat += (baseLat - ambLat) * 0.15;
      ambLng += (baseLng - ambLng) * 0.15;
      minutes = max(1, minutes - 1);

      if (sqrt(pow(baseLat - ambLat, 2) + pow(baseLng - ambLng, 2)) < 0.001) {
        timer.cancel();
        state = state.copyWith(
          ambulanceLat: baseLat,
          ambulanceLng: baseLng,
          estimatedMinutes: 0,
          status: EmergencyStatus.arrived,
        );
        return;
      }
      state = state.copyWith(
        ambulanceLat: ambLat,
        ambulanceLng: ambLng,
        estimatedMinutes: minutes,
      );
    });
  }
}

final emergencyControllerProvider = AutoDisposeNotifierProvider<EmergencyController, EmergencyScreenState>(() => EmergencyController());
