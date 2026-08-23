import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../base/base_view.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_motion.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/agent_avatar.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../domain/models/legal_agent.dart';
import '../../../routes/app_routes.dart';
import 'agents_controller.dart';

/// All-agents grid with live search.
class AgentsScreen extends StatelessWidget {
  const AgentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AgentsController controller = Get.find<AgentsController>();
    final AppPalette c = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Agents'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.users),
              child: Icon(Icons.language_rounded, color: c.textSubtle),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: AppDimensions.screenPadding,
            child: TextField(
              onChanged: controller.search,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: Obx(
                  () =>
                      controller.query.value != null &&
                          controller.query.value!.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            controller.search('');
                            controller.query.value = null;
                          },
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          Expanded(
            child: BaseView<AgentsController>(
              controller: controller,
              skeleton: const _GridSkeleton(),
              builder: (c) {
                final List<LegalAgent> agents = c.visibleAgents;
                if (agents.isEmpty) {
                  return const _EmptySearch();
                }
                return GridView.builder(
                  padding: AppDimensions.screenPadding,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 260,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.70,
                  ),
                  itemCount: agents.length,
                  itemBuilder: (context, i) => _AgentGridCard(
                    // Replays the entrance when the search query changes.
                    key: ValueKey(
                      '${agents[i].id}-${controller.query.value ?? ''}',
                    ),
                    agent: agents[i],
                    index: i,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AgentGridCard extends StatelessWidget {
  const _AgentGridCard({super.key, required this.agent, this.index = 0});

  final LegalAgent agent;
  final int index;

  @override
  Widget build(BuildContext context) {
    final AppPalette c = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Pressable(
      onTap: () => Get.toNamed(AppRoutes.agentDetail, arguments: agent),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: c.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AgentAvatar(
                  agent: agent,
                  size: 48,
                ),
                const Spacer(),
                Icon(
                  Icons.favorite_border_rounded,
                  size: 19,
                  color: c.textSubtle,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              agent.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 2),
            Text(
              agent.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: c.textSubtle, fontSize: 12),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: agent.practiceAreas
                  .take(2)
                  .map(
                    (a) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: c.surfaceAlt,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        a.label,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: c.textSubtle,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColors.brass, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${agent.rating}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    '· ${Formatters.compact(agent.consultations)} consults',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: c.textSubtle, fontSize: 11.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: AppMotion.staggerStep * min(index, 8)).fadeIn(
      duration: AppMotion.slow,
      curve: AppMotion.emphasized,
    ).slideY(
      begin: 0.1,
      end: 0,
      duration: AppMotion.slow,
      curve: AppMotion.emphasized,
    );
  }
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: AppDimensions.screenPadding,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 260,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.70,
      ),
      itemCount: 6,
      itemBuilder: (_, _) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              children: [
                Skeleton(width: 48, height: 48, radius: 24),
                Spacer(),
                Skeleton(width: 18, height: 18, radius: 9),
              ],
            ),
            SizedBox(height: 14),
            Skeleton(width: 110, height: 15),
            SizedBox(height: 8),
            Skeleton(width: 130, height: 11),
            SizedBox(height: 12),
            Skeleton(width: 90, height: 20, radius: 8),
            Spacer(),
            Skeleton(width: 100, height: 12),
          ],
        ),
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 56,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 14),
          Text(
            'No agents match your search',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
