import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
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
          SliverToBoxAdapter(child: _buildHeader(isMobile)),
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

  Widget _buildHeader(bool isMobile) {
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
                    _buildIconButton(Icons.notifications_outlined, badge: '5'),
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
                _buildIconButton(Icons.notifications_outlined, badge: '5'),
                const SizedBox(width: 8),
                _buildIconButton(Icons.filter_list_rounded),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {},
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

  Widget _buildIconButton(IconData icon, {String? badge}) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: IconButton(
            onPressed: () {},
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
}
