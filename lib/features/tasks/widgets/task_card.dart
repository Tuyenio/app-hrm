import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../data/mock/project_data.dart';

/// ============================================================================
/// TASK CARD - Card công việc trong Kanban Board
/// Thiết kế premium với priority indicator, avatar, progress bar.
/// UPDATED: StatefulWidget với checkbox animation + InkWell ripple.
/// ============================================================================
class TaskCard extends StatefulWidget {
  final MockTask task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> with SingleTickerProviderStateMixin {
  bool _isChecked = false;
  late AnimationController _checkAnimController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.task.status == TaskStatus.done;
    _checkAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkAnimController, curve: Curves.elasticOut),
    );
    if (_isChecked) _checkAnimController.value = 1.0;
  }

  @override
  void dispose() {
    _checkAnimController.dispose();
    super.dispose();
  }

  Color get _priorityColor {
    switch (widget.task.priority) {
      case TaskPriority.critical: return AppColors.priorityCritical;
      case TaskPriority.high: return AppColors.priorityHigh;
      case TaskPriority.medium: return AppColors.priorityMedium;
      case TaskPriority.low: return AppColors.priorityLow;
    }
  }

  void _toggleCheck() {
    setState(() => _isChecked = !_isChecked);
    if (_isChecked) {
      _checkAnimController.forward(from: 0);
    } else {
      _checkAnimController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        highlightColor: AppColors.primary.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: _isChecked
                ? AppColors.successLight.withValues(alpha: 0.3)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isChecked
                  ? AppColors.success.withValues(alpha: 0.4)
                  : AppColors.borderLight,
            ),
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
                // Checkbox area
                GestureDetector(
                  onTap: _toggleCheck,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 14, 4, 14),
                    child: AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: _isChecked
                                ? AppColors.success
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _isChecked
                                  ? AppColors.success
                                  : AppColors.border,
                              width: 1.5,
                            ),
                          ),
                          child: _isChecked
                              ? Transform.scale(
                                  scale: _scaleAnimation.value,
                                  child: const Icon(
                                    Icons.check_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                ),
                // Card content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 14, 14, 14),
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
                        Text(
                          task.title,
                          style: AppTextStyles.titleSmall.copyWith(
                            decoration: _isChecked ? TextDecoration.lineThrough : null,
                            color: _isChecked ? AppColors.textTertiary : AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),

                        // Progress bar
                        if (task.progress > 0) ...[
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: LinearProgressIndicator(
                                    value: _isChecked ? 1.0 : task.progress,
                                    backgroundColor: AppColors.surfaceVariant,
                                    valueColor: AlwaysStoppedAnimation(
                                      _isChecked
                                          ? AppColors.success
                                          : _priorityColor.withValues(alpha: 0.7),
                                    ),
                                    minHeight: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isChecked ? '100%' : '${(task.progress * 100).toInt()}%',
                                style: AppTextStyles.labelSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: _isChecked ? AppColors.success : null,
                                ),
                              ),
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
                                color: task.isOverdue && !_isChecked ? AppColors.errorLight : AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.calendar_today_rounded, size: 10,
                                    color: task.isOverdue && !_isChecked ? AppColors.error : AppColors.textTertiary),
                                  const SizedBox(width: 3),
                                  Text(task.dueDate, style: AppTextStyles.labelSmall.copyWith(
                                    color: task.isOverdue && !_isChecked ? AppColors.error : AppColors.textTertiary,
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
      ),
    );
  }
}
