import '../../../../core/data/firebase_remote_data_source.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> fetchUserProfile(String uid);
  Future<void> saveUserProfile(UserModel model);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  // Collection cho hồ sơ người dùng
  final FirebaseRemoteDS<UserModel> _remoteSource;

  UserRemoteDataSourceImpl()
      : _remoteSource = FirebaseRemoteDS<UserModel>(
    collectionName: 'users', // Collection trong Firestore
    fromFirestore: (doc) => UserModel.fromFirestore(doc),
    toFirestore: (model) => model.toJson(),
  );

  @override
  Future<UserModel> fetchUserProfile(String uid) async {
    // Lấy thông tin người dùng bằng UID (Document ID)
    final model = await _remoteSource.getById(uid);
    if (model == null) {
      // Trả về một đối tượng User rỗng nếu không tìm thấy (giả định)
      return UserModel(
          uid: uid, fullName: 'Guest', gender: '', email: '', phone: '', address: '', username: '');
    }
    return model;
  }

  @override
  Future<void> saveUserProfile(UserModel model) {
    // Cập nhật profile, sử dụng UID làm Document ID
    return _remoteSource.update(model.uid, model);
  }
}