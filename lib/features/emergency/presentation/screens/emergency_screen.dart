import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';

import '../controllers/emergency_controller.dart';
import '../controllers/emergency_state.dart';
import '../widgets/emergency_form_view.dart';
import '../widgets/emergency_dispatching_view.dart';
import '../widgets/emergency_tracking_view.dart';
import '../widgets/emergency_arrived_view.dart';

class EmergencyScreen extends ConsumerStatefulWidget {
  const EmergencyScreen({super.key});

  @override
  ConsumerState<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends ConsumerState<EmergencyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _conditionController = TextEditingController();
  final _phoneController = TextEditingController();

  final MapController _formMapController = MapController();
  final MapController _trackingMapController = MapController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(emergencyControllerProvider.notifier).detectLocation(),
    );
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _conditionController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await ref
          .read(emergencyControllerProvider.notifier)
          .submitRequest(
            _patientNameController.text,
            _conditionController.text,
            _phoneController.text,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                ErrorHandler.getMessage(e),
                style: const TextStyle(color: AppColors.backgroundWhite),
              ),
              backgroundColor: AppColors.errorRed,
              behavior: SnackBarBehavior.floating,
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(emergencyControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: _buildCurrentState(state),
      ),
    );
  }

  Widget _buildCurrentState(EmergencyScreenState state) {
    switch (state.status) {
      case EmergencyStatus.form:
        return EmergencyFormView(
          formKey: _formKey,
          patientNameController: _patientNameController,
          conditionController: _conditionController,
          phoneController: _phoneController,
          userLat: state.userLat,
          userLng: state.userLng,
          isLocating: state.isLocating,
          locationError: state.locationError,
          formMapController: _formMapController,
          isLoading: state.isLoading,
          onDetectLocation: ref
              .read(emergencyControllerProvider.notifier)
              .detectLocation,
          onSubmit: _submit,
        );
      case EmergencyStatus.dispatching:
        return const EmergencyDispatchingView();
      case EmergencyStatus.tracking:
        return EmergencyTrackingView(
          userLat: state.userLat,
          userLng: state.userLng,
          ambulanceLat: state.ambulanceLat,
          ambulanceLng: state.ambulanceLng,
          estimatedMinutes: state.estimatedMinutes,
          trackingMapController: _trackingMapController,
        );
      case EmergencyStatus.arrived:
        return const EmergencyArrivedView();
    }
  }
}
