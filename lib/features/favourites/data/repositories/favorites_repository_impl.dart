// favorites_repository_impl.dart
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;
  FavoritesRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addFavorite(String productId) {
    return remoteDataSource.addProductId(productId);
  }

  @override
  Future<List<String>> getFavoriteProductIds() {
    return remoteDataSource.getProductIds();
  }

  @override
  Future<void> removeFavorite(String productId) {
    return remoteDataSource.removeProductId(productId);
  }
}