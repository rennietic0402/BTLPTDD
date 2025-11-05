import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getUserProfile(String uid);
  Future<void> updateProfile(User user);
}