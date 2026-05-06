import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/project_data.dart';

/// ============================================================================
/// GANTT CHART VIEW - Sơ đồ Gantt cho timeline dự án
/// Custom-built Gantt chart không dùng package bên ngoài.
/// ============================================================================
class GanttChartView extends StatelessWidget {
  const GanttChartView({super.key});

  static const double _rowHeight = 48;
  static const double _labelWidth = 160;
  static const int _totalDays = 30;

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
          // Header with day numbers
          _buildHeader(),
          const Divider(height: 1),
          // Gantt rows
          ...mockGanttEntries.asMap().entries.map((e) => _buildRow(e.key, e.value)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Container(
            width: _labelWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Text('Công việc', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600)),
          ),
          Container(width: 1, color: AppColors.divider),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _totalDays,
              itemBuilder: (context, i) {
                final isWeekend = (i % 7 == 5 || i % 7 == 6);
                return Container(
                  width: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isWeekend ? AppColors.surfaceVariant.withValues(alpha: 0.5) : null,
                    border: Border(right: BorderSide(color: AppColors.divider.withValues(alpha: 0.3))),
                  ),
                  child: Text('${i + 1}', style: AppTextStyles.labelSmall.copyWith(
                    color: isWeekend ? AppColors.textTertiary : AppColors.textSecondary, fontSize: 10,
                  )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(int index, GanttEntry entry) {
    final color = _parseColor(entry.color);
    return Container(
      height: _rowHeight,
      decoration: BoxDecoration(
        color: index.isEven ? null : AppColors.surfaceVariant.withValues(alpha: 0.2),
        border: Border(bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.3))),
      ),
      child: Row(
        children: [
          // Label
          Container(
            width: _labelWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.taskName, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500, color: AppColors.textPrimary, fontSize: 12), overflow: TextOverflow.ellipsis),
                      Text(entry.assignee, style: AppTextStyles.labelSmall.copyWith(fontSize: 9)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, color: AppColors.divider),
          // Gantt bar
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final dayWidth = constraints.maxWidth / _totalDays;
                final left = entry.startDay * dayWidth;
                final width = entry.duration * dayWidth;
                return Stack(
                  children: [
                    // Bar background
                    Positioned(
                      left: left, top: 12, height: 24,
                      width: width,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: color.withValues(alpha: 0.3)),
                        ),
                        child: Stack(
                          children: [
                            // Progress fill
                            FractionallySizedBox(
                              widthFactor: entry.progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            // Label
                            Center(
                              child: Text(
                                '${(entry.progress * 100).toInt()}%',
                                style: AppTextStyles.labelSmall.copyWith(fontSize: 9, fontWeight: FontWeight.w700, color: entry.progress > 0.5 ? Colors.white : AppColors.textPrimary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 7) buffer.write('FF');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
