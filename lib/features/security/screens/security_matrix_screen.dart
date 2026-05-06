import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/interactive_overlays.dart';
import '../../../data/mock/permission_data.dart';
import '../../../data/mock/employee_data.dart';
import '../widgets/permission_table.dart';
import '../widgets/mass_action_toolbar.dart';
import '../widgets/audit_log_view.dart';

/// ============================================================================
/// SECURITY MATRIX SCREEN - Redesign mobile-first
/// Mobile: Tabs thay sidebar, scrollable content, bottom sheet pickers.
/// Desktop: Split sidebar + content.
/// ============================================================================
class SecurityMatrixScreen extends StatefulWidget {
  const SecurityMatrixScreen({super.key});

  @override
  State<SecurityMatrixScreen> createState() => _SecurityMatrixScreenState();
}

class _SecurityMatrixScreenState extends State<SecurityMatrixScreen>
    with SingleTickerProviderStateMixin {
  String _selectedRoleId = 'r1';
  int _tabIndex = 0;

  MockRole get _selectedRole =>
      mockRoles.firstWhere((r) => r.id == _selectedRoleId);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return isMobile ? _buildMobileLayout() : _buildDesktopLayout();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // MOBILE LAYOUT
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildMobileHeader(),
            _buildMobileTabs(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _tabIndex == 0
                    ? _buildMobilePermissionTab()
                    : _tabIndex == 1
                    ? const AuditLogView()
                    : _buildDelegationContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security_rounded, size: 22, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Phân quyền',
                  style: AppTextStyles.headlineLarge.copyWith(fontSize: 20),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showSaveConfirmation(context),
                icon: const Icon(Icons.save_rounded, size: 14),
                label: const Text('Lưu'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  textStyle: AppTextStyles.labelMedium.copyWith(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Role picker button
          GestureDetector(
            onTap: _showMobileRolePicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primaryLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.admin_panel_settings_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedRole.name,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.primary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${_selectedRole.userCount} người dùng • ${_selectedRole.description}',
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.expand_more_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Action buttons for mobile
          Row(children: [
            Expanded(child: _mobileActionBtn(Icons.add_rounded, 'Tạo Role', AppColors.success, () => _showCreateRoleSheet(context))),
            const SizedBox(width: 8),
            Expanded(child: _mobileActionBtn(Icons.copy_rounded, 'Nhân bản', AppColors.info, () => _showCloneRoleDialog(context))),
            const SizedBox(width: 8),
            Expanded(child: _mobileActionBtn(Icons.download_rounded, 'Xuất Log', AppColors.textSecondary, () => showExportDialog(context))),
          ]),
        ],
      ),
    );
  }

  Widget _buildMobileTabs() {
    final tabs = [
      ('Quyền', Icons.grid_on_rounded),
      ('Nhật ký', Icons.history_rounded),
      ('Ủy quyền', Icons.swap_horiz_rounded),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = i == _tabIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tabIndex = i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: isActive
                      ? null
                      : Border.all(color: AppColors.borderLight),
                ),
                margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tabs[i].$2,
                      size: 14,
                      color: isActive ? Colors.white : AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tabs[i].$1,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isActive ? Colors.white : AppColors.textTertiary,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMobilePermissionTab() {
    return Column(
      children: [
        PermissionTable(
          key: ValueKey(_selectedRoleId),
          role: _selectedRole,
          layout: PermissionLayout.cards,
        ),
      ],
    );
  }

  void _showMobileRolePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Chọn vai trò',
              style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),
            ...mockRoles.map((role) {
              final isSelected = role.id == _selectedRoleId;
              return ListTile(
                leading: Icon(
                  Icons.admin_panel_settings_rounded,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  size: 20,
                ),
                title: Text(
                  role.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  '${role.userCount} người dùng',
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppColors.primary,
                        size: 20,
                      )
                    : null,
                tileColor: isSelected ? AppColors.primarySurface : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {
                  setState(() => _selectedRoleId = role.id);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // DESKTOP LAYOUT
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          _buildDesktopRoleSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildDesktopHeader(),
                _buildDesktopTabs(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: _tabIndex == 0
                        ? PermissionTable(
                            key: ValueKey(_selectedRoleId),
                            role: _selectedRole,
                          )
                        : _tabIndex == 1
                        ? const AuditLogView()
                        : _buildDelegationContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopRoleSidebar() {
    return Container(
      width: 230,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
            child: Row(
              children: [
                Icon(
                  Icons.security_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Vai trò',
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: mockRoles.map((role) {
                final isSelected = role.id == _selectedRoleId;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => setState(() => _selectedRoleId = role.id),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primarySurface : null,
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.primaryLight.withValues(
                                    alpha: 0.3,
                                  ),
                                )
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.admin_panel_settings_rounded,
                                  size: 18,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    role.name,
                                    style: AppTextStyles.titleSmall.copyWith(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 26, top: 2),
                              child: Text(
                                '${role.userCount} người dùng',
                                style: AppTextStyles.labelSmall.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ma trận Phân quyền',
                      style: AppTextStyles.headlineLarge.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Vai trò: ${_selectedRole.name} • ${_selectedRole.description}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showSaveConfirmation(context),
                icon: const Icon(Icons.save_rounded, size: 16),
                label: const Text('Lưu thay đổi'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const MassActionToolbar(),
        ],
      ),
    );
  }

  Widget _buildDesktopTabs() {
    final tabs = ['Ma trận Quyền', 'Nhật ký Hệ thống', 'Ủy quyền'];
    final icons = [
      Icons.grid_on_rounded,
      Icons.history_rounded,
      Icons.swap_horiz_rounded,
    ];
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = i == _tabIndex;
          return GestureDetector(
            onTap: () => setState(() => _tabIndex = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icons[i],
                    size: 16,
                    color: isActive
                        ? AppColors.primary
                        : AppColors.textTertiary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tabs[i],
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.textTertiary,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDelegationContent() {
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
                Icon(
                  Icons.swap_horiz_rounded,
                  size: 18,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ủy quyền Tạm thời',
                  style: AppTextStyles.titleLarge.copyWith(fontSize: 15),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _delegationCard(
                  'Nguyễn Văn An',
                  'Trần Thị Bình',
                  'Duyệt nghỉ phép, Duyệt OT',
                  '05/05 - 12/05/2026',
                  true,
                ),
                const SizedBox(height: 8),
                _delegationCard(
                  'Lê Hoàng Cường',
                  'Phạm Minh Đức',
                  'Duyệt mua sắm',
                  '01/05 - 08/05/2026',
                  false,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _showCreateDelegationSheet(context),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Tạo ủy quyền mới'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _delegationCard(
    String from,
    String to,
    String scope,
    String period,
    bool isActive,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.warningLight.withValues(alpha: 0.3)
            : AppColors.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive
              ? AppColors.warning.withValues(alpha: 0.3)
              : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [
              Text(
                from,
                style: AppTextStyles.titleSmall.copyWith(fontSize: 13),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                size: 14,
                color: AppColors.textTertiary,
              ),
              Text(
                to,
                style: AppTextStyles.titleSmall.copyWith(
                  fontSize: 13,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (isActive ? AppColors.success : AppColors.textTertiary)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isActive ? 'Hoạt động' : 'Hết hạn',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isActive
                        ? AppColors.success
                        : AppColors.textTertiary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Phạm vi: $scope',
            style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
          ),
          Text(
            'Thời gian: $period',
            style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ── MOBILE ACTION BUTTON ────────────────────────────────────────────────
  Widget _mobileActionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.2))),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.labelMedium.copyWith(color: color, fontWeight: FontWeight.w600, fontSize: 11)),
        ]),
      ),
    );
  }

  // ── SAVE CONFIRMATION ──────────────────────────────────────────────────
  void _showSaveConfirmation(BuildContext context) async {
    final confirmed = await showHrmConfirmDialog(
      context,
      title: 'Lưu thay đổi quyền?',
      message: 'Các thay đổi sẽ được áp dụng cho vai trò "${_selectedRole.name}" và ảnh hưởng ${_selectedRole.userCount} người dùng.',
      confirmText: 'Lưu',
      icon: Icons.save_rounded,
    );
    if (confirmed == true && context.mounted) {
      showHrmSuccessSnackbar(context, 'Đã lưu thay đổi quyền thành công');
    }
  }

  // ── CREATE ROLE SHEET ───────────────────────────────────────────────────
  void _showCreateRoleSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 12),
            Text('Tạo vai trò mới', style: AppTextStyles.headlineSmall.copyWith(fontSize: 18)),
            const SizedBox(height: 16),
            Text('Tên vai trò *', style: AppTextStyles.labelLarge),
            const SizedBox(height: 6),
            const TextField(decoration: InputDecoration(hintText: 'VD: Trưởng nhóm')),
            const SizedBox(height: 14),
            Text('Mô tả', style: AppTextStyles.labelLarge),
            const SizedBox(height: 6),
            const TextField(maxLines: 2, decoration: InputDecoration(hintText: 'Mô tả quyền hạn của vai trò...')),
            const SizedBox(height: 14),
            Text('Sao chép quyền từ', style: AppTextStyles.labelLarge),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderLight)),
              child: DropdownButtonHideUnderline(child: DropdownButton<String>(
                isExpanded: true, value: null, hint: const Text('Không (tạo trắng)'),
                items: mockRoles.map((r) => DropdownMenuItem(value: r.id, child: Text(r.name))).toList(),
                onChanged: (_) {},
              )),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(
                onPressed: () { Navigator.pop(context); showHrmSuccessSnackbar(context, 'Đã tạo vai trò mới'); },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                child: const Text('Tạo vai trò'),
              )),
            ]),
          ]),
        ),
      ),
    );
  }

  // ── CLONE ROLE DIALOG ──────────────────────────────────────────────────
  void _showCloneRoleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Nhân bản vai trò', style: AppTextStyles.headlineSmall.copyWith(fontSize: 17)),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Tạo bản sao của vai trò "${_selectedRole.name}" với tất cả quyền hiện tại.', style: AppTextStyles.bodySmall),
          const SizedBox(height: 16),
          Text('Tên vai trò mới', style: AppTextStyles.labelLarge),
          const SizedBox(height: 6),
          TextField(decoration: InputDecoration(hintText: '${_selectedRole.name} (Copy)')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); showHrmSuccessSnackbar(context, 'Đã nhân bản vai trò thành công'); },
            child: const Text('Nhân bản'),
          ),
        ],
      ),
    );
  }

  // ── CREATE DELEGATION SHEET ─────────────────────────────────────────────
  void _showCreateDelegationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 12),
            Text('Tạo ủy quyền mới', style: AppTextStyles.headlineSmall.copyWith(fontSize: 18)),
            const SizedBox(height: 16),
            Text('Người ủy quyền *', style: AppTextStyles.labelLarge),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderLight)),
              child: DropdownButtonHideUnderline(child: DropdownButton<String>(
                isExpanded: true, value: null, hint: const Text('Chọn người ủy quyền'),
                items: mockEmployeeList.take(6).map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                onChanged: (_) {},
              )),
            ),
            const SizedBox(height: 14),
            Text('Người được ủy quyền *', style: AppTextStyles.labelLarge),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderLight)),
              child: DropdownButtonHideUnderline(child: DropdownButton<String>(
                isExpanded: true, value: null, hint: const Text('Chọn người nhận'),
                items: mockEmployeeList.take(6).map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                onChanged: (_) {},
              )),
            ),
            const SizedBox(height: 14),
            Text('Phạm vi ủy quyền', style: AppTextStyles.labelLarge),
            const SizedBox(height: 6),
            const TextField(decoration: InputDecoration(hintText: 'VD: Duyệt nghỉ phép, Duyệt OT')),
            const SizedBox(height: 14),
            Text('Thời gian', style: AppTextStyles.labelLarge),
            const SizedBox(height: 6),
            Row(children: [
              Expanded(child: GestureDetector(
                onTap: () => showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2027)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderLight)),
                  child: Row(children: [
                    const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: 8),
                    Text('Từ ngày', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                  ]),
                ),
              )),
              const SizedBox(width: 8),
              Expanded(child: GestureDetector(
                onTap: () => showDatePicker(context: context, initialDate: DateTime.now().add(const Duration(days: 7)), firstDate: DateTime.now(), lastDate: DateTime(2027)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderLight)),
                  child: Row(children: [
                    const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: 8),
                    Text('Đến ngày', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                  ]),
                ),
              )),
            ]),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(
                onPressed: () { Navigator.pop(context); showHrmSuccessSnackbar(context, 'Đã tạo ủy quyền mới'); },
                child: const Text('Tạo ủy quyền'),
              )),
            ]),
          ]),
        ),
      ),
    );
  }
}
