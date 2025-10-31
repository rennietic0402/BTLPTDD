import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routing/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Lê Thanh Thảo"),
            accountEmail: Text("rennietic@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?img=3',
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Trang chủ'),
            onTap: () => context.go(AppRoutes.home),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Yêu thích'),
            // onTap: () => context.push(AppRoutes.products),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Giỏ hàng'),
            // onTap: () => context.push(AppRoutes.customers),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Cá nhân'),
            // onTap: () => context.push(AppRoutes.profile),
          ),
        ],
      ),
    );
  }
}
