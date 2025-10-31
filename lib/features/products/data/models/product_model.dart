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
    return ProductModel(
      id: doc.id,
      name: data['name'],
      brand: data['brand'],
      price: data['price'],
      oldPrice: data['oldPrice'],
      discount: data['discount'],
      imageUrl: data['imageUrl'],
      description: data['description'],
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
