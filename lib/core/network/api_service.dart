import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../data/models/users_model.dart';
import '../config/app_config.dart';

part 'api_service.g.dart';

/// Retrofit REST client. Add endpoints here and run:
/// `dart run build_runner build --delete-conflicting-outputs`
@RestApi(baseUrl: AppConfig.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/users')
  Future<List<User>> getUsers();
}
