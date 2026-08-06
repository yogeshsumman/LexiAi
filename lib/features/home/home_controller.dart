import 'package:get/get.dart';

import '../../../base/base_controller.dart';
import '../../../domain/models/legal_agent.dart';
import '../../../domain/models/practice_area.dart';
import '../../../domain/repositories/agent_repository.dart';

/// Dashboard controller: loads agents, filters by practice area.
class HomeController extends BaseController {
  final AgentRepository _repository = Get.find<AgentRepository>();

  final RxList<LegalAgent> agents = <LegalAgent>[].obs;
  final Rxn<PracticeArea> selectedArea = Rxn<PracticeArea>();
  final RxList<PracticeArea> areas = <PracticeArea>[...PracticeArea.values].obs;

  List<LegalAgent> get featured =>
      agents.where((a) => a.isFeatured).take(4).toList();

  List<LegalAgent> get visibleAgents {
    final PracticeArea? area = selectedArea.value;
    if (area == null) return agents;
    return agents.where((a) => a.practiceAreas.contains(area)).toList();
  }

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

  void selectArea(PracticeArea? area) {
    selectedArea.value = area;
  }

  @override
  void retry() => fetchAgents();
}
