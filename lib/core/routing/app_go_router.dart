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
        builder: (context, state, child) {
          int currentIndex = _getIndexForLocation(state.matchedLocation);
          return Scaffold(
            body: child,
            bottomNavigationBar: CustomerBottomNav(initialIndex: currentIndex),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomePage(),
          ),
          // 👇 sau này bạn có thể thêm các trang khác ở đây
          // GoRoute(
          //   path: '/profile',
          //   builder: (context, state) => const ProfilePage(),
          // ),
        ],
      ),
    ],
  );

  static int _getIndexForLocation(String path) {
    if (path.startsWith('/')) return 0;
    // if (path.startsWith('/profile')) return 1;
    return 0;
  }
}
