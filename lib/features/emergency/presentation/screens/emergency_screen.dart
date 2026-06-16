import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../providers/emergency_provider.dart';

enum EmergencyState { form, dispatching, tracking, arrived }

class EmergencyScreen extends ConsumerStatefulWidget {
  const EmergencyScreen({super.key});

  @override
  ConsumerState<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends ConsumerState<EmergencyScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _conditionController = TextEditingController();
  final _phoneController = TextEditingController();

  EmergencyState _currentState = EmergencyState.form;
  bool _isLoading = false;

  // Location
  double? _userLat;
  double? _userLng;
  bool _isLocating = false;
  String? _locationError;
  final MapController _formMapController = MapController();

  // Tracking
  WebSocketChannel? _channel;
  StreamSubscription? _wsSubscription;
  double? _ambulanceLat;
  double? _ambulanceLng;
  int _estimatedMinutes = 0;
  final MapController _trackingMapController = MapController();

  // Animations
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _arrivedController;
  late Animation<double> _arrivedScaleAnimation;
  late Animation<double> _arrivedOpacityAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _arrivedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _arrivedScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _arrivedController, curve: Curves.elasticOut),
    );
    _arrivedOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _arrivedController, curve: Curves.easeIn),
    );

    _detectLocation();
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _conditionController.dispose();
    _phoneController.dispose();
    _pulseController.dispose();
    _arrivedController.dispose();
    _wsSubscription?.cancel();
    _channel?.sink.close();
    super.dispose();
  }

  // ─── Location Detection ───────────────────────────────────────────────

  Future<void> _detectLocation() async {
    setState(() {
      _isLocating = true;
      _locationError = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Layanan lokasi tidak aktif. Aktifkan GPS Anda.';
          _isLocating = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Izin lokasi ditolak.';
            _isLocating = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError =
              'Izin lokasi ditolak permanen. Buka pengaturan untuk mengaktifkan.';
          _isLocating = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      if (mounted) {
        setState(() {
          _userLat = position.latitude;
          _userLng = position.longitude;
          _isLocating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationError = 'Gagal mendeteksi lokasi: ${e.toString()}';
          _isLocating = false;
        });
      }
    }
  }

  // ─── Submit ───────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_userLat == null || _userLng == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lokasi belum terdeteksi. Tunggu atau coba lagi.'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _currentState = EmergencyState.dispatching;
    });

    try {
      final response =
          await ref.read(emergencyRepositoryProvider).submitRequest({
        "patient_name": _patientNameController.text,
        "condition": _conditionController.text,
        "phone_number": _phoneController.text,
        "latitude": _userLat,
        "longitude": _userLng,
      });

      final emergencyId = response['id'] ?? response['emergency_id'] ?? '1';
      _connectWebSocket(emergencyId.toString());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ErrorHandler.getMessage(e), style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.errorRed, behavior: SnackBarBehavior.floating));

        setState(() {
          _isLoading = false;
          _currentState = EmergencyState.form;
        });
      }
    }
  }

  // ─── WebSocket ────────────────────────────────────────────────────────

  void _connectWebSocket(String emergencyId) {
    final wsUrl =
        Uri.parse('ws://10.0.2.2:8080/api/emergencies/$emergencyId/track');

    try {
      _channel = WebSocketChannel.connect(wsUrl);

      _wsSubscription = _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message as String) as Map<String, dynamic>;

          if (data['type'] == 'location_update') {
            setState(() {
              _currentState = EmergencyState.tracking;
              _ambulanceLat = (data['ambulance_lat'] as num).toDouble();
              _ambulanceLng = (data['ambulance_lng'] as num).toDouble();
              _estimatedMinutes = (data['estimated_minutes'] as num).toInt();
              _isLoading = false;
            });
          } else if (data['type'] == 'status_update' &&
              data['status'] == 'Arrived') {
            setState(() {
              _currentState = EmergencyState.arrived;
            });
            _arrivedController.forward();
          }
        },
        onError: (error) {
          // If WebSocket fails, simulate tracking for demo purposes
          _simulateTracking();
        },
        onDone: () {
          // Connection closed
        },
      );

      // If no data within 3 seconds, start simulation for demo
      Future.delayed(const Duration(seconds: 3), () {
        if (_currentState == EmergencyState.dispatching && mounted) {
          _simulateTracking();
        }
      });
    } catch (e) {
      _simulateTracking();
    }
  }

  void _simulateTracking() {
    if (!mounted) return;

    final random = Random();
    final baseLat = _userLat ?? -6.2088;
    final baseLng = _userLng ?? 106.8456;

    // Start ambulance ~2km away
    double ambLat = baseLat + 0.015 + random.nextDouble() * 0.005;
    double ambLng = baseLng + 0.015 + random.nextDouble() * 0.005;
    int minutes = 8;

    setState(() {
      _currentState = EmergencyState.tracking;
      _ambulanceLat = ambLat;
      _ambulanceLng = ambLng;
      _estimatedMinutes = minutes;
      _isLoading = false;
    });

    // Simulate ambulance approaching
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final dLat = (baseLat - ambLat) * 0.15;
      final dLng = (baseLng - ambLng) * 0.15;
      ambLat += dLat;
      ambLng += dLng;
      minutes = max(1, minutes - 1);

      final distance = sqrt(pow(baseLat - ambLat, 2) + pow(baseLng - ambLng, 2));

      if (distance < 0.001) {
        timer.cancel();
        setState(() {
          _ambulanceLat = baseLat;
          _ambulanceLng = baseLng;
          _estimatedMinutes = 0;
          _currentState = EmergencyState.arrived;
        });
        _arrivedController.forward();
        return;
      }

      setState(() {
        _ambulanceLat = ambLat;
        _ambulanceLng = ambLng;
        _estimatedMinutes = minutes;
      });
    });
  }

  // ─── Build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: _buildCurrentState(),
      ),
    );
  }

  Widget _buildCurrentState() {
    switch (_currentState) {
      case EmergencyState.form:
        return _buildFormState();
      case EmergencyState.dispatching:
        return _buildDispatchingState();
      case EmergencyState.tracking:
        return _buildTrackingState();
      case EmergencyState.arrived:
        return _buildArrivedState();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STATE 1: FORM
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildFormState() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: CustomScrollView(
      key: const ValueKey('form'),
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppColors.errorRed,
          foregroundColor: Colors.white,
          title: const Text(
            'Panggilan Darurat',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          flexibleSpace: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Opacity(
                    opacity: 0.4,
                    child: Image.asset('assets/header_logo.png', width: 220),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Warning banner
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.errorRed.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.errorRed.withOpacity(0.2)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: AppColors.errorRed, size: 32),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Gunakan layanan ini HANYA untuk kondisi gawat darurat yang mengancam nyawa.',
                                  style: TextStyle(
                                    color: AppColors.errorRed,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // GPS Location Section
                  _buildSectionLabel('LOKASI ANDA', Icons.my_location),
                  const SizedBox(height: 12),
                  _buildLocationCard(),

                  const SizedBox(height: 24),

                  // Form Fields
                  _buildSectionLabel('DATA PASIEN', Icons.person_outline),
                  const SizedBox(height: 12),
                  _buildFormField(
                    controller: _patientNameController,
                    hint: 'Nama Lengkap Pasien',
                    icon: Icons.person,
                  ),

                  const SizedBox(height: 14),
                  _buildFormField(
                    controller: _conditionController,
                    hint: 'Kondisi (cth: Pendarahan, Sesak Nafas)',
                    icon: Icons.medical_services_outlined,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 14),
                  _buildFormField(
                    controller: _phoneController,
                    hint: 'Nomor Telepon Aktif',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 32),

                  // Submit Button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.errorRed.withAlpha(100),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: (_isLoading || _userLat == null)
                          ? null
                          : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorRed,
                        disabledBackgroundColor: Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.emergency, size: 22),
                                SizedBox(width: 10),
                                Text(
                                  'PANGGIL AMBULANS SEKARANG',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
   ),
  );
}

  Widget _buildSectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textGrey),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textGrey,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.05),
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
            color: Colors.white.withOpacity(0.85),
            child: Column(
        children: [
          // Map Preview
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 180,
              child: _buildMapPreview(),
            ),
          ),
          // Location Info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _userLat != null
                        ? AppColors.successGreen.withAlpha(25)
                        : AppColors.errorRed.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _userLat != null
                        ? Icons.location_on
                        : Icons.location_searching,
                    color: _userLat != null
                        ? AppColors.successGreen
                        : AppColors.errorRed,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isLocating
                            ? 'Mendeteksi lokasi...'
                            : _locationError != null
                                ? 'Gagal mendeteksi'
                                : 'Lokasi terdeteksi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _locationError != null
                              ? AppColors.errorRed
                              : AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isLocating
                            ? 'Menggunakan GPS...'
                            : _locationError ?? '${_userLat?.toStringAsFixed(6)}, ${_userLng?.toStringAsFixed(6)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: _locationError != null
                              ? AppColors.errorRed
                              : AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_locationError != null || _isLocating)
                  IconButton(
                    onPressed: _isLocating ? null : _detectLocation,
                    icon: Icon(
                      Icons.refresh,
                      color: _isLocating
                          ? AppColors.textLightGrey
                          : AppColors.primary,
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
    if (_isLocating) {
      return Container(
        color: AppColors.backgroundLightGrey,
        child: const SkeletonLoader(
          width: double.infinity,
          height: double.infinity,
          borderRadius: 0,
        ),
      );
    }

    if (_locationError != null) {
      return Container(
        color: AppColors.backgroundLightGrey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off,
                  size: 36, color: AppColors.textLightGrey),
              const SizedBox(height: 8),
              Text(
                'Lokasi tidak tersedia',
                style:
                    TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    if (_userLat != null && _userLng != null) {
      return FlutterMap(
        mapController: _formMapController,
        options: MapOptions(
          initialCenter: LatLng(_userLat!, _userLng!),
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
                point: LatLng(_userLat!, _userLng!),
                width: 50,
                height: 50,
                child: const _PulsingLocationDot(),
              ),
            ],
          ),
        ],
      );
    }

    return Container(color: AppColors.backgroundLightGrey);
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(color: AppColors.textLightGrey, fontSize: 14),
        prefixIcon:
            Icon(icon, color: AppColors.primary, size: 22),
        filled: true,
        fillColor: AppColors.backgroundWhite,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.borderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.borderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.errorRed, width: 1.5),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STATE 2: DISPATCHING
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildDispatchingState() {
    return Container(
      key: const ValueKey('dispatching'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pulsating ambulance icon
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.errorRed.withAlpha(30),
                        border: Border.all(
                          color: AppColors.errorRed.withAlpha(
                              (100 * _pulseAnimation.value).toInt()),
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.local_hospital,
                        color: AppColors.errorRed,
                        size: 52,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              const Text(
                'Mencari Ambulans Terdekat...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Menghubungi unit darurat di sekitar Anda',
                style: TextStyle(
                  color: Colors.white.withAlpha(180),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withAlpha(25),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.errorRed),
                  minHeight: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STATE 3: TRACKING
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildTrackingState() {
    final patientPos = LatLng(_userLat ?? -6.2088, _userLng ?? 106.8456);
    final ambulancePos = LatLng(
      _ambulanceLat ?? patientPos.latitude + 0.01,
      _ambulanceLng ?? patientPos.longitude + 0.01,
    );

    return Stack(
      key: const ValueKey('tracking'),
      children: [
        // Full-screen map
        FlutterMap(
          mapController: _trackingMapController,
          options: MapOptions(
            initialCenter: LatLng(
              (patientPos.latitude + ambulancePos.latitude) / 2,
              (patientPos.longitude + ambulancePos.longitude) / 2,
            ),
            initialZoom: 14.5,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.mobatech.app',
            ),
            // Route line
            PolylineLayer(
              polylines: [
                Polyline(
                  points: [patientPos, ambulancePos],
                  strokeWidth: 4.0,
                  color: AppColors.primary,
                  pattern: StrokePattern.dashed(
                    segments: [12, 8],
                  ),
                ),
              ],
            ),
            // Markers
            MarkerLayer(
              markers: [
                // Patient marker
                Marker(
                  point: patientPos,
                  width: 80,
                  height: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.errorRed,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(40),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Text(
                          'Anda',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(Icons.location_on,
                          color: AppColors.errorRed, size: 36),
                    ],
                  ),
                ),
                // Ambulance marker
                Marker(
                  point: ambulancePos,
                  width: 80,
                  height: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565C0),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(40),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Text(
                          'Ambulans',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565C0),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1565C0).withAlpha(100),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.local_shipping,
                            color: Colors.white, size: 22),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        // Top status bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).padding.top + 12, 20, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(160),
                  Colors.transparent,
                ],
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
                  child: const Icon(Icons.emergency,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Pelacakan Ambulans',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
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
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom info sheet
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(30),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Row(
                    children: [
                      // ETA Circle
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF1565C0),
                              Color(0xFF0D47A1),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFF1565C0).withAlpha(80),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$_estimatedMinutes',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                            ),
                            const Text(
                              'min',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ambulans sedang menuju lokasi Anda',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Estimasi tiba dalam $_estimatedMinutes menit',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 24),

                // Driver info
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person,
                            color: AppColors.primary, size: 26),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pak Surya',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'B 1234 AMB • Ambulans Tipe A',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Call button
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.successGreen,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.successGreen.withAlpha(80),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar(); ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Menghubungi driver...'),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(Icons.phone,
                                  color: Colors.white, size: 22),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                    height:
                        MediaQuery.of(context).padding.bottom + 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STATE 4: ARRIVED
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildArrivedState() {
    return Container(
      key: const ValueKey('arrived'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _arrivedController,
            builder: (context, child) {
              return Opacity(
                opacity: _arrivedOpacityAnimation.value,
                child: Transform.scale(
                  scale: _arrivedScaleAnimation.value,
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Checkmark circle
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha(30),
                      border: Border.all(
                          color: Colors.white.withAlpha(60), width: 3),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Ambulans Telah Tiba!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tim medis sedang menuju lokasi Anda.\nTetap tenang dan tunggu di tempat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withAlpha(200),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Driver info card
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Colors.white.withAlpha(40)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.local_shipping,
                            color: Colors.white, size: 28),
                        SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pak Surya • B 1234 AMB',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Ambulans Tipe A',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Back to home button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF2E7D32),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Kembali ke Beranda',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Pulsing Location Dot Widget ──────────────────────────────────────────

class _PulsingLocationDot extends StatefulWidget {
  const _PulsingLocationDot();

  @override
  State<_PulsingLocationDot> createState() => _PulsingLocationDotState();
}

class _PulsingLocationDotState extends State<_PulsingLocationDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulse ring
            Container(
              width: 50 * _controller.value,
              height: 50 * _controller.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.errorRed
                    .withAlpha((80 * (1 - _controller.value)).toInt()),
              ),
            ),
            // Inner dot
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.errorRed,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.errorRed.withAlpha(80),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
