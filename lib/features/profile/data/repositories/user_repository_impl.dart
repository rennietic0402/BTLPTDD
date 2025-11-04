import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart'; // ✅ Import tương đối
import '../datasources/user_remote_data_source.dart'; // ✅ Import tương đối
import '../models/user_model.dart'; // ✅ Import tương đối

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> getUserProfile(String uid) async {
    return await remoteDataSource.fetchUserProfile(uid);
  }

  @override
  Future<void> updateProfile(User user) {
    // Chuyển User Entity thành UserModel trước khi lưu
    final userModel = UserModel.fromEntity(user);
    return remoteDataSource.saveUserProfile(userModel);
  }
}