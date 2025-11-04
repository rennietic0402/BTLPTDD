import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/core/routing/app_routes.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String gender = "Nữ";
  String? error;

  Future<void> _register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text,
      );
      // TODO: Lưu thêm name, phone, address vào Firestore nếu cần
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message);
    }
  }

  Widget label(String text) {
    return Text.rich(
      TextSpan(
        text: text,
        style: const TextStyle(fontSize: 14),
        children: [
          const TextSpan(
            text: " *",
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  InputDecoration input(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              Center(
                child: Text(
                  "Đăng Ký",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.red)),

              // Name
              label("Họ và tên"),
              const SizedBox(height: 6),
              TextField(
                controller: nameCtrl,
                decoration: input("ex: Lê Thanh Thảo"),
              ),
              const SizedBox(height: 18),

              // Gender
              label("Giới tính"),
              const SizedBox(height: 6),
              DropdownButtonFormField(
                value: gender,
                decoration: input(""),
                items: ["Nam", "Nữ", "Khác"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => gender = v!),
              ),
              const SizedBox(height: 18),

              // Email
              label("Email"),
              const SizedBox(height: 6),
              TextField(
                controller: emailCtrl,
                decoration: input("example@gmail.com"),
              ),
              const SizedBox(height: 18),

              // Phone
              label("Số điện thoại"),
              const SizedBox(height: 6),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: input("0123456789"),
              ),
              const SizedBox(height: 18),

              // Address
              label("Địa chỉ"),
              const SizedBox(height: 6),
              TextField(
                controller: addressCtrl,
                decoration: input("175 Tây Sơn, Trung Liệt, Hà Nội"),
              ),
              const SizedBox(height: 18),

              // Username
              label("Tên tài khoản"),
              const SizedBox(height: 6),
              TextField(
                controller: usernameCtrl,
                decoration: input("Lê Thanh Thảo"),
              ),
              const SizedBox(height: 18),

              // Password
              label("Mật khẩu"),
              const SizedBox(height: 6),
              TextField(
                controller: passCtrl,
                decoration: input("************"),
                obscureText: true,
              ),

              const SizedBox(height: 26),

              // Button Register
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE3E3),
                    foregroundColor: Colors.grey[800],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Đăng Ký",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Nếu có tài khoản rồi "),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.login),
                      child: const Text(
                        "Hãy đăng nhập",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
