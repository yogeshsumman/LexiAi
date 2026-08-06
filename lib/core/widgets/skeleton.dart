import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_dimensions.dart';

/// Shimmer placeholder used while content loads (BaseView loading state).
class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.radius = 8,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: dark ? const Color(0xFF1E2940) : const Color(0xFFE7E1D4),
      highlightColor: dark ? const Color(0xFF2C3A5C) : const Color(0xFFF4F0E6),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// A list-card shaped skeleton for agent lists/grids.
class AgentCardSkeleton extends StatelessWidget {
  const AgentCardSkeleton({super.key, this.list = true});

  final bool list;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppDimensions.cardPadding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          const Skeleton(width: 56, height: 56, radius: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Skeleton(width: 140, height: 16),
                SizedBox(height: 10),
                Skeleton(width: 90, height: 12),
                SizedBox(height: 10),
                Skeleton(width: double.infinity, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
