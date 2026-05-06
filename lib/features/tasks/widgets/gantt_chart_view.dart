import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/project_data.dart';

/// ============================================================================
/// GANTT CHART VIEW - Sơ đồ Gantt cho timeline dự án
/// Custom-built Gantt chart không dùng package bên ngoài.
/// ============================================================================
class GanttChartView extends StatelessWidget {
  final double rowHeight;
  final double labelWidth;
  final int totalDays;
  final double dayWidth;

  const GanttChartView({
    super.key,
    this.rowHeight = 48,
    this.labelWidth = 160,
    this.totalDays = 30,
    this.dayWidth = 36,
  });

  @override
  Widget build(BuildContext context) {
    final timelineWidth = dayWidth * totalDays;
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
          _buildHeader(timelineWidth),
          const Divider(height: 1),
          // Gantt rows
          ...mockGanttEntries.asMap().entries.map(
            (e) => _buildRow(e.key, e.value, timelineWidth),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double timelineWidth) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Container(
            width: labelWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              'Công việc',
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(width: 1, color: AppColors.divider),
          SizedBox(
            width: timelineWidth,
            child: Row(
              children: List.generate(totalDays, (i) {
                final isWeekend = (i % 7 == 5 || i % 7 == 6);
                return Container(
                  width: dayWidth,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isWeekend
                        ? AppColors.surfaceVariant.withValues(alpha: 0.5)
                        : null,
                    border: Border(
                      right: BorderSide(
                        color: AppColors.divider.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  child: Text(
                    '${i + 1}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isWeekend
                          ? AppColors.textTertiary
                          : AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(int index, GanttEntry entry, double timelineWidth) {
    final color = _parseColor(entry.color);
    final barHeight = 24.0;
    final barTop = (rowHeight - barHeight) / 2;
    return Container(
      height: rowHeight,
      decoration: BoxDecoration(
        color: index.isEven
            ? null
            : AppColors.surfaceVariant.withValues(alpha: 0.2),
        border: Border(
          bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          // Label
          Container(
            width: labelWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.taskName,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        entry.assignee,
                        style: AppTextStyles.labelSmall.copyWith(fontSize: 9),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, color: AppColors.divider),
          // Gantt bar
          SizedBox(
            width: timelineWidth,
            child: Stack(
              children: [
                // Bar background
                Positioned(
                  left: entry.startDay * dayWidth,
                  top: barTop,
                  height: barHeight,
                  width: entry.duration * dayWidth,
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
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: entry.progress > 0.5
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
