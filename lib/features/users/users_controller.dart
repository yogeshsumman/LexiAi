import 'package:get/get.dart';

import '../../../base/base_controller.dart';
import '../../../data/models/users_model.dart';
import '../../../domain/repositories/user_repository.dart';

/// Demo controller showing the full Retrofit -> repository -> UI flow.
class UsersController extends BaseController {
  final UserRepository _repository = Get.find<UserRepository>();

  final RxList<User> users = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final List<User>? result = await run(() => _repository.getUsers());
    if (result != null) {
      users.assignAll(result);
    }
  }

  @override
  void retry() => fetchUsers();
}
