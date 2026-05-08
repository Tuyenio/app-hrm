import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/interactive_overlays.dart';
import '../widgets/kpi_cards_row.dart';
import '../widgets/project_rag_list.dart';
import '../widgets/workload_heatmap.dart';
import '../widgets/revenue_chart.dart';

/// ============================================================================
/// DASHBOARD SCREEN - Executive BI Dashboard
/// Mobile-first: Cuộn dọc single-column trên mobile, 2-column trên desktop.
/// UPDATED: StatefulWidget cho interactive filters.
/// ============================================================================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context, isMobile)),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
            sliver: const SliverToBoxAdapter(child: KpiCardsRow()),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
            sliver: SliverToBoxAdapter(
              child: isMobile
                  ? Column(children: const [
                      RevenueChart(),
                      SizedBox(height: 16),
                      TaskCompletionChart(),
                    ])
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(child: RevenueChart()),
                        SizedBox(width: 16),
                        Expanded(child: TaskCompletionChart()),
                      ],
                    ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
            sliver: SliverToBoxAdapter(
              child: isMobile
                  ? Column(children: const [
                      ProjectRagList(),
                      SizedBox(height: 16),
                      WorkloadHeatmap(),
                    ])
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(flex: 3, child: ProjectRagList()),
                        SizedBox(width: 16),
                        Expanded(flex: 4, child: WorkloadHeatmap()),
                      ],
                    ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      margin: EdgeInsets.fromLTRB(isMobile ? 16 : 24, 16, isMobile ? 16 : 24, 0),
      padding: EdgeInsets.fromLTRB(isMobile ? 18 : 24, 18, isMobile ? 18 : 24, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F4C81), Color(0xFF1A5C9E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isMobile
          ? Stack(
              children: [
                Positioned(
                  right: -18,
                  top: -18,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.dashboard_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dashboard Tổng Quan',
                                style: AppTextStyles.headlineLarge.copyWith(fontSize: 22, color: Colors.white),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Theo dõi vận hành theo thời gian thực',
                                style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        _buildIconButton(
                          context,
                          Icons.notifications_outlined,
                          badge: '5',
                          light: true,
                          onTap: () => showNotificationCenter(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSoftInfoPill('Thứ Ba, 06/05/2026', Icons.schedule_rounded),
                        ),
                        const SizedBox(width: 8),
                        _buildActionIconButton(
                          Icons.filter_list_rounded,
                          onTap: () => _showDashboardFilter(context),
                        ),
                        const SizedBox(width: 8),
                        _buildActionIconButton(
                          Icons.download_rounded,
                          onTap: () => showExportDialog(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.dashboard_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dashboard Tổng Quan', style: AppTextStyles.headlineLarge.copyWith(color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Xin chào, Admin • Thứ Ba, 06/05/2026', style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
                _buildIconButton(context, Icons.notifications_outlined, badge: '5', light: true, onTap: () => showNotificationCenter(context)),
                const SizedBox(width: 8),
                _buildIconButton(context, Icons.filter_list_rounded, light: true, onTap: () => _showDashboardFilter(context)),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => showExportDialog(context),
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text('Xuất báo cáo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildIconButton(
    BuildContext context,
    IconData icon, {
    String? badge,
    required VoidCallback onTap,
    bool light = false,
  }) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: light ? Colors.white.withValues(alpha: 0.15) : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: light
                  ? Colors.white.withValues(alpha: 0.14)
                  : AppColors.borderLight,
            ),
          ),
          child: IconButton(
            onPressed: onTap,
            icon: Icon(
              icon,
              size: 20,
              color: light ? Colors.white : AppColors.textSecondary,
            ),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ),
        if (badge != null)
          Positioned(
            right: 2, top: 2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
              child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
            ),
          ),
      ],
    );
  }

  Widget _buildSoftInfoPill(String label, IconData icon) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white70),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIconButton(
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: Colors.white),
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(minWidth: 42, minHeight: 42),
        tooltip: icon == Icons.download_rounded ? 'Xuất báo cáo' : 'Bộ lọc',
      ),
    );
  }

  /// Dashboard filter bottom sheet - NOW FULLY INTERACTIVE
  void _showDashboardFilter(BuildContext context) {
    // State managed outside StatefulBuilder so it persists
    String selectedTime = 'Hôm nay';
    String selectedDept = 'Tất cả';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 12),
                Text('Bộ lọc Dashboard', style: AppTextStyles.headlineSmall.copyWith(fontSize: 18)),
                const SizedBox(height: 16),
                Text('Khoảng thời gian', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final label in ['Hôm nay', 'Tuần này', 'Tháng này', 'Quý này', 'Tùy chỉnh'])
                    _interactiveFilterChip(
                      label,
                      label == selectedTime,
                      () => setModalState(() => selectedTime = label),
                    ),
                ]),
                const SizedBox(height: 16),
                Text('Phòng ban', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final label in ['Tất cả', 'IT', 'HR', 'Sales', 'Design'])
                    _interactiveFilterChip(
                      label,
                      label == selectedDept,
                      () => setModalState(() => selectedDept = label),
                    ),
                ]),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: OutlinedButton(
                    onPressed: () {
                      setModalState(() {
                        selectedTime = 'Hôm nay';
                        selectedDept = 'Tất cả';
                      });
                    },
                    child: const Text('Đặt lại'),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(
                    onPressed: () { Navigator.pop(ctx); showHrmSuccessSnackbar(context, 'Đã áp dụng: $selectedTime • $selectedDept'); },
                    child: const Text('Áp dụng'),
                  )),
                ]),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Interactive filter chip with tap feedback
  Widget _interactiveFilterChip(String label, bool selected, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: AppColors.primary.withValues(alpha: 0.15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(20),
            border: selected ? null : Border.all(color: AppColors.borderLight),
          ),
          child: Text(label, style: AppTextStyles.labelMedium.copyWith(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400, fontSize: 12,
          )),
        ),
      ),
    );
  }
}
