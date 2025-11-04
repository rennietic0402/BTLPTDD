// toggle_favorite.dart
import '../repositories/favorites_repository.dart';

class ToggleFavorite {
  final FavoritesRepository repository;
  ToggleFavorite(this.repository);

  Future<void> call({required String productId, required bool isCurrentlyFavorite}) async {
    if (isCurrentlyFavorite) {
      await repository.removeFavorite(productId);
    } else {
      await repository.addFavorite(productId);
    }
  }
}