import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// ============================================================================
/// RAG BADGE - Red/Amber/Green Status Indicator
/// Badge trạng thái dự án với thiết kế tinh tế, không quá sáng.
/// ============================================================================
class RagBadge extends StatelessWidget {
  final String status; // 'green', 'amber', 'red'
  final String? label;
  final bool showDot;

  const RagBadge({super.key, required this.status, this.label, this.showDot = true});

  Color get _color {
    switch (status) {
      case 'green': return AppColors.success;
      case 'amber': return AppColors.warning;
      case 'red': return AppColors.error;
      default: return AppColors.textTertiary;
    }
  }

  Color get _bgColor {
    switch (status) {
      case 'green': return AppColors.successLight;
      case 'amber': return AppColors.warningLight;
      case 'red': return AppColors.errorLight;
      default: return AppColors.surfaceVariant;
    }
  }

  String get _defaultLabel {
    switch (status) {
      case 'green': return 'Tốt';
      case 'amber': return 'Cảnh báo';
      case 'red': return 'Chậm';
      default: return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 7, height: 7,
              decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ],
          Text(label ?? _defaultLabel, style: AppTextStyles.labelSmall.copyWith(color: _color, fontWeight: FontWeight.w600, fontSize: 11)),
        ],
      ),
    );
  }
}
