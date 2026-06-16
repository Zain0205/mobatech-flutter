import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/chatbot/presentation/screens/chatbot_screen.dart';
import '../../features/appointment/presentation/screens/appointment_screen.dart';
import '../../features/appointment/presentation/screens/user_appointments_screen.dart';
import '../../features/emergency/presentation/screens/emergency_screen.dart';
import '../../features/pharmacy/presentation/screens/pharmacy_main_screen.dart';
import '../../features/pharmacy/presentation/screens/checkout_screen.dart';
import '../../features/pharmacy/presentation/screens/order_tracking_screen.dart';
import '../../features/pharmacy/presentation/screens/cart_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/medical_records_screen.dart';
import '../../features/profile/presentation/screens/family_members_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/help_support_screen.dart';
import '../../features/home/presentation/screens/search_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/chatbot',
        builder: (context, state) => const ChatbotScreen(),
      ),
      GoRoute(
        path: '/appointment',
        builder: (context, state) => const AppointmentScreen(),
      ),
      GoRoute(
        path: '/appointment/user-appointments',
        builder: (context, state) => const UserAppointmentsScreen(),
      ),
      GoRoute(
        path: '/emergency',
        builder: (context, state) => const EmergencyScreen(),
      ),
      GoRoute(
        path: '/pharmacy',
        builder: (context, state) => const PharmacyMainScreen(),
      ),
      GoRoute(
        path: '/pharmacy/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/pharmacy/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/pharmacy/tracking',
        builder: (context, state) => const OrderTrackingScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/medical-records',
        builder: (context, state) => const MedicalRecordsScreen(),
      ),
      GoRoute(
        path: '/profile/family-members',
        builder: (context, state) => const FamilyMembersScreen(),
      ),
      GoRoute(
        path: '/profile/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/profile/help-support',
        builder: (context, state) => const HelpSupportScreen(),
      ),
    ],
  );
});
