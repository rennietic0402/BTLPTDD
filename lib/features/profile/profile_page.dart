import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

// Model người dùng
class UserModel {
  final String id;
  final String fullName;
  final String gender;
  final String email;
  final String phone;
  final String address;
  final String username;

  UserModel({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.email,
    required this.phone,
    required this.address,
    required this.username,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      fullName: map['fullName'] ?? '',
      gender: map['gender'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      username: map['username'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'gender': gender,
      'email': email,
      'phone': phone,
      'address': address,
      'username': username,
    };
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Controllers
  final _fullNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _usernameController = TextEditingController();

  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bạn chưa đăng nhập')),
        );
      }
      return;
    }

    final uid = currentUser.uid;
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      final newUser = UserModel(
        id: uid,
        fullName: '',
        gender: '',
        email: currentUser.email ?? '',
        phone: '',
        address: '',
        username: '',
      );
      await _firestore.collection('users').doc(uid).set(newUser.toMap());
      _user = newUser;
    } else {
      _user = UserModel.fromMap(doc.data()!, doc.id);
    }

    setState(() {
      _fullNameController.text = _user!.fullName;
      _genderController.text = _user!.gender;
      _emailController.text = _user!.email;
      _phoneController.text = _user!.phone;
      _addressController.text = _user!.address;
      _usernameController.text = _user!.username;
    });
  }

  Future<void> _saveProfile() async {
    if (_user == null) return;

    final updatedUser = UserModel(
      id: _user!.id,
      fullName: _fullNameController.text,
      gender: _genderController.text,
      email: _user!.email,
      phone: _phoneController.text,
      address: _addressController.text,
      username: _usernameController.text,
    );

    await _firestore
        .collection('users')
        .doc(updatedUser.id)
        .set(updatedUser.toMap(), SetOptions(merge: true));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thông tin thành công!')),
      );
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Thông tin cá nhân",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Avatar giữa màn hình
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person,
                        size: 60, color: Colors.white),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        shape: BoxShape.circle,
                        border:
                        Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.edit,
                          size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _buildInputField("Họ và tên", _fullNameController, true),
            _buildInputField("Giới tính", _genderController, false),
            _buildInputField("Email", _emailController, true,
                readOnly: true),
            _buildInputField("Số điện thoại", _phoneController, false),
            _buildInputField("Địa chỉ", _addressController, false),
            _buildInputField("Tên tài khoản", _usernameController, false),

            const SizedBox(height: 30),

            // Nút Lưu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Lưu',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Nút Đăng xuất (màu xám)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _signOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Đăng xuất',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      bool required, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              children: required
                  ? [
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                )
              ]
                  : [],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            readOnly: readOnly,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
