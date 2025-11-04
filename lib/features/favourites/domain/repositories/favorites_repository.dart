// favorites_repository.dart

abstract class FavoritesRepository {
  Future<List<String>> getFavoriteProductIds();
  Future<void> addFavorite(String productId);
  Future<void> removeFavorite(String productId);
// Có thể thêm Stream để nghe thay đổi theo thời gian thực
// Stream<List<String>> watchFavorites();
}