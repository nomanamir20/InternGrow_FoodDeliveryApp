import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/restaurant_menu_screen.dart';
import '../../features/home/models/mock_restaurants.dart';
import '../../features/categories/screens/categories_screen.dart';
import '../../features/categories/screens/category_meals_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/product/screens/product_details_screen.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/address/screens/address_screen.dart';
import '../../features/orders/screens/order_tracking_screen.dart';
import '../../features/orders/screens/order_history_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../shared/widgets/splash_screen.dart';
import '../../shared/widgets/scaffold_with_nav_bar.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) => const SignUpScreen(),
    ),

    GoRoute(
      path: '${AppRoutes.home}/:restaurantId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['restaurantId'] ?? '';
        final restaurant = mockRestaurants.firstWhere(
          (r) => r.id == id,
          orElse: () => mockRestaurants.first,
        );
        return RestaurantMenuScreen(restaurant: restaurant);
      },
    ),
    GoRoute(
      path: '${AppRoutes.categories}/:category',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final category = state.pathParameters['category'] ?? '';
        return CategoryMealsScreen(category: category);
      },
    ),
    GoRoute(
      path: '${AppRoutes.productDetails}/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ProductDetailsScreen(mealId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.address,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AddressScreen(),
    ),
    GoRoute(
      path: '${AppRoutes.orderTracking}/:orderId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final orderId = state.pathParameters['orderId'] ?? '';
        return OrderTrackingScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: AppRoutes.orderHistory,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const OrderHistoryScreen(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.categories,
              builder: (context, state) => const CategoriesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.search,
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.cart,
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);