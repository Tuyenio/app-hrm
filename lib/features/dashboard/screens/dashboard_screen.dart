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
/// ============================================================================
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ─────────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildHeader(context, isMobile)),
          // ── KPI Cards ───────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
            sliver: const SliverToBoxAdapter(child: KpiCardsRow()),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          // ── Charts ──────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
            sliver: SliverToBoxAdapter(
              child: isMobile
                  ? Column(children: [
                      const RevenueChart(),
                      const SizedBox(height: 16),
                      const TaskCompletionChart(),
                    ])
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(child: RevenueChart()),
                        const SizedBox(width: 16),
                        const Expanded(child: TaskCompletionChart()),
                      ],
                    ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          // ── RAG List + Heatmap ──────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
            sliver: SliverToBoxAdapter(
              child: isMobile
                  ? Column(children: [
                      const ProjectRagList(),
                      const SizedBox(height: 16),
                      const WorkloadHeatmap(),
                    ])
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(flex: 3, child: ProjectRagList()),
                        const SizedBox(width: 16),
                        const Expanded(flex: 4, child: WorkloadHeatmap()),
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
      padding: EdgeInsets.fromLTRB(isMobile ? 16 : 24, 16, isMobile ? 16 : 24, 16),
      child: isMobile
          // ── MOBILE HEADER ──────────────────────────────────────
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dashboard', style: AppTextStyles.headlineLarge.copyWith(fontSize: 22)),
                          const SizedBox(height: 2),
                          Text('Thứ Ba, 06/05/2026', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    _buildIconButton(context, Icons.notifications_outlined, badge: '5', onTap: () => showNotificationCenter(context)),
                  ],
                ),
              ],
            )
          // ── DESKTOP HEADER ─────────────────────────────────────
          : Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dashboard Tổng Quan', style: AppTextStyles.headlineLarge),
                      const SizedBox(height: 4),
                      Text('Xin chào, Admin • Thứ Ba, 06/05/2026', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                _buildIconButton(context, Icons.notifications_outlined, badge: '5', onTap: () => showNotificationCenter(context)),
                const SizedBox(width: 8),
                _buildIconButton(context, Icons.filter_list_rounded, onTap: () => _showDashboardFilter(context)),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => showExportDialog(context),
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text('Xuất báo cáo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, {String? badge, required VoidCallback onTap}) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: IconButton(
            onPressed: onTap,
            icon: Icon(icon, size: 20, color: AppColors.textSecondary),
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

  void _showDashboardFilter(BuildContext context) {
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
                  _filterChip('Hôm nay', true), _filterChip('Tuần này', false),
                  _filterChip('Tháng này', false), _filterChip('Quý này', false),
                  _filterChip('Tùy chỉnh', false),
                ]),
                const SizedBox(height: 16),
                Text('Phòng ban', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  _filterChip('Tất cả', true), _filterChip('IT', false),
                  _filterChip('HR', false), _filterChip('Sales', false),
                  _filterChip('Design', false),
                ]),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Đặt lại'))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(
                    onPressed: () { Navigator.pop(ctx); showHrmSuccessSnackbar(context, 'Đã áp dụng bộ lọc'); },
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

  Widget _filterChip(String label, bool selected) {
    return Container(
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
    );
  }
}
