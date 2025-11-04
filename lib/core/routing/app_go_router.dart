// lib/core/routing/app_go_router.dart

import 'package:btludptdd/features/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_page.dart';
import '../widgets/bottom_nav_bar.dart'; // 👈 nhớ import đúng file
import 'package:btludptdd/core/routing/app_routes.dart';
import '/features/auth/presentation/pages/login_page.dart';
import '/features/auth/presentation/pages/signup_page.dart';

class AppGoRouter {
  static final GoRouter router = GoRouter(
    // initialLocation: '/', // 👉 chạy thẳng vào Home
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupPage(),
      ),
      ShellRoute(
        navigatorKey: GlobalKey<NavigatorState>(),
        builder: (context, state, child) {
          final location = state.matchedLocation; // Lấy đường dẫn khớp
          int currentIndex = _getIndexForLocation(location);

          return Scaffold(
            body: child,
            // Ẩn Bottom Nav khi ở route chi tiết
            bottomNavigationBar: _shouldShowBottomNav(location)
                ? CustomerBottomNav(initialIndex: currentIndex)
                : null,
          );
        },
        routes: [
          // ROUTE 0: HOME
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomePage(),
          ),
          // ROUTE 1: FAVOURITES
          GoRoute(
            path: AppRoutes.favourites,
            builder: (context, state) => const FavouritesPage(),
          ),
          // ROUTE 2: PRODUCTS (Ví dụ: Giỏ hàng)
          GoRoute(
            path: AppRoutes.products,
            builder: (context, state) => const Center(child: Text("Cart Page")),
          ),
          // ROUTE 3: PROFILE
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfilePage(),
          ),

          // ✅ ROUTE CHI TIẾT SẢN PHẨM (Mở ngoài Shell)
          GoRoute(
            path: AppRoutes.productDetail, // Phải là '/product/:id'
            builder: (context, state) {
              final productId = state.pathParameters['id']!;
              return ProductDetailPage(productId: productId);
            },
          ),
        ],
      ),
    ],
  );

  // ✅ LOGIC TÍNH TOÁN INDEX CHO BOTTOM NAV
  static int _getIndexForLocation(String path) {
    if (path.startsWith(AppRoutes.favourites)) return 1;
    if (path.startsWith(AppRoutes.products)) return 2;
    if (path.startsWith(AppRoutes.profile)) return 3;
    if (path == AppRoutes.home) return 0;
    return 0;
  }

  // ✅ LOGIC ẨN/HIỆN BOTTOM NAV (Kiểm tra nếu path bắt đầu bằng /product)
  static bool _shouldShowBottomNav(String path) {
    // Nếu AppRoutes.productDetail = '/product/:id', ta chỉ cần kiểm tra '/product'
    const productDetailBase = '/product';

    // Trả về false (ẨN NAV) nếu đường dẫn bắt đầu bằng '/product'
    return !path.startsWith(productDetailBase);
  }
}