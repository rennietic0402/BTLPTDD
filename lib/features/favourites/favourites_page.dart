import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../products/presentation/widgets/product_card.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/'), // Quay về trang Home
        ),
        title: const Text(
          "Mục Ưa Thích",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Sản phẩm bạn đã lưu:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            // Tái sử dụng ProductGrid để hiển thị sản phẩm,
            // nhưng sau này bạn sẽ cần một ProductGrid riêng
            // để chỉ hiển thị sản phẩm Yêu thích.
            // Hiện tại tôi sẽ dùng nó để mô phỏng hiển thị sản phẩm.
            ProductGrid(isFavoriteScreen: true), // 👈 Truyền flag isFavoriteScreen
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}