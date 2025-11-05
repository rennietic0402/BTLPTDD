import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> getUserProfile(String uid) async {
    return await remoteDataSource.fetchUserProfile(uid);
  }

  @override
  Future<void> updateProfile(User user) async {
    final userModel = UserModel.fromEntity(user);
    await remoteDataSource.saveUserProfile(userModel);
  }
}
