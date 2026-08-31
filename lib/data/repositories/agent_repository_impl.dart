import '../../domain/models/legal_agent.dart';
import '../../domain/models/practice_area.dart';
import '../../domain/repositories/agent_repository.dart';
import '../../gen/assets.gen.dart';

/// Local/mock implementation of [AgentRepository].
///
/// The curated catalogue below stands in for the real backend. When the
/// LexiAI API is ready, add an `AgentRepositoryImplRemote` that maps the
/// API payloads onto [LegalAgent] and swap the binding in `bootstrap.dart`.
class AgentRepositoryImpl implements AgentRepository {
  static const Duration _latency = Duration(milliseconds: 900);

  @override
  Future<List<LegalAgent>> getAgents({String? practiceAreaQuery}) async {
    await Future<void>.delayed(_latency);
    final String q = practiceAreaQuery?.trim().toLowerCase() ?? '';
    return _catalogue.where((agent) {
      if (q.isEmpty) return true;
      return agent.practiceAreas.any((a) => a.label.toLowerCase().contains(q));
    }).toList();
  }

  @override
  Future<LegalAgent?> getAgentById(String id) async {
    await Future<void>.delayed(_latency);
    for (final LegalAgent agent in _catalogue) {
      if (agent.id == id) return agent;
    }
    return null;
  }

  static final List<LegalAgent> _catalogue = [
    LegalAgent(
      id: 'a1',
      name: 'Amelia Hart',
      title: 'Senior AI Counsel',
      photo: Assets.agents.a1.path,
      practiceAreas: const [PracticeArea.corporate, PracticeArea.tax],
      rating: 4.9,
      consultations: 12480,
      successRate: 0.98,
      responseTime: const Duration(seconds: 14),
      languages: const ['English', 'French'],
      bio:
          'Corporate structuring, M&A diligence and commercial contracts, explained with boardroom-level precision.',
      gradientIndex: 0,
      isFeatured: true,
    ),
    LegalAgent(
      id: 'a2',
      name: 'Marcus Chen',
      title: 'IP & Innovation Agent',
      photo: Assets.agents.a2.path,
      practiceAreas: const [PracticeArea.ip],
      rating: 4.8,
      consultations: 8932,
      successRate: 0.96,
      responseTime: const Duration(seconds: 11),
      languages: const ['English', 'Mandarin'],
      bio:
          'Patents, trademarks and trade secrets. Sharp protection strategy for startups and creators.',
      gradientIndex: 1,
      isFeatured: true,
    ),
    LegalAgent(
      id: 'a3',
      name: 'Sofia Rossi',
      title: 'Family Law Agent',
      photo: Assets.agents.a3.path,
      practiceAreas: const [PracticeArea.family],
      rating: 4.9,
      consultations: 15320,
      successRate: 0.97,
      responseTime: const Duration(seconds: 18),
      languages: const ['English', 'Italian', 'Spanish'],
      bio:
          'Divorce, custody and mediation with empathy first, legal rigor second. Prefers out-of-court resolution.',
      gradientIndex: 2,
      isFeatured: true,
    ),
    LegalAgent(
      id: 'a4',
      name: 'James Okafor',
      title: 'Criminal Defense Agent',
      photo: Assets.agents.a4.path,
      practiceAreas: const [PracticeArea.criminal],
      rating: 4.7,
      consultations: 7214,
      successRate: 0.93,
      responseTime: const Duration(seconds: 9),
      languages: const ['English', 'Igbo'],
      bio:
          'Defense strategy, bail hearings and plea negotiation. Calm under pressure, relentless on your side.',
      gradientIndex: 3,
    ),
    LegalAgent(
      id: 'a5',
      name: 'Priya Sharma',
      title: 'Tax & Estate Agent',
      photo: Assets.agents.a5.path,
      practiceAreas: const [PracticeArea.tax, PracticeArea.corporate],
      rating: 4.8,
      consultations: 11047,
      successRate: 0.95,
      responseTime: const Duration(seconds: 16),
      languages: const ['English', 'Hindi'],
      bio:
          'Tax planning, wills and trusts. Turns the densest tax code into a clear, actionable checklist.',
      gradientIndex: 4,
    ),
    LegalAgent(
      id: 'a6',
      name: 'Elena Petrova',
      title: 'Immigration Agent',
      photo: Assets.agents.a6.path,
      practiceAreas: const [PracticeArea.immigration],
      rating: 4.9,
      consultations: 16890,
      successRate: 0.99,
      responseTime: const Duration(seconds: 12),
      languages: const ['English', 'Russian', 'German'],
      bio:
          'Visas, work permits and citizenship pathways. Up-to-date on policy shifts across 30+ jurisdictions.',
      gradientIndex: 5,
    ),
    LegalAgent(
      id: 'a7',
      name: 'Noah Kim',
      title: 'Employment Agent',
      photo: Assets.agents.a7.path,
      practiceAreas: const [PracticeArea.employment],
      rating: 4.6,
      consultations: 6451,
      successRate: 0.91,
      responseTime: const Duration(seconds: 13),
      languages: const ['English', 'Korean'],
      bio:
          'Contracts, termination, discrimination and workplace disputes. Fair, balanced and pragmatic.',
      gradientIndex: 6,
    ),
    LegalAgent(
      id: 'a8',
      name: 'Isabella Cruz',
      title: 'Real Estate Agent',
      photo: Assets.agents.a8.path,
      practiceAreas: const [PracticeArea.realEstate],
      rating: 4.8,
      consultations: 9875,
      successRate: 0.96,
      responseTime: const Duration(seconds: 15),
      languages: const ['English', 'Portuguese'],
      bio:
          'Purchase agreements, leases and zoning. Keeps closings smooth and terms watertight.',
      gradientIndex: 7,
      isFeatured: true,
    ),
  ];
}
