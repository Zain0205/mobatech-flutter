import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/for_you/presentation/screens/for_you_screen.dart';
import '../../features/for_you/presentation/screens/article_detail_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/home/presentation/screens/special_offers_screen.dart';
import '../../features/home/presentation/screens/offer_detail_screen.dart';
import '../../core/providers/mock_ui_providers.dart';
import '../../features/patient_support/presentation/screens/notification_screen.dart';
import 'app_router_parts.dart';
import '../network/dio_client.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = globalAuthToken != null;
      final isGoingToAuth = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/splash' ||
          state.matchedLocation == '/onboarding';

      if (!isLoggedIn && !isGoingToAuth) {
        return '/login';
      }
      return null;
    },
    routes: [
      ...authAndProfileRoutes,
      ...featureRoutes,
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
        builder: (context, state) =>
            ArticleDetailScreen(article: state.extra as Article),
      ),
      GoRoute(
        path: '/special-offers/detail',
        builder: (context, state) =>
            OfferDetailScreen(offer: state.extra as SpecialOffer),
      ),
    ],
  );
});
