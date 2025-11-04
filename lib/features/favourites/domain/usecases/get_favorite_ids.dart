// get_favorite_ids.dart
import '../repositories/favorites_repository.dart';

class GetFavoriteProductIds {
  final FavoritesRepository repository;
  GetFavoriteProductIds(this.repository);
  Future<List<String>> call() => repository.getFavoriteProductIds();
}