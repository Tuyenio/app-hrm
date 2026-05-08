import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// ============================================================================
/// SHIMMER LOADING - Enterprise loading effect
/// Pure Flutter animation, không dùng thêm package.
/// Cung cấp các variant: ShimmerBox, ShimmerCard, ShimmerList, ShimmerChart.
/// ============================================================================

/// Base shimmer effect widget
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: const [
                Color(0xFFE8E8E8),
                Color(0xFFF5F5F5),
                Color(0xFFE8E8E8),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer card that mimics a KPI/stat card loading
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerBox(width: 40, height: 40, borderRadius: 10),
              Spacer(),
              ShimmerBox(width: 60, height: 22, borderRadius: 12),
            ],
          ),
          SizedBox(height: 14),
          ShimmerBox(width: 100, height: 28, borderRadius: 6),
          SizedBox(height: 8),
          ShimmerBox(width: 80, height: 14, borderRadius: 4),
        ],
      ),
    );
  }
}

/// Shimmer list item
class ShimmerListItem extends StatelessWidget {
  const ShimmerListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: const Row(
        children: [
          ShimmerBox(width: 40, height: 40, borderRadius: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: double.infinity, height: 14, borderRadius: 4),
                SizedBox(height: 6),
                ShimmerBox(width: 120, height: 10, borderRadius: 4),
              ],
            ),
          ),
          SizedBox(width: 12),
          ShimmerBox(width: 50, height: 22, borderRadius: 6),
        ],
      ),
    );
  }
}

/// Shimmer list (multiple items)
class ShimmerList extends StatelessWidget {
  final int itemCount;
  const ShimmerList({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (_) => const ShimmerListItem()),
    );
  }
}

/// Shimmer chart placeholder
class ShimmerChart extends StatelessWidget {
  final double height;
  const ShimmerChart({super.key, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: 140, height: 18, borderRadius: 4),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                7,
                (i) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ShimmerBox(
                      width: double.infinity,
                      height: (0.3 + (i % 3) * 0.25) * (height - 60),
                      borderRadius: 4,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
