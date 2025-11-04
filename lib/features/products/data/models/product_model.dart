import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required String id,
    required String name,
    required String brand,
    required double price,
    required double oldPrice,
    required double discount,
    required String imageUrl,
    required String description,
  }) : super(
    id: id,
    name: name,
    brand: brand,
    price: price,
    oldPrice: oldPrice,
    discount: discount,
    imageUrl: imageUrl,
    description: description,
  );

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    if (data == null) {
      throw Exception("Product data is null for document ${doc.id}");
    }
    // ✅ FIX: Chuyển đổi dữ liệu số (int hoặc double) từ Firestore sang double (as num).toDouble()
    return ProductModel(
      id: doc.id,
      name: data['name'] as String? ?? '', // Xử lý null
      brand: data['brand'] as String? ?? '', // Xử lý null
      price: (data['price'] as num? ?? 0.0).toDouble(), // Xử lý num? và null
      oldPrice: (data['oldPrice'] as num? ?? 0.0).toDouble(), // Xử lý num? và null
      discount: (data['discount'] as num? ?? 0.0).toDouble(), // Xử lý num? và null
      imageUrl: data['imageUrl'] as String? ?? '', // Xử lý null
      description: data['description'] as String? ?? '', // Xử lý null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'price': price,
      'oldPrice': oldPrice,
      'discount': discount,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  factory ProductModel.fromEntity(Product e) => ProductModel(
    id: e.id,
    name: e.name,
    brand: e.brand,
    price: e.price,
    oldPrice: e.oldPrice,
    discount: e.discount,
    imageUrl: e.imageUrl,
    description: e.description,
  );
}