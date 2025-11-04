// lib/features/products/presentation/widgets/product_grid.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../domain/usecases/get_products.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import 'package:btludptdd/core/routing/app_routes.dart';
import 'package:btludptdd/core/providers/favorite_provider.dart';

// ✅ Cần import Use Case mới
import '../../domain/usecases/get_filtered_products.dart';


class ProductGrid extends StatefulWidget {
  final bool isFavoriteScreen;
  final String? keyword;
  final String? category;

  const ProductGrid({
    super.key,
    this.isFavoriteScreen = false,
    this.keyword,
    this.category,
  });

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {

  @override
  void initState() {
    super.initState();
    // Khởi tạo ở đây là không cần thiết vì FutureBuilder sẽ gọi _loadFilteredProducts()
  }

  // Hàm tạo Future mới, phản ứng với tham số tìm kiếm/lọc
  Future<List<Product>> _loadFilteredProducts() {
    final remoteDS = ProductRemoteDataSourceImpl();
    final repo = ProductRepositoryImpl(remoteDS);

    final getFilteredProducts = GetFilteredProducts(repo);

    // Nếu không có bất kỳ bộ lọc hay keyword nào, gọi hàm GetAllProducts cũ
    if (widget.keyword == null && widget.category == null && !widget.isFavoriteScreen) {
      return GetAllProducts(repo).call();
    }

    // Nếu có bộ lọc, gọi hàm GetFilteredProducts
    return getFilteredProducts.call(
      keyword: widget.keyword,
      category: widget.category,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch Provider để rebuild widget khi trạng thái favorites thay đổi
    final favoriteProvider = context.watch<FavoriteProvider>();

    // Sử dụng Future mới, phản ứng với widget.keyword và widget.category
    return FutureBuilder<List<Product>>(
      future: _loadFilteredProducts(),
      builder: (context, AsyncSnapshot<List<Product>> snapshot) {
        // 1. Xử lý trạng thái Loading
        if (snapshot.connectionState == ConnectionState.waiting || favoriteProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Xử lý trạng thái Lỗi
        if (snapshot.hasError) {
          return Center(child: Text("Đã xảy ra lỗi: ${snapshot.error}"));
        }

        // 3. Lấy và Lọc Sản phẩm (Filter Favorites nếu cần)
        List<Product> products = snapshot.data ?? [];

        if (widget.isFavoriteScreen) {
          final favoriteIds = favoriteProvider.favoriteProductIds;
          products = products
              .where((p) => favoriteIds.contains(p.id))
              .toList();
        }

        // 4. Xử lý trạng thái Rỗng
        if (products.isEmpty) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text("Không có sản phẩm nào trong danh sách này."),
          ));
        }

        // 5. Build GridView
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.595,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final p = products[index];
            final isFav = favoriteProvider.isFavorite(p.id);

            return Stack(
              children: [
                // ✅ GESTURE DETECTOR CHO TOÀN BỘ KHỐI SẢN PHẨM (Điều hướng Chi tiết)
                GestureDetector(
                  onTap: () {
                    // Điều hướng (PUSH) đến trang chi tiết sản phẩm, truyền ID
                    context.push(AppRoutes.productDetail.replaceFirst(':id', p.id));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hiển thị Hình ảnh sản phẩm
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.asset(
                              "assets/images/${p.imageUrl}",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Icon(Icons.image_not_supported, color: Colors.grey, size: 40));
                              },
                            ),
                          ),
                        ),
                        // Hiển thị Thương hiệu và Giá
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.brand, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
                              Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                              const SizedBox(height: 4),
                              Text("${p.price.toInt()}đ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                              Text("${p.oldPrice.toInt()}đ", style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Discount tag
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)),
                    child: Text("-${p.discount.toInt()}%", style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),

                // Nút trái tim (Yêu thích) - Nằm ngoài GestureDetector chính
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      favoriteProvider.toggleFavorite(p);
                      context.go(AppRoutes.favourites);
                    },
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                      size: 26,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}