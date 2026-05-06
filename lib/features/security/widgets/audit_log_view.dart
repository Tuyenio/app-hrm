import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/interactive_overlays.dart';
import '../../../data/mock/permission_data.dart';

/// ============================================================================
/// AUDIT LOG VIEW - Nhật ký hệ thống dạng timeline
/// ============================================================================
class AuditLogView extends StatelessWidget {
  const AuditLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(Icons.history_rounded, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('Nhật ký Hệ thống', style: AppTextStyles.titleLarge.copyWith(fontSize: 15)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => showHrmSuccessSnackbar(context, 'Đang mở nhật ký đầy đủ...'),
                  icon: const Icon(Icons.open_in_new_rounded, size: 14),
                  label: const Text('Xem tất cả'),
                  style: TextButton.styleFrom(textStyle: AppTextStyles.labelMedium.copyWith(fontSize: 11)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...mockAuditLogs.map((log) => _buildLogEntry(log)),
        ],
      ),
    );
  }

  Widget _buildLogEntry(AuditLogEntry log) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.4))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type icon
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: _typeColor(log.type).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_typeIcon(log.type), size: 16, color: _typeColor(log.type)),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                    children: [
                      TextSpan(text: log.user, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      TextSpan(text: ' ${log.action} '),
                      TextSpan(text: log.target, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.primary)),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 11, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(log.timestamp, style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
                    const SizedBox(width: 12),
                    Icon(Icons.computer_rounded, size: 11, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(log.ip, style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'create': return AppColors.success;
      case 'update': return AppColors.info;
      case 'delete': return AppColors.error;
      case 'login': return AppColors.primary;
      default: return AppColors.textTertiary;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'create': return Icons.add_circle_outline_rounded;
      case 'update': return Icons.edit_outlined;
      case 'delete': return Icons.delete_outline_rounded;
      case 'login': return Icons.login_rounded;
      default: return Icons.info_outline_rounded;
    }
  }
}

/// ============================================================================
/// DELEGATION PANEL - Panel ủy quyền tạm thời
/// ============================================================================
class DelegationPanel extends StatelessWidget {
  const DelegationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(Icons.swap_horiz_rounded, size: 18, color: AppColors.warning),
                const SizedBox(width: 8),
                Text('Ủy quyền Tạm thời', style: AppTextStyles.titleLarge.copyWith(fontSize: 15)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Active delegations
                _delegationCard('Nguyễn Văn An', 'Trần Thị Bình', 'Duyệt nghỉ phép, Duyệt OT', '05/05 - 12/05/2026', true),
                const SizedBox(height: 8),
                _delegationCard('Lê Hoàng Cường', 'Phạm Minh Đức', 'Duyệt mua sắm', '01/05 - 08/05/2026', false),
                const SizedBox(height: 12),
                // Add delegation button
                OutlinedButton.icon(
                  onPressed: () => showHrmSuccessSnackbar(context, 'Mở form tạo ủy quyền...'),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Tạo ủy quyền mới'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    side: BorderSide(color: AppColors.border, style: BorderStyle.solid),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _delegationCard(String from, String to, String scope, String period, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? AppColors.warningLight.withValues(alpha: 0.3) : AppColors.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isActive ? AppColors.warning.withValues(alpha: 0.3) : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(from, style: AppTextStyles.titleSmall.copyWith(fontSize: 13)),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 6),
              Text(to, style: AppTextStyles.titleSmall.copyWith(fontSize: 13, color: AppColors.primary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.success.withValues(alpha: 0.1) : AppColors.textTertiary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(isActive ? 'Đang hoạt động' : 'Hết hạn', style: AppTextStyles.labelSmall.copyWith(
                  color: isActive ? AppColors.success : AppColors.textTertiary, fontWeight: FontWeight.w600, fontSize: 10,
                )),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('Phạm vi: $scope', style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
          Text('Thời gian: $period', style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}
