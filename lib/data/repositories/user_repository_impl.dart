import '../../core/network/api_service.dart';
import '../../data/models/users_model.dart';
import '../../domain/repositories/user_repository.dart';

/// Remote implementation backed by Retrofit ([ApiService]).
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._api);

  final ApiService _api;

  @override
  Future<List<User>> getUsers() => _api.getUsers();
}
