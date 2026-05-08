import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../core/widgets/interactive_overlays.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/mock/employee_data.dart';

/// ============================================================================
/// DEPARTMENT MANAGEMENT SCREEN
/// Quản lý phòng ban - Responsive grid with KPI tracking.
/// ============================================================================
class DepartmentManagementScreen extends StatefulWidget {
  const DepartmentManagementScreen({super.key});

  @override
  State<DepartmentManagementScreen> createState() =>
      _DepartmentManagementScreenState();
}

class _DepartmentManagementScreenState
    extends State<DepartmentManagementScreen> {
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'Tất cả';

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  static final List<_DepartmentInfo> _departments = [
    _DepartmentInfo(
      name: 'Phòng IT', managerName: 'Lê Hoàng Cường', managerAvatar: 'LHC',
      headcount: 42, kpiCompletion: 0.85, tasksCompleted: 102, totalTasks: 120,
      icon: Icons.computer_rounded, color: AppColors.primaryLight, budget: '₫2.5 Tỷ',
    ),
    _DepartmentInfo(
      name: 'Phòng HR', managerName: 'Ngô Quốc Hùng', managerAvatar: 'NQH',
      headcount: 15, kpiCompletion: 0.91, tasksCompleted: 41, totalTasks: 45,
      icon: Icons.people_rounded, color: AppColors.success, budget: '₫800 Tr',
    ),
    _DepartmentInfo(
      name: 'Phòng Sales', managerName: 'Hoàng Thu Em', managerAvatar: 'HTE',
      headcount: 38, kpiCompletion: 0.72, tasksCompleted: 61, totalTasks: 85,
      icon: Icons.trending_up_rounded, color: AppColors.warning, budget: '₫1.8 Tỷ',
    ),
    _DepartmentInfo(
      name: 'Phòng Design', managerName: 'Đỗ Mai Hương', managerAvatar: 'DMH',
      headcount: 12, kpiCompletion: 0.68, tasksCompleted: 41, totalTasks: 60,
      icon: Icons.palette_rounded, color: const Color(0xFF8B5CF6), budget: '₫600 Tr',
    ),
    _DepartmentInfo(
      name: 'Phòng DevOps', managerName: 'Phạm Minh Đức', managerAvatar: 'PMD',
      headcount: 8, kpiCompletion: 0.78, tasksCompleted: 43, totalTasks: 55,
      icon: Icons.cloud_rounded, color: const Color(0xFFEC4899), budget: '₫1.2 Tỷ',
    ),
    _DepartmentInfo(
      name: 'Phòng Marketing', managerName: 'Bùi Đức Trọng', managerAvatar: 'BĐT',
      headcount: 20, kpiCompletion: 0.82, tasksCompleted: 57, totalTasks: 70,
      icon: Icons.campaign_rounded, color: AppColors.info, budget: '₫1.5 Tỷ',
    ),
  ];

  List<_DepartmentInfo> get _filteredDepartments {
    var list = _departments.toList();
    if (_searchQuery.isNotEmpty) {
      list = list.where((d) =>
        d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        d.managerName.toLowerCase().contains(_searchQuery.toLowerCase()),
      ).toList();
    }
    if (_selectedFilter == 'KPI > 80%') {
      list = list.where((d) => d.kpiCompletion >= 0.8).toList();
    } else if (_selectedFilter == 'KPI < 80%') {
      list = list.where((d) => d.kpiCompletion < 0.8).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildMobileHeader(context, isMobile),
            const SizedBox(height: 12),
            // Filter chips row
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
                children: [
                  for (final f in ['Tất cả', 'KPI > 80%', 'KPI < 80%'])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _filterChip(f),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Grid content
            Expanded(child: _buildContent(isMobile)),
          ],
        ),
      ),
    );
  }

  /// Clean compact header matching TaskWorkspaceScreen style
  Widget _buildMobileHeader(BuildContext context, bool isMobile) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.fromLTRB(isMobile ? 16 : 24, 8, isMobile ? 16 : 24, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: isDark ? const Color(0xFF30363D) : AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Expanded(
                child: Text(
                  'Quản lý Phòng ban',
                  style: AppTextStyles.headlineLarge.copyWith(fontSize: 20),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF21262D) : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () => _showSearchSheet(context),
                  icon: const Icon(Icons.search_rounded, size: 18),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () => _showAddDepartmentSheet(context),
                  icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Summary stats
          Row(
            children: [
              Text(
                '${_departments.length} phòng ban',
                style: AppTextStyles.bodySmall,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 3, height: 3,
                decoration: BoxDecoration(color: AppColors.textTertiary, shape: BoxShape.circle),
              ),
              Text(
                '${_departments.fold(0, (sum, d) => sum + d.headcount)} nhân sự',
                style: AppTextStyles.bodySmall,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 3, height: 3,
                decoration: BoxDecoration(color: AppColors.textTertiary, shape: BoxShape.circle),
              ),
              Text(
                'KPI TB: ${(_departments.fold(0.0, (sum, d) => sum + d.kpiCompletion) / _departments.length * 100).toInt()}%',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // Search query indicator
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search_rounded, size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text('"$_searchQuery"', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary, fontSize: 11)),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => setState(() => _searchQuery = ''),
                    child: const Icon(Icons.close_rounded, size: 14, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final isSelected = label == _selectedFilter;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : (isDark ? const Color(0xFF30363D) : AppColors.borderLight),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? Colors.white : (isDark ? const Color(0xFF8B949E) : AppColors.textSecondary),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isMobile) {
    if (_isLoading) {
      return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 2 : 3,
          mainAxisSpacing: 12, crossAxisSpacing: 12,
          childAspectRatio: isMobile ? 0.78 : 0.95,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => const ShimmerCard(),
      );
    }

    final filtered = _filteredDepartments;
    if (filtered.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.business_rounded,
        title: 'Không tìm thấy phòng ban',
        subtitle: 'Thay đổi bộ lọc hoặc từ khóa tìm kiếm',
        onAction: () => setState(() {
          _searchQuery = '';
          _selectedFilter = 'Tất cả';
        }),
        actionLabel: 'Đặt lại',
      );
    }

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 24, 0, isMobile ? 16 : 24, 32,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 3,
        mainAxisSpacing: 12, crossAxisSpacing: 12,
        childAspectRatio: isMobile ? 0.78 : 0.95,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, i) => _buildDepartmentCard(filtered[i], isMobile),
    );
  }

  Widget _buildDepartmentCard(_DepartmentInfo dept, bool isMobile) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final kpiColor = dept.kpiCompletion >= 0.8
        ? AppColors.success
        : dept.kpiCompletion >= 0.6 ? AppColors.warning : AppColors.error;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showDepartmentDetail(dept),
        borderRadius: BorderRadius.circular(16),
        splashColor: dept.color.withValues(alpha: 0.1),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 14 : 18),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? const Color(0xFF30363D) : AppColors.borderLight),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon + Name
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: dept.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(dept.icon, color: dept.color, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(dept.name, style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w700, fontSize: isMobile ? 12 : 14), maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height: 12),
              // Manager
              Row(children: [
                UserAvatar(initials: dept.managerAvatar, size: 22),
                const SizedBox(width: 6),
                Expanded(child: Text(dept.managerName, style: AppTextStyles.bodySmall.copyWith(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height: 10),
              // Headcount
              Row(children: [
                Icon(Icons.group_rounded, size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text('${dept.headcount} nhân sự', style: AppTextStyles.labelSmall.copyWith(fontSize: 10, color: AppColors.textSecondary)),
              ]),
              const Spacer(),
              // KPI
              Row(children: [
                Text('KPI', style: AppTextStyles.labelSmall.copyWith(fontSize: 10, color: AppColors.textTertiary)),
                const Spacer(),
                Text('${(dept.kpiCompletion * 100).toInt()}%', style: AppTextStyles.labelSmall.copyWith(fontSize: 11, fontWeight: FontWeight.w700, color: kpiColor)),
              ]),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: dept.kpiCompletion, backgroundColor: AppColors.surfaceVariant, valueColor: AlwaysStoppedAnimation(kpiColor), minHeight: 6),
              ),
              const SizedBox(height: 4),
              Text('${dept.tasksCompleted}/${dept.totalTasks} tasks', style: AppTextStyles.labelSmall.copyWith(fontSize: 9, color: AppColors.textTertiary)),
            ],
          ),
        ),
      ),
    );
  }

  // ── Search Sheet ──────────────────────────────────────────────────────────
  void _showSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Tìm phòng ban hoặc trưởng phòng...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: () {
                    setState(() => _searchQuery = '');
                    Navigator.pop(ctx);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tìm kiếm'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Add Department Sheet ──────────────────────────────────────────────────
  void _showAddDepartmentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 12),
              Text('Thêm phòng ban mới', style: AppTextStyles.headlineSmall.copyWith(fontSize: 18)),
              const SizedBox(height: 16),
              Text('Tên phòng ban *', style: AppTextStyles.labelLarge),
              const SizedBox(height: 6),
              const TextField(decoration: InputDecoration(hintText: 'VD: Phòng Kế toán')),
              const SizedBox(height: 14),
              Text('Trưởng phòng', style: AppTextStyles.labelLarge),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderLight)),
                child: DropdownButtonHideUnderline(child: DropdownButton<String>(
                  isExpanded: true, value: null, hint: const Text('Chọn trưởng phòng'),
                  items: mockEmployeeList.take(6).map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                  onChanged: (_) {},
                )),
              ),
              const SizedBox(height: 14),
              Text('Mô tả', style: AppTextStyles.labelLarge),
              const SizedBox(height: 6),
              const TextField(maxLines: 2, decoration: InputDecoration(hintText: 'Mô tả chức năng phòng ban...')),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy'))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(
                  onPressed: () { Navigator.pop(ctx); showHrmSuccessSnackbar(context, 'Đã tạo phòng ban mới'); },
                  child: const Text('Tạo phòng ban'),
                )),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  // ── Department Detail ─────────────────────────────────────────────────────
  void _showDepartmentDetail(_DepartmentInfo dept) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, sc) => Container(
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
          child: Column(
            children: [
              Center(child: Container(margin: const EdgeInsets.only(top: 10), width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: dept.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                    child: Icon(dept.icon, color: dept.color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(dept.name, style: AppTextStyles.headlineSmall),
                    Text('${dept.headcount} nhân sự • ${dept.budget}', style: AppTextStyles.bodySmall),
                  ])),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                ]),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  controller: sc,
                  padding: const EdgeInsets.all(20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // KPI Overview
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [dept.color.withValues(alpha: 0.08), dept.color.withValues(alpha: 0.02)]),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: dept.color.withValues(alpha: 0.2)),
                      ),
                      child: Column(children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('Hiệu suất KPI', style: AppTextStyles.titleSmall),
                          Text('${(dept.kpiCompletion * 100).toInt()}%', style: AppTextStyles.headlineMedium.copyWith(color: dept.color)),
                        ]),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(value: dept.kpiCompletion, backgroundColor: AppColors.surfaceVariant, valueColor: AlwaysStoppedAnimation(dept.color), minHeight: 10),
                        ),
                        const SizedBox(height: 8),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('${dept.tasksCompleted}/${dept.totalTasks} tasks hoàn thành', style: AppTextStyles.bodySmall),
                          Text(dept.budget, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                        ]),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    // Manager
                    Text('Trưởng phòng', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.surfaceVariant.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
                      child: Row(children: [
                        UserAvatar(initials: dept.managerAvatar, size: 40),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(dept.managerName, style: AppTextStyles.titleSmall),
                          Text('Trưởng phòng ${dept.name}', style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
                        ])),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(6)),
                          child: Text('Active', style: AppTextStyles.labelSmall.copyWith(color: AppColors.success, fontWeight: FontWeight.w600, fontSize: 10)),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    // Team members
                    Text('Thành viên', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    ...mockEmployeeList.take(4).map((emp) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(children: [
                        UserAvatar(initials: emp.avatar, size: 30),
                        const SizedBox(width: 10),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(emp.name, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          Text(emp.position, style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
                        ])),
                      ]),
                    )),
                    if (dept.headcount > 4)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('+ ${dept.headcount - 4} thành viên khác', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w500)),
                      ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DepartmentInfo {
  final String name, managerName, managerAvatar, budget;
  final int headcount, tasksCompleted, totalTasks;
  final double kpiCompletion;
  final IconData icon;
  final Color color;

  const _DepartmentInfo({
    required this.name, required this.managerName, required this.managerAvatar,
    required this.headcount, required this.kpiCompletion, required this.tasksCompleted,
    required this.totalTasks, required this.icon, required this.color, required this.budget,
  });
}
