import 'package:btludptdd/features/products/data/models/product_model.dart';
import 'package:btludptdd/features/products/domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl extends ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Product> getProduct(String id) async {
    ProductModel? productModel = await remoteDataSource.getProduct(id);
    if (productModel == null) {
      throw Exception('Product not found');
    }
    return productModel;
    // return Product.fromJson(productModel.toJson());
  }

  @override
  Future<List<Product>> getProducts() async {
    List<ProductModel> productModels = await remoteDataSource.getAll();
    return productModels;
    // List<Product> products = productModels.map((e) => Product.fromJson(e.toJson())).toList();
    // return products;
  }
}
