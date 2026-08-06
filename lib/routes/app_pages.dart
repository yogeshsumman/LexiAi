import 'package:get/get.dart';

import '../features/agent_detail/agent_detail_screen.dart';
import '../features/agents/agents_controller.dart';
import '../features/consultation/chat_screen.dart';
import '../features/consultation/video_call_screen.dart';
import '../features/home/home_controller.dart';
import '../features/main_shell/main_shell.dart';
import '../features/main_shell/main_shell_controller.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/users/users_screen.dart';
import 'app_routes.dart';

/// GetX route table. Every page is registered here with its bindings
/// (controllers are created and disposed automatically by GetX).
class AppPages {
  AppPages._();

  static const Transition defaultTransition = Transition.cupertino;

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: defaultTransition,
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      transition: defaultTransition,
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainShell(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MainShellController(), fenix: true);
        Get.lazyPut(() => HomeController(), fenix: true);
        Get.lazyPut(() => AgentsController(), fenix: true);
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.agentDetail,
      page: () => const AgentDetailScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatScreen(),
      transition: Transition.upToDown,
    ),
    GetPage(
      name: AppRoutes.videoCall,
      page: () => const VideoCallScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.users,
      page: () => const UsersScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
