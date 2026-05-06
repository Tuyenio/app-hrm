import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../data/mock/employee_data.dart';

/// ============================================================================
/// EMPLOYEE LIST SCREEN - Quản lý Nhân sự Core HR (Mobile-first)
/// ============================================================================
class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  String _searchQuery = '';
  String _departmentFilter = 'Tất cả';
  int _tabIndex = 0;

  static const _departments = ['Tất cả', 'IT', 'HR', 'Sales', 'Design', 'DevOps'];

  List<MockEmployee> get _filteredEmployees {
    return mockEmployeeList.where((e) {
      final matchSearch = _searchQuery.isEmpty || e.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchDept = _departmentFilter == 'Tất cả' || e.department == _departmentFilter;
      return matchSearch && matchDept;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isMobile),
            _buildTabs(),
            Expanded(
              child: _tabIndex == 0
                  ? _buildEmployeeList(isMobile)
                  : _buildOrgChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.fromLTRB(isMobile ? 16 : 24, 12, isMobile ? 16 : 24, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nhân sự', style: AppTextStyles.headlineLarge.copyWith(fontSize: isMobile ? 20 : 24)),
                    Text('${mockEmployeeList.length} nhân viên hoạt động', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              if (!isMobile)
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add_rounded, size: 18),
                  label: const Text('Thêm nhân viên'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                ),
              if (isMobile)
                Container(
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.person_add_rounded, size: 18, color: Colors.white),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Search + Filter
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: AppTextStyles.bodySmall,
                    decoration: InputDecoration(
                      hintText: 'Tìm theo tên, email, phòng ban...',
                      hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                      prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textTertiary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderLight)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _departmentFilter,
                    items: _departments.map((d) => DropdownMenuItem(value: d, child: Text(d, style: AppTextStyles.bodySmall.copyWith(fontSize: 12)))).toList(),
                    onChanged: (v) => setState(() => _departmentFilter = v ?? 'Tất cả'),
                    icon: const Icon(Icons.expand_more_rounded, size: 18),
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = [('Danh sách', Icons.people_rounded), ('Sơ đồ tổ chức', Icons.account_tree_rounded)];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = i == _tabIndex;
          return GestureDetector(
            onTap: () => setState(() => _tabIndex = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: isActive ? null : Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Icon(tabs[i].$2, size: 16, color: isActive ? Colors.white : AppColors.textTertiary),
                  const SizedBox(width: 6),
                  Text(tabs[i].$1, style: AppTextStyles.labelMedium.copyWith(
                    color: isActive ? Colors.white : AppColors.textTertiary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  )),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmployeeList(bool isMobile) {
    final employees = _filteredEmployees;
    if (employees.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.search_off_rounded, size: 48, color: AppColors.textTertiary.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text('Không tìm thấy nhân viên', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary)),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: employees.length,
      itemBuilder: (context, i) => _buildEmployeeCard(employees[i], isMobile),
    );
  }

  Widget _buildEmployeeCard(MockEmployee emp, bool isMobile) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showEmployeeDetail(emp),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                UserAvatar(initials: emp.avatar, size: 44, showStatus: true, isOnline: emp.isActive),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(emp.name, style: AppTextStyles.titleSmall.copyWith(fontSize: 14)),
                      const SizedBox(height: 2),
                      Text(emp.position, style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _infoChip(Icons.business_rounded, emp.department),
                          const SizedBox(width: 6),
                          _infoChip(Icons.badge_outlined, emp.employeeId),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: emp.isActive ? AppColors.successLight : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(emp.isActive ? 'Hoạt động' : 'Nghỉ phép', style: AppTextStyles.labelSmall.copyWith(
                        color: emp.isActive ? AppColors.success : AppColors.textTertiary,
                        fontSize: 10, fontWeight: FontWeight.w600,
                      )),
                    ),
                    const SizedBox(height: 4),
                    Text(emp.joinDate, style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.textTertiary),
          const SizedBox(width: 3),
          Text(label, style: AppTextStyles.labelSmall.copyWith(fontSize: 9)),
        ],
      ),
    );
  }

  Widget _buildOrgChart() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _orgNode('CEO', 'Nguyễn Minh Tuấn', 'NMT', AppColors.primary, [
            _orgNode('CTO', 'Lê Hoàng Cường', 'LHC', AppColors.info, [
              _orgNode('Lead Dev', 'Nguyễn Văn An', 'NVA', AppColors.primaryLight, []),
              _orgNode('Lead QA', 'Vũ Thanh Phong', 'VTP', AppColors.primaryLight, []),
            ]),
            _orgNode('CHRO', 'Trần Thị Bình', 'TTB', AppColors.success, [
              _orgNode('HR Manager', 'Ngô Quốc Hùng', 'NQH', const Color(0xFF10B981), []),
            ]),
            _orgNode('CFO', 'Phạm Minh Đức', 'PMD', AppColors.warning, []),
          ]),
        ],
      ),
    );
  }

  Widget _orgNode(String title, String name, String avatar, Color color, List<Widget> children) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 8)],
          ),
          child: Column(
            children: [
              UserAvatar(initials: avatar, size: 36, backgroundColor: color.withValues(alpha: 0.15)),
              const SizedBox(height: 6),
              Text(name, style: AppTextStyles.titleSmall.copyWith(fontSize: 12)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(title, style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.w600, fontSize: 9)),
              ),
            ],
          ),
        ),
        if (children.isNotEmpty) ...[
          Container(width: 2, height: 20, color: AppColors.divider),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: children,
          ),
        ],
      ],
    );
  }

  void _showEmployeeDetail(MockEmployee emp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          child: Column(
            children: [
              Container(margin: const EdgeInsets.only(top: 10), width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      UserAvatar(initials: emp.avatar, size: 64),
                      const SizedBox(height: 12),
                      Text(emp.name, style: AppTextStyles.headlineMedium.copyWith(fontSize: 20)),
                      Text(emp.position, style: AppTextStyles.bodySmall),
                      const SizedBox(height: 16),
                      _detailRow('Mã NV', emp.employeeId),
                      _detailRow('Phòng ban', emp.department),
                      _detailRow('Email', emp.email),
                      _detailRow('Điện thoại', emp.phone),
                      _detailRow('Ngày vào', emp.joinDate),
                      _detailRow('Hợp đồng', emp.contractType),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(child: _actionBtn(Icons.email_rounded, 'Email', AppColors.primary)),
                        const SizedBox(width: 8),
                        Expanded(child: _actionBtn(Icons.chat_rounded, 'Chat', AppColors.info)),
                        const SizedBox(width: 8),
                        Expanded(child: _actionBtn(Icons.edit_rounded, 'Sửa', AppColors.warning)),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        SizedBox(width: 90, child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary))),
        Expanded(child: Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500))),
      ]),
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: color, fontSize: 10)),
      ]),
    );
  }
}
