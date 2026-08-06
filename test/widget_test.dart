import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_app/core/widgets/lexi_logo.dart';
import 'package:mobile_app/data/repositories/agent_repository_impl.dart';
import 'package:mobile_app/domain/models/legal_agent.dart';
import 'package:mobile_app/domain/repositories/agent_repository.dart';
import 'package:mobile_app/features/home/home_controller.dart';
import 'package:mobile_app/features/onboarding/onboarding_screen.dart';

void main() {
  testWidgets('LexiLogo renders the brand mark', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LexiLogo())),
    );

    expect(find.byType(LexiLogo), findsOneWidget);
    expect(find.byIcon(Icons.balance_rounded), findsOneWidget);
  });

  testWidgets('ai_loader.json decodes as a valid Lottie composition', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: Lottie.asset('assets/animations/ai_loader.json'),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 2));

    expect(tester.takeException(), isNull);
    expect(
      find.byType(LottieBuilder),
      findsOneWidget,
      reason: 'Lottie composition should have decoded without errors',
    );
  });

  testWidgets('Onboarding advances through all three slides', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: OnboardingScreen()));

    expect(find.text('AI Agents that know the law'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Talk, video or text'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Legal clarity in minutes'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });

  test('AgentRepositoryImpl returns the full curated catalogue', () async {
    final AgentRepository repo = AgentRepositoryImpl();

    final agents = await repo.getAgents();
    expect(agents.length, 8);
    expect(agents.first.name, 'Amelia Hart');

    final LegalAgent? found = await repo.getAgentById('a3');
    expect(found?.name, 'Sofia Rossi');
  });

  test(
    'HomeController loads agents through GetX dependency injection',
    () async {
      Get.reset();
      Get.put<AgentRepository>(AgentRepositoryImpl());
      final HomeController controller = Get.put(HomeController());

      await Future<void>.delayed(const Duration(milliseconds: 1500));

      expect(controller.agents.length, 8);
      expect(controller.featured.length, 4);
      expect(controller.isLoading.value, isFalse);
      expect(controller.error.value, isNull);
      Get.reset();
    },
  );
}
