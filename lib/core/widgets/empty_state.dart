import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// ============================================================================
/// EMPTY STATE - Widget trạng thái rỗng premium
/// Dùng khi danh sách hoặc bộ lọc không có kết quả.
/// ============================================================================
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateWidget({
    super.key,
    this.icon = Icons.inbox_rounded,
    this.title = 'Không có dữ liệu',
    this.subtitle = 'Chưa có nội dung nào để hiển thị',
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container with gradient background
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primarySurface,
                    AppColors.primarySurface.withValues(alpha: 0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 17,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
