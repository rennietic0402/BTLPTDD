import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';
class UserModel extends User {
  UserModel({
    required super.uid,
    required super.fullName,
    required super.gender,
    required super.email,
    required super.phone,
    required super.address,
    required super.username,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("User data is missing or null for document ${doc.id}");
    }

    return UserModel(
      uid: doc.id,
      fullName: data['fullName'] as String? ?? '',
      gender: data['gender'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      address: data['address'] as String? ?? '',
      username: data['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'gender': gender,
      'email': email,
      'phone': phone,
      'address': address,
      'username': username,
    };
  }

  factory UserModel.fromEntity(User e) => UserModel(
    uid: e.uid,
    fullName: e.fullName,
    gender: e.gender,
    email: e.email,
    phone: e.phone,
    address: e.address,
    username: e.username,
  );
}