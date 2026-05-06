import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/project_data.dart';
import 'task_card.dart';

/// ============================================================================
/// KANBAN BOARD - Bảng Kanban với 4 cột trạng thái
/// ============================================================================
class KanbanBoard extends StatelessWidget {
  final List<MockTask> tasks;
  final ValueChanged<MockTask>? onTaskTap;

  const KanbanBoard({super.key, required this.tasks, this.onTaskTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildColumn('Cần làm', TaskStatus.todo, AppColors.kanbanTodo, Icons.radio_button_unchecked_rounded),
          const SizedBox(width: 14),
          _buildColumn('Đang làm', TaskStatus.inProgress, AppColors.kanbanInProgress, Icons.play_circle_outline_rounded),
          const SizedBox(width: 14),
          _buildColumn('Đánh giá', TaskStatus.review, AppColors.kanbanReview, Icons.rate_review_outlined),
          const SizedBox(width: 14),
          _buildColumn('Hoàn thành', TaskStatus.done, AppColors.kanbanDone, Icons.check_circle_outline_rounded),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, TaskStatus status, Color color, IconData icon) {
    final columnTasks = tasks.where((t) => t.status == status).toList();
    return Container(
      width: 300,
      constraints: const BoxConstraints(minHeight: 500),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Text(title, style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('${columnTasks.length}', style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.w700, fontSize: 11)),
                ),
              ],
            ),
          ),
          // Divider colored
          Container(height: 2, margin: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: color.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(1))),
          // Task cards
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: columnTasks.map((task) =>
                TaskCard(task: task, onTap: () => onTaskTap?.call(task)),
              ).toList(),
            ),
          ),
          // Add task button
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text('Thêm công việc', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
