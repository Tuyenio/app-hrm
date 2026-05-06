import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// ============================================================================
/// USER AVATAR - Avatar nhân viên với online status
/// Hỗ trợ hiển thị initials khi không có ảnh, status dot, size linh hoạt.
/// ============================================================================
class UserAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final bool showStatus;
  final bool isOnline;
  final Color? backgroundColor;

  const UserAvatar({
    super.key,
    required this.initials,
    this.size = 40,
    this.showStatus = false,
    this.isOnline = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size, height: size,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initials.length > 2 ? initials.substring(0, 2) : initials,
              style: AppTextStyles.labelMedium.copyWith(
                color: backgroundColor != null ? Colors.white : AppColors.primary,
                fontSize: size * 0.32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        if (showStatus)
          Positioned(
            right: 0, bottom: 0,
            child: Container(
              width: size * 0.3, height: size * 0.3,
              decoration: BoxDecoration(
                color: isOnline ? AppColors.online : AppColors.textTertiary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
