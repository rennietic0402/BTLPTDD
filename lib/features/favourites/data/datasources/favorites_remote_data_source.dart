// favorites_remote_data_source.dart
import '../../../../core/data/firebase_remote_data_source.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<String>> getProductIds();
  Future<void> addProductId(String productId);
  Future<void> removeProductId(String productId);
}

// Chúng ta sẽ lưu ID sản phẩm dưới dạng một List<String> trong một Document
// cho mỗi người dùng (collection: 'favorites', document: user_uid)

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  // Collection sẽ là 'users_favorites' hoặc 'favorites'
  final FirebaseRemoteDS<Map<String, dynamic>> _remoteSource;
  final String userId = FirebaseRemoteDS.getUserId() ?? 'guest';

  FavoritesRemoteDataSourceImpl()
      : _remoteSource = FirebaseRemoteDS<Map<String, dynamic>>(
    collectionName: 'favorites', // Tên collection trong Firestore
    // Dùng Map<String, dynamic> vì chúng ta chỉ lưu một trường List ID
    fromFirestore: (doc) => doc.data() as Map<String, dynamic>,
    toFirestore: (data) => data,
  );

  Future<void> _updateFavorites(List<String> productIds) async {
    // Luôn sử dụng doc ID là UID của người dùng (hoặc 'guest' nếu chưa đăng nhập)
    await _remoteSource.update(userId, {'productIds': productIds});
  }

  // Hàm này tạo document nếu chưa tồn tại
  Future<void> _ensureDocumentExists() async {
    final doc = await _remoteSource.getById(userId);
    if (doc == null) {
      await _remoteSource.addDocWithId(userId, {'productIds': []});
    }
  }

  @override
  Future<List<String>> getProductIds() async {
    await _ensureDocumentExists();
    final data = await _remoteSource.getById(userId);
    final List<dynamic> ids = data?['productIds'] ?? [];
    return ids.map((e) => e.toString()).toList();
  }

  @override
  Future<void> addProductId(String productId) async {
    List<String> currentIds = await getProductIds();
    if (!currentIds.contains(productId)) {
      currentIds.add(productId);
      await _updateFavorites(currentIds);
    }
  }

  @override
  Future<void> removeProductId(String productId) async {
    List<String> currentIds = await getProductIds();
    currentIds.remove(productId);
    await _updateFavorites(currentIds);
  }
}