import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_page.dart';
import '../widgets/bottom_nav_bar.dart';// 👈 nhớ import đúng file

class AppGoRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // 👉 chạy thẳng vào Home
    debugLogDiagnostics: true,
    routes: [
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
            path: '/',
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
