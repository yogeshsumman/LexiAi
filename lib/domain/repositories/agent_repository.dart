import '../models/legal_agent.dart';

/// Contract for fetching AI legal agents.
///
/// Production-ready pattern: UI depends on this abstraction only, so the
/// mock implementation can be swapped for a Retrofit-backed one without
/// touching any screen or controller.
abstract interface class AgentRepository {
  Future<List<LegalAgent>> getAgents({String? practiceAreaQuery});

  Future<LegalAgent?> getAgentById(String id);
}
