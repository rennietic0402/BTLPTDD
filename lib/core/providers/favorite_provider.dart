import 'package:flutter/material.dart';
import '../../features/products/domain/entities/product.dart';
import '../../features/favourites/domain/repositories/favorites_repository.dart'; // Import interface
import '../../features/favourites/domain/usecases/get_favorite_ids.dart';
import '../../features/favourites/domain/usecases/toggle_favorite.dart';

class FavoriteProvider extends ChangeNotifier {
  // ✅ Dependencies (Đã có sẵn trong Use Cases)
  final GetFavoriteProductIds _getFavoriteIds;
  final ToggleFavorite _toggleFavorite;

  // ✅ State: Chỉ lưu trữ ID sản phẩm
  Set<String> _favoriteProductIds = {};
  Set<String> get favoriteProductIds => _favoriteProductIds;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Constructor sẽ cần Repository để khởi tạo Use Cases
  FavoriteProvider({required FavoritesRepository repository})
      : _getFavoriteIds = GetFavoriteProductIds(repository),
        _toggleFavorite = ToggleFavorite(repository) {
    // Tự động tải danh sách ID yêu thích ngay khi khởi tạo
    loadFavorites();
  }

  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();
    try {
      // 1. Lấy danh sách ID từ Firestore qua Use Case
      final ids = await _getFavoriteIds.call();
      _favoriteProductIds = ids.toSet();
    } catch (e) {
      debugPrint("Error loading favorites from Firestore: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Product product) async {
    final productId = product.id;
    final isCurrentlyFav = isFavorite(productId);

    // 1. Cập nhật UI ngay lập tức (Optimistic Update)
    if (isCurrentlyFav) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();

    // 2. Ghi thay đổi vào Firestore qua Use Case
    try {
      await _toggleFavorite(productId: productId, isCurrentlyFavorite: isCurrentlyFav);
    } catch (e) {
      // Nếu thất bại, rollback UI state
      if (isCurrentlyFav) {
        _favoriteProductIds.add(productId);
      } else {
        _favoriteProductIds.remove(productId);
      }
      notifyListeners();
      debugPrint("Error toggling favorite in Firestore: $e");
    }
  }
}