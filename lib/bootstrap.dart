import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'core/network/api_client.dart';
import 'core/network/api_service.dart';
import 'data/repositories/agent_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/agent_repository.dart';
import 'domain/repositories/user_repository.dart';

/// Register every dependency once, at startup.
///
/// Swap `AgentRepositoryImpl` for a remote implementation here when the
/// backend lands — nothing else changes.
Future<void> initDependencies() async {
  Get
    // ---- Network ----
    ..lazyPut<Dio>(() => ApiClient.prepareDio(), fenix: true)
    ..lazyPut<ApiService>(() => ApiClient.createRestClient(), fenix: true)
    // ---- Repositories ----
    ..lazyPut<UserRepository>(
      () => UserRepositoryImpl(Get.find<ApiService>()),
      fenix: true,
    )
    ..lazyPut<AgentRepository>(() => AgentRepositoryImpl(), fenix: true);
}
