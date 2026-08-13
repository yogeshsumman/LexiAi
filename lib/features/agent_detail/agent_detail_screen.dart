import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/agent_avatar.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../domain/models/legal_agent.dart';
import '../../../routes/app_routes.dart';

/// Agent profile: hero header, stats, bio, practice areas, CTA bar.
class AgentDetailScreen extends StatelessWidget {
  const AgentDetailScreen({super.key});

  LegalAgent? get _agent => Get.arguments as LegalAgent?;

  @override
  Widget build(BuildContext context) {
    final LegalAgent? agent = _agent;
    if (agent == null) {
      return const _AgentMissingView();
    }
    final AppPalette c = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                leading: _RoundBackButton(onTap: () => Get.back()),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _RoundAction(
                      icon: Icons.favorite_border_rounded,
                      onTap: () => Get.snackbar('LexiAI', 'Saved to favorites'),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: _HeroHeader(agent: agent),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppDimensions.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StatsRow(agent: agent),
                      const SizedBox(height: 24),
                      _SectionTitle(title: AppStrings.about),
                      const SizedBox(height: 10),
                      Text(
                        agent.bio,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: c.textSubtle),
                      ),
                      const SizedBox(height: 24),
                      _SectionTitle(title: AppStrings.practiceAreas),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: agent.practiceAreas
                            .map(
                              (a) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: c.surfaceAlt,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: c.divider),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(a.icon, size: 17, color: c.accent),
                                    const SizedBox(width: 8),
                                    Text(
                                      a.label,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                      _SectionTitle(title: 'Languages'),
                      const SizedBox(height: 12),
                      Row(
                        children: agent.languages
                            .map(
                              (l) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Chip(label: Text(l)),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _CtaBar(agent: agent),
          ),
        ],
      ),
    );
  }
}

class _AgentMissingView extends StatelessWidget {
  const _AgentMissingView();

  @override
  Widget build(BuildContext context) {
    final AppPalette c = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Scaffold(
      appBar: AppBar(leading: _RoundBackButton(onTap: () => Get.back())),
      body: Center(
        child: Padding(
          padding: AppDimensions.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off_rounded, size: 56, color: c.textSubtle),
              const SizedBox(height: 16),
              Text(
                'Agent not found',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Please go back and select an agent again.',
                textAlign: TextAlign.center,
                style: TextStyle(color: c.textSubtle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.agent});

  final LegalAgent agent;

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = AppColors
        .agentGradients[agent.gradientIndex % AppColors.agentGradients.length];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors[0], colors[1]],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AgentAvatar(
            emoji: agent.emoji,
            gradientIndex: agent.gradientIndex,
            size: 116,
          ),
          const SizedBox(height: 18),
          Text(
            agent.name,
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 15,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  agent.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundBackButton extends StatelessWidget {
  const _RoundBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: 0.25),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.25),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.agent});

  final LegalAgent agent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Stat(
          value: '${agent.rating}',
          label: 'Rating',
          icon: Icons.star_rounded,
        ),
        _Stat(
          value: Formatters.compact(agent.consultations),
          label: AppStrings.consultations,
          icon: Icons.forum_rounded,
        ),
        _Stat(
          value: '${(agent.successRate * 100).round()}%',
          label: AppStrings.successRate,
          icon: Icons.verified_rounded,
        ),
        _Stat(
          value: Formatters.shortDuration(agent.responseTime),
          label: AppStrings.responseTime,
          icon: Icons.schedule_rounded,
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.icon});

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final AppPalette c = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: c.divider),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: c.accent),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: c.textSubtle, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.headlineMedium);
  }
}

class _CtaBar extends StatelessWidget {
  const _CtaBar({required this.agent});

  final LegalAgent agent;

  @override
  Widget build(BuildContext context) {
    final AppPalette c = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.md,
        AppDimensions.md,
        AppDimensions.md,
        MediaQuery.of(context).padding.bottom + AppDimensions.md,
      ),
      decoration: BoxDecoration(
        color: c.background.withValues(alpha: 0.94),
        border: Border(top: BorderSide(color: c.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GradientButton(
              label: AppStrings.videoConsult,
              icon: Icons.videocam_rounded,
              onPressed: () =>
                  Get.toNamed(AppRoutes.videoCall, arguments: agent),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GradientButton(
              label: AppStrings.chatNow,
              icon: Icons.chat_bubble_rounded,
              gradient: LinearGradient(
                colors: [c.surfaceAlt, c.surfaceAlt],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              foreground: c.text,
              onPressed: () => Get.toNamed(AppRoutes.chat, arguments: agent),
            ),
          ),
        ],
      ),
    );
  }
}
