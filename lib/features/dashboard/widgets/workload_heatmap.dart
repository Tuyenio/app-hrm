import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/dashboard_data.dart';

/// Workload Heatmap - Mobile: horizontal scroll, Desktop: full width
class WorkloadHeatmap extends StatelessWidget {
  const WorkloadHeatmap({super.key});

  Color _getHeatColor(double hours) {
    if (hours <= 35) return AppColors.heatmapLow;
    if (hours <= 40) return const Color(0xFFBBF7D0);
    if (hours <= 44) return AppColors.heatmapMedium;
    if (hours <= 48) return const Color(0xFFFDE68A);
    if (hours <= 52) return AppColors.heatmapHigh;
    return AppColors.heatmapCritical.withValues(alpha: 0.7);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Row(
              children: [
                Icon(Icons.grid_on_rounded, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text('Phân bổ Nguồn lực', style: AppTextStyles.headlineSmall.copyWith(fontSize: 15))),
              ],
            ),
          ),
          if (!isMobile) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _legend('Rảnh', AppColors.heatmapLow),
                  _legend('Bận', AppColors.heatmapMedium),
                  _legend('Quá tải', AppColors.heatmapCritical.withValues(alpha: 0.7)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          // Content - scrollable on mobile
          isMobile
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(width: 500, child: _buildTableContent()),
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildTableContent(),
                ),
        ],
      ),
    );
  }

  Widget _buildTableContent() {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              SizedBox(width: 110, child: Text('Nhân viên', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 11))),
              for (int i = 1; i <= 5; i++)
                Expanded(child: Center(child: Text('T$i', style: AppTextStyles.labelSmall.copyWith(fontSize: 10)))),
              SizedBox(width: 50, child: Center(child: Text('TB', style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w600, fontSize: 10)))),
            ],
          ),
        ),
        const Divider(height: 12),
        ...mockWorkload.map((e) => _buildRow(e)),
      ],
    );
  }

  Widget _buildRow(WorkloadEntry entry) {
    final avg = entry.weeklyHours.reduce((a, b) => a + b) / entry.weeklyHours.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(entry.employeeName, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500, color: AppColors.textPrimary, fontSize: 11), overflow: TextOverflow.ellipsis),
              Text(entry.department, style: AppTextStyles.labelSmall.copyWith(fontSize: 9)),
            ]),
          ),
          for (final h in entry.weeklyHours)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(color: _getHeatColor(h), borderRadius: BorderRadius.circular(5)),
                  child: Center(child: Text('${h.toInt()}h', style: AppTextStyles.labelSmall.copyWith(
                    color: h > 48 ? Colors.white : AppColors.textPrimary, fontSize: 9, fontWeight: FontWeight.w600,
                  ))),
                ),
              ),
            ),
          SizedBox(
            width: 50,
            child: Center(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(color: _getHeatColor(avg), borderRadius: BorderRadius.circular(5)),
              child: Text('${avg.toInt()}h', style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w700, fontSize: 10, color: avg > 48 ? Colors.white : AppColors.textPrimary)),
            )),
          ),
        ],
      ),
    );
  }

  Widget _legend(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}
