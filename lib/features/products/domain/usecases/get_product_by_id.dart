import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductById {
  final ProductRepository repository;
  GetProductById(this.repository);

  // Gọi hàm lấy sản phẩm theo ID từ Repository
  Future<Product> call(String id) => repository.getProduct(id);
}