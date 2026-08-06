import '../../data/models/users_model.dart';

/// Contract for the remote user API (Retrofit demo flow).
abstract interface class UserRepository {
  Future<List<User>> getUsers();
}
