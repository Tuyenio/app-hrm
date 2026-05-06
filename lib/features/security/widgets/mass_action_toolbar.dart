import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/interactive_overlays.dart';
import '../../../data/mock/permission_data.dart';

/// ============================================================================
/// MASS ACTION TOOLBAR - Thanh hành động hàng loạt
/// ============================================================================
class MassActionToolbar extends StatelessWidget {
  const MassActionToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          // Search
          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)),
              child: TextField(
                style: AppTextStyles.bodySmall,
                decoration: InputDecoration(
                  hintText: 'Tìm vai trò hoặc module...',
                  hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                  prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.textTertiary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Action buttons
          _actionButton(context, Icons.policy_outlined, 'Áp dụng Chính sách', AppColors.primary, true, () => _showApplyPolicyDialog(context)),
          const SizedBox(width: 8),
          _actionButton(context, Icons.copy_rounded, 'Nhân bản Role', AppColors.textSecondary, false, () => _showCloneRoleDialog(context)),
          const SizedBox(width: 8),
          _actionButton(context, Icons.download_rounded, 'Xuất Audit Log', AppColors.textSecondary, false, () => showExportDialog(context)),
          const SizedBox(width: 8),
          _actionButton(context, Icons.add_rounded, 'Tạo Role mới', AppColors.success, true, () => _showCreateRoleDialog(context)),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, IconData icon, String label, Color color, bool filled, VoidCallback onTap) {
    if (filled) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          textStyle: AppTextStyles.labelMedium.copyWith(fontSize: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        textStyle: AppTextStyles.labelMedium.copyWith(fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showApplyPolicyDialog(BuildContext context) async {
    final confirmed = await showHrmConfirmDialog(
      context,
      title: 'Áp dụng chính sách?',
      message: 'Chính sách sẽ được áp dụng cho tất cả các vai trò trong hệ thống.',
      confirmText: 'Áp dụng',
      icon: Icons.policy_outlined,
    );
    if (confirmed == true && context.mounted) showHrmSuccessSnackbar(context, 'Đã áp dụng chính sách');
  }

  void _showCloneRoleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Nhân bản vai trò', style: AppTextStyles.headlineSmall.copyWith(fontSize: 17)),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Chọn vai trò nguồn và đặt tên cho vai trò mới.', style: AppTextStyles.bodySmall),
          const SizedBox(height: 16),
          Text('Vai trò nguồn', style: AppTextStyles.labelLarge),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderLight)),
            child: DropdownButtonHideUnderline(child: DropdownButton<String>(
              isExpanded: true, value: null, hint: const Text('Chọn vai trò'),
              items: mockRoles.map((r) => DropdownMenuItem(value: r.id, child: Text(r.name))).toList(),
              onChanged: (_) {},
            )),
          ),
          const SizedBox(height: 12),
          Text('Tên mới', style: AppTextStyles.labelLarge),
          const SizedBox(height: 6),
          const TextField(decoration: InputDecoration(hintText: 'Tên vai trò mới')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); showHrmSuccessSnackbar(context, 'Đã nhân bản vai trò'); },
            child: const Text('Nhân bản'),
          ),
        ],
      ),
    );
  }

  void _showCreateRoleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Tạo vai trò mới', style: AppTextStyles.headlineSmall.copyWith(fontSize: 17)),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Tên vai trò *', style: AppTextStyles.labelLarge),
          const SizedBox(height: 6),
          const TextField(decoration: InputDecoration(hintText: 'VD: Trưởng nhóm')),
          const SizedBox(height: 12),
          Text('Mô tả', style: AppTextStyles.labelLarge),
          const SizedBox(height: 6),
          const TextField(maxLines: 2, decoration: InputDecoration(hintText: 'Mô tả quyền hạn...')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); showHrmSuccessSnackbar(context, 'Đã tạo vai trò mới'); },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// ROLE MANAGER - Sidebar quản lý vai trò
/// ============================================================================
class RoleManager extends StatelessWidget {
  final List<({String id, String name, String description, int userCount})> roles;
  final String selectedRoleId;
  final ValueChanged<String> onRoleSelected;

  const RoleManager({super.key, required this.roles, required this.selectedRoleId, required this.onRoleSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Icon(Icons.security_rounded, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('Vai trò', style: AppTextStyles.headlineSmall.copyWith(fontSize: 16)),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: roles.length,
              itemBuilder: (context, i) {
                final role = roles[i];
                final isSelected = role.id == selectedRoleId;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onRoleSelected(role.id),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primarySurface : null,
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected ? Border.all(color: AppColors.primaryLight.withValues(alpha: 0.3)) : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.admin_panel_settings_rounded,
                                  size: 18,
                                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(role.name, style: AppTextStyles.titleSmall.copyWith(
                                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  )),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 26),
                              child: Text('${role.userCount} người dùng', style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
                            ),
                          ],
                        ),
                      ),
                    ),
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
