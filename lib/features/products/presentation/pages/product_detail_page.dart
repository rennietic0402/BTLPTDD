import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Import các lớp Clean Architecture cần thiết
import 'package:btludptdd/features/products/domain/entities/product.dart';
import 'package:btludptdd/features/products/data/datasources/product_remote_data_source.dart';
import 'package:btludptdd/features/products/data/repositories/product_repository_impl.dart';
import 'package:btludptdd/features/products/domain/usecases/get_product_by_id.dart';
import 'package:btludptdd/features/products/domain/usecases/get_filtered_products.dart';
import 'package:btludptdd/core/providers/favorite_provider.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // STATE: Quản lý phân loại được chọn
  String _selectedVariant = '01';
  final List<String> _variants = ['01', '02', '03'];

  // Biến Future để tải cả sản phẩm chính và sản phẩm liên quan
  late Future<(Product, List<Product>)> _productDataFuture;

  @override
  void initState() {
    super.initState();
    _productDataFuture = _loadProductData(widget.productId);
  }

  // Phương thức để tải dữ liệu sản phẩm chính và sản phẩm cùng hãng
  Future<(Product, List<Product>)> _loadProductData(String id) async {
    final remoteDS = ProductRemoteDataSourceImpl();
    final repo = ProductRepositoryImpl(remoteDS);

    final getProductById = GetProductById(repo);
    final product = await getProductById.call(id);

    final getFilteredProducts = GetFilteredProducts(repo);
    final relatedProducts = await getFilteredProducts.call(
      keyword: product.brand,
    );

    final finalRelatedProducts = relatedProducts
        .where((p) => p.id != product.id)
        .toList();

    return (product, finalRelatedProducts);
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<(Product, List<Product>)>(
        future: _productDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Lỗi tải dữ liệu: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final product = snapshot.data!.$1;
          final relatedProducts = snapshot.data!.$2;
          final isFav = favoriteProvider.isFavorite(product.id);

          return CustomScrollView(
            slivers: [
              // ✅ SLIVER APP BAR ĐÃ SỬA: Màu trắng và tiêu đề tĩnh
              SliverAppBar(
                expandedHeight: 400.0,
                pinned: true,
                backgroundColor: Colors.white, // ✅ Nền màu trắng
                foregroundColor: Colors.black, // Màu nút back
                elevation: 0,
                // ✅ TIÊU ĐỀ TĨNH: "Sản Phẩm"
                title: const Text(
                  "Sản Phẩm",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // ✅ ẢNH SẢN PHẨM KHÔNG CÓ VIỀN
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 80.0, bottom: 20),
                          // Sử dụng Container màu hồng nhạt làm nền cho ảnh (tùy chọn)
                          child: Container(
                            decoration: const BoxDecoration(
                              // Màu nền nhạt để ảnh nổi bật (tùy chọn)
                              color: Color(0xFFFAF0F3),
                            ),
                            child: Image.asset(
                              "assets/images/${product.imageUrl}",
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),

                      // Hiển thị tag discount
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '-${product.discount.toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Nút trái tim ở trang chi tiết
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        right: 16,
                        child: GestureDetector(
                          onTap: () {
                            favoriteProvider.toggleFavorite(product);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.grey,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên sản phẩm
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Star Rating
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const Icon(
                              Icons.star_half,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '56,890',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Giá
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${product.price.toInt()}đ',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.pinkAccent.shade700,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${product.oldPrice.toInt()}đ',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Chi tiết sản phẩm
                        const Text(
                          "Chi tiết sản phẩm",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                        const SizedBox(height: 24),

                        // Phân loại (có thể chọn)
                        const Text(
                          "Phân loại",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: _variants
                              .map(
                                (variant) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedVariant = variant;
                                    });
                                  },
                                  child: _buildCategoryButton(
                                    variant,
                                    _selectedVariant == variant,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 40),

                        // Có thể bạn sẽ thích (Sản phẩm cùng hãng)
                        const Text(
                          "Có thể bạn sẽ thích",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: relatedProducts.length,
                            itemBuilder: (context, index) {
                              final relatedP = relatedProducts[index];
                              return _buildRelatedProductCard(
                                relatedP,
                                favoriteProvider,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          );
        },
      ),
      // Thanh Bottom cố định (Thêm vào giỏ hàng / Mua ngay)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.pinkAccent,
                  side: const BorderSide(color: Colors.pinkAccent),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Thêm vào giỏ',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Mua ngay', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget tạo nút phân loại
  Widget _buildCategoryButton(String text, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.pink.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.pinkAccent : Colors.grey.shade300,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.pinkAccent : Colors.black87,
          ),
        ),
      ),
    );
  }

  // Widget dựng card sản phẩm gợi ý
  Widget _buildRelatedProductCard(
    Product product,
    FavoriteProvider favoriteProvider,
  ) {
    final isFav = favoriteProvider.isFavorite(product.id);
    return GestureDetector(
      onTap: () {
        context.push('/product/${product.id}');
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      "assets/images/${product.imageUrl}",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                    ),
                  ),
                ),
                // Discount tag
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "-${product.discount.toInt()}%",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                // Favorite button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      favoriteProvider.toggleFavorite(product);
                    },
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${product.price.toInt()}đ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    "${product.oldPrice.toInt()}đ",
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
