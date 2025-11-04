import '../entities/user.dart';
import '../repositories/user_repository.dart';

class UpdateUserProfile {
  final UserRepository repository;
  UpdateUserProfile(this.repository);
  Future<void> call(User user) => repository.updateProfile(user);
}