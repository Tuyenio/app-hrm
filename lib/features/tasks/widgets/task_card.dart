import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../data/mock/project_data.dart';

/// ============================================================================
/// TASK CARD - Card công việc trong Kanban Board
/// Thiết kế premium với priority indicator, avatar, progress bar.
/// ============================================================================
class TaskCard extends StatelessWidget {
  final MockTask task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  Color get _priorityColor {
    switch (task.priority) {
      case TaskPriority.critical: return AppColors.priorityCritical;
      case TaskPriority.high: return AppColors.priorityHigh;
      case TaskPriority.medium: return AppColors.priorityMedium;
      case TaskPriority.low: return AppColors.priorityLow;
    }
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Priority indicator bar (left edge)
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: _priorityColor,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                ),
              ),
              // Card content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tags row
                      if (task.tags.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: task.tags.map((tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(tag, style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary, fontSize: 9)),
                          )).toList(),
                        ),
                      if (task.tags.isNotEmpty) const SizedBox(height: 8),

                      // Title
                      Text(task.title, style: AppTextStyles.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 10),

                      // Progress bar
                      if (task.progress > 0) ...[
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: task.progress,
                                  backgroundColor: AppColors.surfaceVariant,
                                  valueColor: AlwaysStoppedAnimation(_priorityColor.withValues(alpha: 0.7)),
                                  minHeight: 4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${(task.progress * 100).toInt()}%', style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w600, fontSize: 10)),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],

                      // Bottom row: assignee, due date, subtasks, comments
                      Row(
                        children: [
                          UserAvatar(initials: task.assigneeAvatar, size: 24),
                          const SizedBox(width: 8),
                          // Due date badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: task.isOverdue ? AppColors.errorLight : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.calendar_today_rounded, size: 10,
                                  color: task.isOverdue ? AppColors.error : AppColors.textTertiary),
                                const SizedBox(width: 3),
                                Text(task.dueDate, style: AppTextStyles.labelSmall.copyWith(
                                  color: task.isOverdue ? AppColors.error : AppColors.textTertiary,
                                  fontSize: 9, fontWeight: task.isOverdue ? FontWeight.w600 : FontWeight.w500,
                                )),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Subtasks
                          Icon(Icons.check_box_outlined, size: 12, color: AppColors.textTertiary),
                          const SizedBox(width: 2),
                          Text('${task.subtasksDone}/${task.subtasksTotal}', style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
                          const SizedBox(width: 8),
                          // Comments
                          Icon(Icons.chat_bubble_outline_rounded, size: 12, color: AppColors.textTertiary),
                          const SizedBox(width: 2),
                          Text('${task.comments}', style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
                        ],
                      ),
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
}
