import '../../../../core/data/firebase_remote_data_source.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> fetchUserProfile(String uid);
  Future<void> saveUserProfile(UserModel model);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseRemoteDS<UserModel> _remoteSource;

  UserRemoteDataSourceImpl()
      : _remoteSource = FirebaseRemoteDS<UserModel>(
    collectionName: 'users', // Collection Firestore
    fromFirestore: (doc) => UserModel.fromFirestore(doc),
    toFirestore: (model) => model.toJson(),
  );

  @override
  Future<UserModel> fetchUserProfile(String uid) async {
    final model = await _remoteSource.getById(uid);
    if (model == null) {
      // Nếu chưa có, trả về user mặc định
      return UserModel(
        uid: uid,
        fullName: 'Guest',
        gender: '',
        email: '',
        phone: '',
        address: '',
        username: '',
      );
    }
    return model;
  }

  @override
  Future<void> saveUserProfile(UserModel model) async {
    // Kiểm tra document tồn tại chưa
    final existing = await _remoteSource.getById(model.uid);

    if (existing == null) {
      // Nếu chưa có -> tạo mới (set)
      await _remoteSource.set(model.uid, model);
    } else {
      // Nếu có rồi -> cập nhật (update)
      await _remoteSource.update(model.uid, model);
    }
  }
}
