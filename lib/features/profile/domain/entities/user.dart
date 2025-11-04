class User {
  final String uid; // Firestore Document ID / Auth UID
  final String fullName;
  final String gender;
  final String email;
  final String phone;
  final String address;
  final String username;

  User({
    required this.uid,
    required this.fullName,
    required this.gender,
    required this.email,
    required this.phone,
    required this.address,
    required this.username,
  });

  // Thêm copyWith để tiện cập nhật
  User copyWith({
    String? fullName,
    String? gender,
    String? phone,
    String? address,
    String? username,
  }) {
    return User(
      uid: uid,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      email: email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      username: username ?? this.username,
    );
  }
}