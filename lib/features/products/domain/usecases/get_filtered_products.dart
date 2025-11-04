import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetFilteredProducts {
  final ProductRepository repository;
  GetFilteredProducts(this.repository);

  // Use Case này nhận từ khóa tìm kiếm và danh mục (category)
  Future<List<Product>> call({
    String? keyword,
    String? category,
  }) async {
    // 1. Lấy tất cả sản phẩm (từ Firestore qua Repository)
    List<Product> allProducts = await repository.getProducts();

    // 2. Lọc theo Từ khóa (Tên sản phẩm hoặc Thương hiệu)
    if (keyword != null && keyword.isNotEmpty) {
      final lowerKeyword = keyword.toLowerCase();
      allProducts = allProducts.where((p) =>
      p.name.toLowerCase().contains(lowerKeyword) ||
          p.brand.toLowerCase().contains(lowerKeyword)
      ).toList();
    }

    // 3. Lọc theo Danh mục (Giả định: Category là một trường Brand hoặc Type)
    if (category != null && category.isNotEmpty) {
      final lowerCategory = category.toLowerCase();

      // Ở đây, bạn cần logic lọc sản phẩm thuộc danh mục nào.
      // Tạm thời, chúng ta sẽ giả định 'description' chứa từ khóa danh mục:
      allProducts = allProducts.where((p) =>
          p.description.toLowerCase().contains(lowerCategory)
        // HOẶC dùng một trường 'type' mới trong Product Model/Firestore
      ).toList();
    }

    return allProducts;
  }
}