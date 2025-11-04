import 'package:flutter/material.dart';
import '../home/presentation/widgets/category_item.dart';
import '../home/presentation/widgets/banner_slider.dart';
import '../products/presentation/widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchText = '';
  String? _filterCategory; // Son môi, Dưỡng da, Kem nền

  // Danh sách cố định cho bộ lọc theo yêu cầu
  final List<String> _categories = ['Son', 'Dưỡng Da', 'Kem Nền'];

  void _onSearchChanged(String text) {
    setState(() {
      _searchText = text;
    });
  }

  void _onFilterSelected(String category) {
    setState(() {
      // Nếu chọn lại category đang chọn, thì xóa filter
      _filterCategory = (_filterCategory == category) ? null : category;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Biến kiểm tra trạng thái tìm kiếm/lọc
    final isSearching = _searchText.isNotEmpty || _filterCategory != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header + search (LUÔN HIỂN THỊ)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFE4E1), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Xin chào!", style: TextStyle(fontSize: 16)),
                    const Text(
                      "Lê Thanh Thảo",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: _onSearchChanged, // ✅ Lắng nghe thay đổi
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm sản phẩm, thương hiệu...",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.tune),
                          onPressed: () => _showFilterDialog(context),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ ẨN BANNER VÀ DANH MỤC KHI ĐANG TÌM KIẾM
              if (!isSearching) ...[
                const SizedBox(height: 16),

                // Banner quảng cáo (CHỈ HIỂN THỊ KHI KHÔNG TÌM KIẾM)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: BannerSlider(),
                ),

                const SizedBox(height: 24),

                // Danh mục (CHỈ HIỂN THỊ KHI KHÔNG TÌM KIẾM)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Danh Mục",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const CategoryList(),

                const SizedBox(height: 24),
              ],


              // ✅ TIÊU ĐỀ SẢN PHẨM MỚI / SẢN PHẨM CÓ LIÊN QUAN (LUÔN HIỂN THỊ)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  // Tiêu đề thay đổi dựa trên trạng thái tìm kiếm
                  isSearching
                      ? "Sản phẩm có liên quan"
                      : "Sản Phẩm Mới",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // PRODUCT GRID (LUÔN HIỂN THỊ)
              ProductGrid(
                keyword: _searchText,
                category: _filterCategory,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Hộp thoại Modal Bottom Sheet cho Bộ lọc (Giữ nguyên)
  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Bộ Lọc Danh Mục", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ..._categories.map((cat) => ListTile(
            title: Text(cat),
            onTap: () {
              _onFilterSelected(cat);
              Navigator.pop(ctx);
            },
            trailing: _filterCategory == cat
                ? const Icon(Icons.check, color: Colors.pinkAccent)
                : null,
          )).toList(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}