import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:btludptdd/core/routing/app_routes.dart';

class CustomerBottomNav extends StatefulWidget {
  final int initialIndex;
  const CustomerBottomNav({super.key, required this.initialIndex});

  @override
  State<CustomerBottomNav> createState() => _CustomerBottomNavState();
}

class _CustomerBottomNavState extends State<CustomerBottomNav> {
  late int currentIndex;

  final List<IconData> _icons = [
    Icons.home,
    Icons.favorite,
    Icons.shopping_cart, // Index 2: Giỏ hàng
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();
    // ✅ QUAN TRỌNG: Gán currentIndex bằng initialIndex từ ShellRoute
    currentIndex = widget.initialIndex;
  }

  // ✅ Thêm didUpdateWidget để đảm bảo cập nhật khi ShellRoute gửi index mới
  @override
  void didUpdateWidget(covariant CustomerBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      setState(() {
        currentIndex = widget.initialIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration( // Cần const nếu style cố định
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -1))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_icons.length, (index) {
          final isSelected = currentIndex == index;
          return GestureDetector(
            onTap: () {
              // KHÔNG CẦN setState ở đây vì ShellRoute sẽ tự rebuild
              // Ta chỉ cần gọi hàm điều hướng
              _onItemTapped(context, index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.pinkAccent.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Colors.pinkAccent
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Icon(
                _icons[index],
                color: isSelected ? Colors.pinkAccent : Colors.grey,
                size: 26,
              ),
            ),
          );
        }),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0: // Trang chủ
        context.go(AppRoutes.home);
        break;
      case 1: // Trái tim (Yêu thích)
      // ✅ Index 1 chỉ dẫn đến Favourites
        context.go(AppRoutes.favourites);
        break;
      case 2: // Giỏ hàng/Sản phẩm (Index 2)
      // ✅ Cập nhật logic để index 2 dẫn đến Products/Cart
        context.go(AppRoutes.products);
        break;
      case 3: // Cá nhân
        context.go(AppRoutes.profile);
        break;
    }
  }
}