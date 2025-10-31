import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final products = List.generate(6, (i) => {
      'name': 'Kem Nền Catrice HD Liquid Coverage Foundation 24H',
      'brand': 'CATRICE',
      'price': '190.000đ',
      'oldPrice': '250.000đ',
      'discount': '-24%',
      'image': 'assets/images/4.png',
    });

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.595,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final p = products[index];
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: AspectRatio(
                      aspectRatio: 1, // vuông đẹp cho ảnh sản phẩm
                      child: Image.asset(
                        p['image']!,
                        fit: BoxFit.cover, // hoặc BoxFit.contain nếu ảnh có nền
                        width: double.infinity, // giúp ảnh rộng bằng card
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // ✅ THÊM DÒNG NÀY
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p['brand']!,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.pinkAccent)),
                        Text(
                          p['name']!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(p['price']!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black)),
                        Text(p['oldPrice']!,
                            style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(p['discount']!,
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ),
            const Positioned(
              top: 8,
              right: 8,
              child: Icon(Icons.favorite_border, color: Colors.grey),
            ),
          ],
        );
      },
    );
  }
}
