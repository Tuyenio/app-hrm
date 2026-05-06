import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/permission_data.dart';

/// ============================================================================
/// PERMISSION TABLE - Ma trận checkbox phân quyền
/// DataTable dense với sticky headers, toggle switches trong cells.
/// ============================================================================
class PermissionTable extends StatefulWidget {
  final MockRole role;
  const PermissionTable({super.key, required this.role});

  @override
  State<PermissionTable> createState() => _PermissionTableState();
}

class _PermissionTableState extends State<PermissionTable> {
  late Map<String, Map<String, bool>> _permissions;

  @override
  void initState() {
    super.initState();
    // Deep copy permissions to allow toggling
    _permissions = {
      for (var entry in widget.role.permissions.entries)
        entry.key: Map<String, bool>.from(entry.value),
    };
  }

  @override
  void didUpdateWidget(covariant PermissionTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.role.id != widget.role.id) {
      _permissions = {
        for (var entry in widget.role.permissions.entries)
          entry.key: Map<String, bool>.from(entry.value),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 600),
      child: Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table header row (sticky)
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withValues(alpha: 0.6),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                // Sticky left column header
                Container(
                  width: 140,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: AppColors.divider)),
                  ),
                  child: Text('Module', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w700)),
                ),
                // Action headers
                ...permissionActions.map((action) => Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    alignment: Alignment.center,
                    child: Text(action, style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 11)),
                  ),
                )),
              ],
            ),
          ),
          // Data rows
          ...permissionModules.asMap().entries.map((entry) => _buildRow(entry.key, entry.value)),
        ],
      ),
    ),
    );
  }

  Widget _buildRow(int index, String module) {
    final modulePerms = _permissions[module] ?? {};
    return Container(
      decoration: BoxDecoration(
        color: index.isEven ? null : AppColors.surfaceVariant.withValues(alpha: 0.15),
        border: Border(bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          // Module name (sticky left)
          Container(
            width: 140,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: AppColors.divider.withValues(alpha: 0.5))),
            ),
            child: Row(
              children: [
                Icon(_moduleIcon(module), size: 16, color: AppColors.primary.withValues(alpha: 0.7)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(module, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500, color: AppColors.textPrimary, fontSize: 12)),
                ),
              ],
            ),
          ),
          // Permission checkboxes
          ...permissionActions.map((action) => Expanded(
            child: Center(
              child: Transform.scale(
                scale: 0.85,
                child: Checkbox(
                  value: modulePerms[action] ?? false,
                  onChanged: (val) {
                    setState(() {
                      _permissions[module]?[action] = val ?? false;
                    });
                  },
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  IconData _moduleIcon(String module) {
    switch (module) {
      case 'Core HR': return Icons.people_outline_rounded;
      case 'Tuyển dụng': return Icons.person_add_alt_rounded;
      case 'Chấm công': return Icons.access_time_rounded;
      case 'Tính lương': return Icons.account_balance_wallet_outlined;
      case 'Dự án': return Icons.rocket_launch_outlined;
      case 'Báo cáo': return Icons.assessment_outlined;
      case 'Hệ thống': return Icons.settings_outlined;
      default: return Icons.folder_outlined;
    }
  }
}
