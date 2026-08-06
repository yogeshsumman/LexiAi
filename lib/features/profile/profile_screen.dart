import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_routes.dart';

/// Account screen: profile header, membership card, settings.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette c = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppDimensions.md,
          MediaQuery.of(context).padding.top + 20,
          AppDimensions.md,
          40,
        ),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: kGoldGradient,
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.4),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('👩‍⚖️', style: TextStyle(fontSize: 40)),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Alex Morgan',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  'alex.morgan@example.com',
                  style: TextStyle(color: c.textSubtle, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const _MembershipCard(),
          const SizedBox(height: 28),
          _SettingsTile(
            icon: Icons.notifications_none_rounded,
            label: 'Notifications',
            subtitle: 'Case updates, reminders',
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
          _SettingsTile(
            icon: Icons.security_rounded,
            label: 'Privacy & Security',
            subtitle: 'Biometric lock, data controls',
          ),
          _SettingsTile(
            icon: Icons.history_rounded,
            label: 'Consultation history',
            subtitle: 'Your past sessions',
            onTap: () => Get.toNamed(AppRoutes.users),
          ),
          _SettingsTile(
            icon: Icons.help_outline_rounded,
            label: 'Help & Support',
            subtitle: 'FAQs, legal disclaimers',
          ),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            label: 'About LexiAI',
            subtitle: 'Version 1.0.0 · Open source',
          ),
          const SizedBox(height: 24),
          _SignOutTile(c: c),
        ],
      ),
    );
  }
}

class _MembershipCard extends StatelessWidget {
  const _MembershipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: kNavyGradient,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF16294A).withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      color: AppColors.goldLight,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'PRO MEMBER',
                      style: TextStyle(
                        color: AppColors.goldLight,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Unlimited AI consultations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Includes video calls & document review',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.goldLight,
            size: 34,
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette c = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.divider),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: c.surfaceAlt,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: c.accent, size: 21),
        ),
        title: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: c.textSubtle, fontSize: 12.5),
        ),
        trailing:
            trailing ?? Icon(Icons.chevron_right_rounded, color: c.textSubtle),
      ),
    );
  }
}

class _SignOutTile extends StatelessWidget {
  const _SignOutTile({required this.c});

  final AppPalette c;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: const Icon(Icons.logout_rounded, color: AppColors.danger),
        title: const Text(
          'Sign out',
          style: TextStyle(
            color: AppColors.danger,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        onTap: () => Get.snackbar('LexiAI', 'Sign out coming soon'),
      ),
    );
  }
}
