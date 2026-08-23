import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/data/models/users_model.dart';
import 'package:mobile_app/data/repositories/agent_repository_impl.dart';
import 'package:mobile_app/domain/models/legal_agent.dart';
import 'package:mobile_app/domain/models/practice_area.dart';
import 'package:mobile_app/domain/repositories/agent_repository.dart';
import 'package:mobile_app/domain/repositories/user_repository.dart';
import 'package:mobile_app/features/agents/agents_controller.dart';
import 'package:mobile_app/features/agents/agents_screen.dart';
import 'package:mobile_app/features/consultation/chat_controller.dart';
import 'package:mobile_app/features/home/home_controller.dart';
import 'package:mobile_app/features/main_shell/main_shell_controller.dart';
import 'package:mobile_app/features/profile/profile_screen.dart';
import 'package:mobile_app/features/users/users_screen.dart';
import 'package:mobile_app/routes/app_pages.dart';
import 'package:mobile_app/routes/app_routes.dart';

/// Renders every screen at phone size and captures PNG previews.
///
/// Generate with:  flutter test test/previews --update-goldens
/// Outputs land in test/previews/goldens/*.png — copy them to
/// docs/screenshots/ for the README.
void main() {
  // Bundled fonts are not auto-loaded in the test environment — register
  // them manually so previews render with the real brand typography
  // (GoogleFonts resolves by family name and picks these up).
  setUpAll(() async {
    final FontLoader manrope = FontLoader('Manrope')
      ..addFont(rootBundle.load('assets/fonts/Manrope.ttf'));
    await manrope.load();
    final FontLoader playfair = FontLoader('Playfair Display')
      ..addFont(rootBundle.load('assets/fonts/PlayfairDisplay.ttf'));
    await playfair.load();
  });

  setUp(() => Get.reset());

  Future<void> phone(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
  }

  const LegalAgent agent = LegalAgent(
    id: 'a1',
    name: 'Amelia Hart',
    title: 'Senior AI Counsel',
    photo: 'assets/agents/a1.jpg',
    practiceAreas: [PracticeArea.corporate, PracticeArea.tax],
    rating: 4.9,
    consultations: 12480,
    successRate: 0.98,
    responseTime: Duration(seconds: 14),
    languages: ['English', 'French'],
    bio:
        'Corporate structuring, M&A diligence and commercial contracts, explained with boardroom-level precision.',
    gradientIndex: 0,
    isFeatured: true,
  );

  Future<void> capture(WidgetTester tester, String name) async {
    await expectLater(
      find.byType(GetMaterialApp),
      matchesGoldenFile('goldens/$name.png'),
    );
  }

  testWidgets('splash preview', (tester) async {
    await phone(tester);
    await tester.pumpWidget(
      GetMaterialApp(getPages: AppPages.pages, initialRoute: AppRoutes.splash),
    );
    await tester.pump(const Duration(milliseconds: 1300));
    await capture(tester, '01-splash');
    // Flush the auto-navigation timer so no timers are left pending.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });

  testWidgets('onboarding preview', (tester) async {
    await phone(tester);
    await tester.pumpWidget(
      GetMaterialApp(
        getPages: AppPages.pages,
        initialRoute: AppRoutes.onboarding,
      ),
    );
    await tester.pump(const Duration(milliseconds: 1000));
    await capture(tester, '02-onboarding');
  });

  testWidgets('home preview', (tester) async {
    await phone(tester);
    Get.put<AgentRepository>(AgentRepositoryImpl());
    Get.put<MainShellController>(MainShellController());
    Get.put<HomeController>(HomeController());
    Get.put<AgentsController>(AgentsController());

    await tester.pumpWidget(
      GetMaterialApp(
        getPages: AppPages.pages,
        initialRoute: AppRoutes.main,
      ),
    );
    await tester.pump(const Duration(milliseconds: 1600));
    await capture(tester, '03-home');
    // Flush entrance-animation timers (fixed pump; home has an
    // infinitely-repeating pulse dot so pumpAndSettle never settles).
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('agents preview', (tester) async {
    await phone(tester);
    Get.put<AgentRepository>(AgentRepositoryImpl());
    Get.put<AgentsController>(AgentsController());

    await tester.pumpWidget(
      GetMaterialApp(getPages: AppPages.pages, home: const AgentsScreen()),
    );
    await tester.pump(const Duration(milliseconds: 1600));
    await capture(tester, '04-agents');
    // Flush entrance-animation timers so none are left pending.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });

  testWidgets('agent detail preview', (tester) async {
    await phone(tester);
    await tester.pumpWidget(
      GetMaterialApp(getPages: AppPages.pages, home: const Scaffold()),
    );
    Get.toNamed(AppRoutes.agentDetail, arguments: agent);
    await tester.pumpAndSettle();
    await capture(tester, '05-agent-detail');
  });

  testWidgets('chat preview', (tester) async {
    await phone(tester);
    await tester.pumpWidget(
      GetMaterialApp(getPages: AppPages.pages, home: const Scaffold()),
    );
    Get.toNamed(AppRoutes.chat, arguments: agent);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    final ChatController chat = Get.find<ChatController>();
    chat.input.text = 'My landlord is refusing to return my deposit…';
    chat.sendMessage();
    await tester.pump(const Duration(milliseconds: 2500));

    await capture(tester, '06-chat');
    // Flush the message entrance animation's pending restart timer.
    await tester.pump(const Duration(milliseconds: 500));
  });

  testWidgets('video call preview', (tester) async {
    await phone(tester);
    await tester.pumpWidget(
      GetMaterialApp(getPages: AppPages.pages, home: const Scaffold()),
    );
    Get.toNamed(AppRoutes.videoCall, arguments: agent);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump(const Duration(milliseconds: 500));
    await capture(tester, '07-video-call');
    // Dispose the screen — its timers are cancelled in dispose().
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('profile preview', (tester) async {
    await phone(tester);
    await tester.pumpWidget(
      GetMaterialApp(getPages: AppPages.pages, home: const ProfileScreen()),
    );
    await tester.pump(const Duration(milliseconds: 600));
    await capture(tester, '08-profile');
  });

  testWidgets('users preview', (tester) async {
    await phone(tester);
    Get.put<UserRepository>(_StubUserRepository());

    await tester.pumpWidget(
      GetMaterialApp(getPages: AppPages.pages, home: const UsersScreen()),
    );
    await tester.pump(const Duration(milliseconds: 600));
    await capture(tester, '09-users');
  });
}

/// Deterministic stand-in for the remote user API.
class _StubUserRepository implements UserRepository {
  @override
  Future<List<User>> getUsers() async {
    return [
      User(
        id: 1,
        name: 'Alex Morgan',
        username: 'alexm',
        email: 'alex.morgan@example.com',
        address: Address(
          street: '18 Barrow Court',
          suite: 'Apt 4B',
          city: 'San Francisco',
          zipcode: '94110',
        ),
        phone: '+1 (415) 555-0134',
        website: 'alexm.dev',
        company: Company(name: 'Nova Legal', catchPhrase: 'Justice first', bs: 'counsel'),
      ),
      User(
        id: 2,
        name: 'Jordan Lee',
        username: 'jlee',
        email: 'jordan.lee@example.com',
        address: Address(
          street: '9 Liberty Lane',
          suite: 'Suite 12',
          city: 'Austin',
          zipcode: '73301',
        ),
        phone: '+1 (512) 555-0177',
        website: 'jlee.co',
        company: Company(name: 'Aurora Labs', catchPhrase: 'Build boldly', bs: 'technology'),
      ),
      User(
        id: 3,
        name: 'Taylor Kim',
        username: 'tkim',
        email: 'taylor.kim@example.com',
        address: Address(
          street: '42 Verdict Ave',
          suite: 'Floor 3',
          city: 'Chicago',
          zipcode: '60601',
        ),
        phone: '+1 (312) 555-0198',
        website: 'tkim.io',
        company: Company(name: 'Blue Ridge', catchPhrase: 'Clear counsel', bs: 'advisory'),
      ),
    ];
  }
}
