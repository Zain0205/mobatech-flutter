import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/chatbot/presentation/screens/chatbot_screen.dart';
import '../../features/for_you/presentation/screens/for_you_screen.dart';
import '../../features/for_you/presentation/screens/article_detail_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/home/presentation/screens/special_offers_screen.dart';
import '../../features/home/presentation/screens/offer_detail_screen.dart';
import '../../core/providers/mock_ui_providers.dart';
import '../../features/appointment/presentation/screens/appointment_screen.dart';
import '../../features/appointment/presentation/screens/user_appointments_screen.dart';
import '../../features/emergency/presentation/screens/emergency_screen.dart';
import '../../features/pharmacy/presentation/screens/pharmacy_main_screen.dart';
import '../../features/pharmacy/presentation/screens/checkout_screen.dart';
import '../../features/pharmacy/presentation/screens/order_tracking_screen.dart';
import '../../features/pharmacy/presentation/screens/cart_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/family_members_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/help_support_screen.dart';
import '../../features/home/presentation/screens/search_screen.dart';
import '../../features/patient_support/presentation/screens/notification_screen.dart';
import '../../features/patient_support/presentation/screens/medical_results_screen.dart';
import '../../features/patient_support/presentation/screens/medical_result_detail_screen.dart';
import '../../features/patient_support/data/models/medical_result.dart';

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
        builder: (context, state) => OrderTrackingScreen(
          order: state.extra as PharmacyOrderMock?,
        ),
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
        path: '/medical-results',
        builder: (context, state) => const MedicalResultsScreen(),
      ),
      GoRoute(
        path: '/medical-results/detail',
        builder: (context, state) => MedicalResultDetailScreen(
          result: state.extra as MedicalResult,
        ),
      ),
      GoRoute(
        path: '/profile/medical-records',
        redirect: (context, state) => '/medical-results',
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
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: '/for-you',
        builder: (context, state) => const ForYouScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/special-offers',
        builder: (context, state) => const SpecialOffersScreen(),
      ),
      GoRoute(
        path: '/for-you/detail',
        builder: (context, state) => ArticleDetailScreen(article: state.extra as Article),
      ),
      GoRoute(
        path: '/special-offers/detail',
        builder: (context, state) => OfferDetailScreen(offer: state.extra as SpecialOffer),
      ),
    ],
  );
});
