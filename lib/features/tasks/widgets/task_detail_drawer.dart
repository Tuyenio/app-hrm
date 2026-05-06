import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../data/mock/project_data.dart';

/// ============================================================================
/// TASK DETAIL DRAWER - Slide-out panel chi tiết công việc
/// ============================================================================
class TaskDetailDrawer extends StatelessWidget {
  final MockTask task;
  final VoidCallback onClose;

  const TaskDetailDrawer({super.key, required this.task, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      width: isMobile ? null : 400,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: isMobile ? null : Border(left: BorderSide(color: AppColors.divider)),
        boxShadow: isMobile ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(-4, 0))],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
            child: Row(
              children: [
                Expanded(child: Text('Chi tiết công việc', style: AppTextStyles.headlineSmall.copyWith(fontSize: 16))),
                IconButton(icon: const Icon(Icons.close_rounded, size: 20), onPressed: onClose),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Priority
                  Text(task.title, style: AppTextStyles.headlineMedium.copyWith(fontSize: 18)),
                  const SizedBox(height: 12),
                  // Status & Priority badges
                  Row(
                    children: [
                      _statusChip(task.status),
                      const SizedBox(width: 8),
                      _priorityChip(task.priority),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Description
                  Text('Mô tả', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Text(task.description, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Assignee
                  _infoRow(Icons.person_outline_rounded, 'Phụ trách', task.assignee),
                  _infoRow(Icons.calendar_today_rounded, 'Hạn chót', task.dueDate),
                  _infoRow(Icons.folder_outlined, 'Dự án', task.projectId == 'p1' ? 'ERP Migration Phase 2' : 'Mobile App v3.0'),
                  const SizedBox(height: 20),
                  // Progress
                  Text('Tiến độ', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(value: task.progress, backgroundColor: AppColors.surfaceVariant, valueColor: const AlwaysStoppedAnimation(AppColors.primaryLight), minHeight: 8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('${(task.progress * 100).toInt()}%', style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Sub-tasks
                  Text('Việc con (${task.subtasksDone}/${task.subtasksTotal})', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  ...List.generate(task.subtasksTotal, (i) => _subtaskRow(i < task.subtasksDone, 'Subtask ${i + 1}: ${_subtaskNames[i % _subtaskNames.length]}')),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Timesheet
                  Text('Thời gian đã log', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  _timesheetRow('Hôm nay', '2h 30m'),
                  _timesheetRow('Hôm qua', '4h 15m'),
                  _timesheetRow('04/05/2026', '3h 00m'),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tổng cộng', style: AppTextStyles.titleSmall),
                        Text('9h 45m', style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Comments
                  Text('Thảo luận (${task.comments})', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  _commentBubble('Nguyễn Văn An', 'Mọi người review giúp mình PR này nhé', '09:30'),
                  _commentBubble('Trần Thị Bình', 'OK anh, để em xem', '09:35'),
                  _commentBubble('Phạm Minh Đức', 'Đã approve ✅', '10:00'),
                ],
              ),
            ),
          ),
          // Bottom action bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Viết bình luận...',
                      hintStyle: AppTextStyles.bodySmall,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.borderLight)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      suffixIcon: Icon(Icons.attach_file_rounded, size: 18, color: AppColors.textTertiary),
                    ),
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                  child: IconButton(icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18), onPressed: () {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const _subtaskNames = ['Phân tích yêu cầu', 'Thiết kế giải pháp', 'Implement code', 'Viết unit test', 'Code review', 'Fix bugs', 'Deploy staging', 'UAT testing', 'Cập nhật docs', 'Demo cho team'];

  Widget _subtaskRow(bool done, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(done ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, size: 20, color: done ? AppColors.success : AppColors.textTertiary),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: AppTextStyles.bodySmall.copyWith(
            decoration: done ? TextDecoration.lineThrough : null,
            color: done ? AppColors.textTertiary : AppColors.textPrimary,
          ))),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textTertiary),
          const SizedBox(width: 10),
          SizedBox(width: 70, child: Text(label, style: AppTextStyles.bodySmall)),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _timesheetRow(String date, String hours) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date, style: AppTextStyles.bodySmall),
          Text(hours, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _commentBubble(String author, String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(initials: author.split(' ').map((w) => w[0]).take(2).join(), size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(author, style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(width: 8),
                    Text(time, style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)),
                  child: Text(text, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(TaskStatus status) {
    final colors = {TaskStatus.todo: AppColors.kanbanTodo, TaskStatus.inProgress: AppColors.kanbanInProgress, TaskStatus.review: AppColors.kanbanReview, TaskStatus.done: AppColors.kanbanDone};
    final labels = {TaskStatus.todo: 'Cần làm', TaskStatus.inProgress: 'Đang làm', TaskStatus.review: 'Đánh giá', TaskStatus.done: 'Hoàn thành'};
    final c = colors[status]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
      child: Text(labels[status]!, style: AppTextStyles.labelSmall.copyWith(color: c, fontWeight: FontWeight.w600, fontSize: 11)),
    );
  }

  Widget _priorityChip(TaskPriority priority) {
    final colors = {TaskPriority.critical: AppColors.priorityCritical, TaskPriority.high: AppColors.priorityHigh, TaskPriority.medium: AppColors.priorityMedium, TaskPriority.low: AppColors.priorityLow};
    final labels = {TaskPriority.critical: 'Khẩn cấp', TaskPriority.high: 'Cao', TaskPriority.medium: 'Trung bình', TaskPriority.low: 'Thấp'};
    final c = colors[priority]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
      child: Text(labels[priority]!, style: AppTextStyles.labelSmall.copyWith(color: c, fontWeight: FontWeight.w600, fontSize: 11)),
    );
  }
}
