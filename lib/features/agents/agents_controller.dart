import 'package:get/get.dart';

import '../../../base/base_controller.dart';
import '../../../domain/models/legal_agent.dart';
import '../../../domain/repositories/agent_repository.dart';

/// Browse screen: loads all agents, supports search + area filtering.
class AgentsController extends BaseController {
  final AgentRepository _repository = Get.find<AgentRepository>();

  final RxList<LegalAgent> agents = <LegalAgent>[].obs;
  final RxnString query = RxnString();

  List<LegalAgent> get visibleAgents =>
      agents.where((a) => a.matches(query.value ?? '')).toList();

  @override
  void onInit() {
    super.onInit();
    fetchAgents();
  }

  Future<void> fetchAgents() async {
    final List<LegalAgent>? result = await run(() => _repository.getAgents());
    if (result != null) {
      agents.assignAll(result);
    }
  }

  void search(String value) => query.value = value;

  @override
  void retry() => fetchAgents();
}
