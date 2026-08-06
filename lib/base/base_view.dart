import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'base_controller.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/widgets/gradient_button.dart';
import '../core/widgets/skeleton.dart';

/// Declarative wrapper around [BaseController] state.
///
/// Renders one of three states automatically:
/// - loading (shimmer skeleton)
/// - error (message + retry)
/// - content (the screen's actual UI)
///
/// Usage:
/// ```dart
/// BaseView<HomeController>(
///   controller: Get.find(),
///   skeleton: _AgentListSkeleton(),
///   builder: (c) => _buildAgents(c),
/// )
/// ```
class BaseView<T extends BaseController> extends StatelessWidget {
  const BaseView({
    super.key,
    required this.controller,
    required this.builder,
    this.skeleton,
    this.onRetry,
  });

  final T controller;
  final Widget Function(T controller) builder;
  final Widget? skeleton;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return skeleton ?? const _DefaultSkeleton();
      }
      final String? errorMessage = controller.error.value;
      if (errorMessage != null && errorMessage.isNotEmpty) {
        return _ErrorState(
          message: errorMessage,
          onRetry: onRetry ?? controller.retry,
        );
      }
      return builder(controller);
    });
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.danger.withValues(alpha: 0.12),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 40,
                color: AppColors.danger,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            Text(
              'Unable to load',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            SizedBox(
              width: 180,
              child: GradientButton(
                label: 'Try again',
                icon: Icons.refresh_rounded,
                onPressed: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DefaultSkeleton extends StatelessWidget {
  const _DefaultSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.screenPadding,
      child: Column(
        children: [
          for (int i = 0; i < 6; i++) ...[
            const AgentCardSkeleton(),
            if (i < 5) const SizedBox(height: AppDimensions.md),
          ],
        ],
      ),
    );
  }
}
