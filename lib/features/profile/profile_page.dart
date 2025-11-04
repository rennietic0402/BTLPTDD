// lib/features/profile/profile_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:go_router/go_router.dart';

// Import các lớp Clean Architecture Profile
import 'package:btludptdd/features/profile/domain/entities/user.dart';
import 'package:btludptdd/features/profile/data/datasources/user_remote_data_source.dart';
import 'package:btludptdd/features/profile/data/repositories/user_repository_impl.dart';
import 'package:btludptdd/features/profile/domain/usecases/get_user_profile.dart';
import 'package:btludptdd/features/profile/domain/usecases/update_user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> _userFuture;
  late String _currentUserId;

  final _fullNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController(text: 'Loading...');
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _usernameController = TextEditingController();

  late final GetUserProfile _getUserProfile;
  late final UpdateUserProfile _updateUserProfile;

  @override
  void initState() {
    super.initState();
    _currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';

    final userRemoteDS = UserRemoteDataSourceImpl();
    final userRepo = UserRepositoryImpl(userRemoteDS);
    _getUserProfile = GetUserProfile(userRepo);
    _updateUserProfile = UpdateUserProfile(userRepo);

    _userFuture = _loadUserData();
  }

  Future<User> _loadUserData() async {
    final user = await _getUserProfile.call(_currentUserId);
    _populateControllers(user);
    return user;
  }

  void _populateControllers(User user) {
    if (mounted) {
      if (_fullNameController.text.isEmpty ||
          _fullNameController.text == 'Loading...') {
        setState(() {
          _fullNameController.text = user.fullName;
          _genderController.text = user.gender;
          _emailController.text = user.email;
          _phoneController.text = user.phone;
          _addressController.text = user.address;
          _usernameController.text = user.username;
        });
      }
    }
  }

  Future<void> _saveProfile(User originalUser) async {
    final updatedUser = originalUser.copyWith(
      fullName: _fullNameController.text,
      gender: _genderController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      username: _usernameController.text,
    );

    try {
      await _updateUserProfile.call(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lưu thông tin cá nhân thành công!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu thông tin: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Nền trắng toàn màn hình
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true, // ✅ Căn giữa tiêu đề
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.go('/'),
        ),
        title: const Text(
          "Thông tin cá nhân",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<User>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Không thể tải hồ sơ người dùng.'));
            }

            final user = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar người dùng
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
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.pinkAccent,
                                shape: BoxShape.circle,
                                border:
                                Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Các trường nhập liệu
                  _buildInputField(
                      label: "Họ và tên",
                      controller: _fullNameController,
                      required: true),
                  _buildInputField(
                      label: "Giới tính",
                      controller: _genderController,
                      required: true),
                  _buildInputField(
                      label: "Email",
                      controller: _emailController,
                      required: true,
                      keyboardType: TextInputType.emailAddress,
                      readOnly: true),
                  _buildInputField(
                      label: "Số điện thoại",
                      controller: _phoneController,
                      required: true,
                      keyboardType: TextInputType.phone),
                  _buildInputField(
                      label: "Địa chỉ",
                      controller: _addressController,
                      required: true),
                  _buildInputField(
                      label: "Tên tài khoản",
                      controller: _usernameController,
                      required: true),

                  _buildPasswordField(context),

                  const SizedBox(height: 30),

                  // Nút Lưu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _saveProfile(user),
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Trường nhập liệu chung
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required bool required,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: label,
              style:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.white, // ✅ Nền trắng
            ),
          ),
        ],
      ),
    );
  }

  // Trường mật khẩu
  Widget _buildPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            label: "Mật khẩu",
            controller: TextEditingController(text: "********"),
            required: true,
            readOnly: true,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                // TODO: Chuyển sang trang đổi mật khẩu
              },
              child: const Text(
                'Đổi Mật Khẩu',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
