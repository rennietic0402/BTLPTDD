import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Thêm dòng này

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': 'assets/icons/Group.svg', 'name': 'Son Môi'},
      {'icon': 'assets/icons/Matna.svg', 'name': 'Mặt Nạ'},
      {'icon': 'assets/icons/Mascara.svg', 'name': 'Mascara'},
      {'icon': 'assets/icons/Longmi.svg', 'name': 'Lông Mi'},
      {'icon': 'assets/icons/Kemduong.svg', 'name': 'Kem Dưỡng'},
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final c = categories[index];
          return Column(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.pink.shade50,
                child: SvgPicture.asset(
                  c['icon'] as String,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.pinkAccent,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                c['name'] as String,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          );
        },
      ),
    );
  }
}
