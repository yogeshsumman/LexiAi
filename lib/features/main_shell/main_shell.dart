import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_motion.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/pressable.dart';
import '../agents/agents_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import 'main_shell_controller.dart';

/// Bottom-nav shell hosting the main tabs.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const List<Widget> _tabs = [
    HomeScreen(),
    AgentsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final MainShellController controller = Get.find<MainShellController>();
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Obx(
        () =>
            IndexedStack(index: controller.currentIndex.value, children: _tabs),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(
          AppDimensions.md,
          0,
          AppDimensions.md,
          AppDimensions.md,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: dark ? const Color(0xFF182236) : Colors.white,
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? 0.5 : 0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Obx(
              () => Row(
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    selected: controller.currentIndex.value == 0,
                    onTap: () => controller.switchTo(0),
                  ),
                  _NavItem(
                    icon: Icons.workspace_premium_rounded,
                    label: 'Agents',
                    selected: controller.currentIndex.value == 1,
                    onTap: () => controller.switchTo(1),
                  ),
                  _NavItem(
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    selected: controller.currentIndex.value == 2,
                    onTap: () => controller.switchTo(2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Pressable(
        onTap: onTap,
        scale: 0.94,
        dim: 0.85,
        child: AnimatedContainer(
          duration: AppMotion.base,
          curve: AppMotion.emphasized,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: selected ? kNavyGradient : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: selected ? 1.08 : 1.0,
                duration: AppMotion.base,
                curve: AppMotion.spring,
                child: Icon(
                  icon,
                  size: 22,
                  color: selected
                      ? AppColors.porcelain
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              AnimatedSize(
                duration: AppMotion.base,
                curve: AppMotion.emphasized,
                child: selected
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                            color: AppColors.porcelain,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
