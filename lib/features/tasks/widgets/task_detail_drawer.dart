import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../core/widgets/interactive_overlays.dart';
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
    final colors = AppColors.of(context);
    return Container(
      width: isMobile ? null : 400,
      decoration: BoxDecoration(
        color: colors.surface,
        border: isMobile ? null : Border(left: BorderSide(color: colors.divider)),
        boxShadow: isMobile ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(-4, 0))],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colors.divider))),
            child: Row(
              children: [
                Expanded(child: Text('Chi tiết công việc', style: AppTextStyles.headlineSmall.copyWith(fontSize: 16, color: colors.textPrimary))),
                IconButton(
                  icon: Icon(Icons.alarm_add_rounded, size: 20, color: colors.warning),
                  tooltip: 'Nhắc việc',
                  onPressed: () => _showReminderSheet(context),
                ),
                IconButton(
                  icon: Icon(Icons.edit_rounded, size: 20, color: colors.info),
                  tooltip: 'Sửa',
                  onPressed: () => _showEditTaskSheet(context),
                ),
                IconButton(
                  icon: Icon(Icons.delete_rounded, size: 20, color: colors.error),
                  tooltip: 'Xóa',
                  onPressed: () => _showDeleteTaskDialog(context),
                ),
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
                  Text(task.title, style: AppTextStyles.headlineMedium.copyWith(fontSize: 18, color: colors.textPrimary)),
                  const SizedBox(height: 12),
                  // Status & Priority badges
                  Row(
                    children: [
                      _statusChip(context, task.status),
                      const SizedBox(width: 8),
                      _priorityChip(context, task.priority),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Description
                  Text('Mô tả', style: AppTextStyles.titleSmall.copyWith(color: colors.textSecondary)),
                  const SizedBox(height: 6),
                  Text(task.description, style: AppTextStyles.bodyMedium.copyWith(color: colors.textPrimary)),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Assignee
                  _infoRow(context, Icons.person_outline_rounded, 'Phụ trách', task.assignee),
                  _infoRow(context, Icons.supervisor_account_outlined, 'Người giao', task.assignedBy.isEmpty ? 'Chưa xác định' : task.assignedBy),
                  _multiAssigneeRow(context),
                  _infoRow(context, Icons.calendar_today_rounded, 'Hạn chót', task.dueDate),
                  _infoRow(context, Icons.folder_outlined, 'Dự án', task.projectId == 'p1' ? 'ERP Migration Phase 2' : 'Mobile App v3.0'),
                  const SizedBox(height: 20),
                  // Progress
                  Text('Tiến độ', style: AppTextStyles.titleSmall.copyWith(color: colors.textSecondary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(value: task.progress, backgroundColor: colors.surfaceVariant, valueColor: AlwaysStoppedAnimation(colors.primaryLight), minHeight: 8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('${(task.progress * 100).toInt()}%', style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w700, color: colors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Sub-tasks
                  Row(children: [
                    Expanded(child: Text('Việc con (${task.subtasksDone}/${task.subtasksTotal})', style: AppTextStyles.titleSmall.copyWith(color: colors.textSecondary))),
                    InkWell(
                      onTap: () => _showAddSubtaskSheet(context),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: colors.primarySurface, borderRadius: BorderRadius.circular(6)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.add_rounded, size: 14, color: colors.primary),
                          const SizedBox(width: 2),
                          Text('Thêm', style: AppTextStyles.labelSmall.copyWith(color: colors.primary, fontWeight: FontWeight.w600, fontSize: 10)),
                        ]),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  ...List.generate(task.subtasksTotal, (i) => _subtaskRow(context, i < task.subtasksDone, 'Subtask ${i + 1}: ${_subtaskNames[i % _subtaskNames.length]}')),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Timesheet
                  Text('Thời gian đã log', style: AppTextStyles.titleSmall.copyWith(color: AppColors.of(context).textSecondary)),
                  const SizedBox(height: 8),
                  _timesheetRow(context, 'Hôm nay', '2h 30m'),
                  _timesheetRow(context, 'Hôm qua', '4h 15m'),
                  _timesheetRow(context, '04/05/2026', '3h 00m'),
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
                  Text('Thảo luận (${task.comments})', style: AppTextStyles.titleSmall.copyWith(color: AppColors.of(context).textSecondary)),
                  const SizedBox(height: 12),
                  _commentBubble(context, 'Nguyễn Văn An', 'Mọi người review giúp mình PR này nhé', '09:30'),
                  _commentBubble(context, 'Trần Thị Bình', 'OK anh, để em xem', '09:35'),
                  _commentBubble(context, 'Phạm Minh Đức', 'Đã approve ✅', '10:00'),
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
                  child: IconButton(icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18), onPressed: () => showHrmSuccessSnackbar(context, 'Đã gửi bình luận')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const _subtaskNames = ['Phân tích yêu cầu', 'Thiết kế giải pháp', 'Implement code', 'Viết unit test', 'Code review', 'Fix bugs', 'Deploy staging', 'UAT testing', 'Cập nhật docs', 'Demo cho team'];

  Widget _subtaskRow(BuildContext context, bool done, String title) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(done ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, size: 20, color: done ? colors.success : colors.textTertiary),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: AppTextStyles.bodySmall.copyWith(
            decoration: done ? TextDecoration.lineThrough : null,
            color: done ? colors.textTertiary : colors.textPrimary,
          ))),
          InkWell(
            onTap: () => showHrmSuccessSnackbar(context, 'Sửa việc con...'),
            child: Padding(padding: const EdgeInsets.all(4), child: Icon(Icons.edit_outlined, size: 14, color: colors.info)),
          ),
          InkWell(
            onTap: () => showHrmSuccessSnackbar(context, 'Đã xóa việc con'),
            child: Padding(padding: const EdgeInsets.all(4), child: Icon(Icons.close_rounded, size: 14, color: colors.error)),
          ),
        ],
      ),
    );
  }

  Widget _multiAssigneeRow(BuildContext context) {
    final colors = AppColors.of(context);
    final assignees = task.assignees.isNotEmpty ? task.assignees : [task.assignee];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.groups_rounded, size: 18, color: colors.textTertiary),
          const SizedBox(width: 10),
          SizedBox(width: 80, child: Text('Thực hiện', style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary))),
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: assignees.map((name) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: colors.primarySurface, borderRadius: BorderRadius.circular(999)),
                child: Text(name, style: AppTextStyles.labelSmall.copyWith(color: colors.primary, fontWeight: FontWeight.w600)),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSubtaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context, backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 12),
          Text('Thêm việc con', style: AppTextStyles.headlineSmall.copyWith(fontSize: 16)),
          const SizedBox(height: 12),
          const TextField(autofocus: true, decoration: InputDecoration(hintText: 'Tên việc con...')),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () { Navigator.pop(ctx); showHrmSuccessSnackbar(context, 'Đã thêm việc con mới'); },
            child: const Text('Thêm'),
          )),
        ]),
      ),
    );
  }

  void _showReminderSheet(BuildContext context) {
    showModalBottomSheet(
      context: context, backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 12),
          Text('Đặt nhắc việc', style: AppTextStyles.headlineSmall.copyWith(fontSize: 16)),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: [
            _reminderChip(ctx, '15 phút', context),
            _reminderChip(ctx, '30 phút', context),
            _reminderChip(ctx, '1 giờ', context),
            _reminderChip(ctx, '3 giờ', context),
            _reminderChip(ctx, 'Ngày mai 9:00', context),
            _reminderChip(ctx, 'Tùy chỉnh...', context),
          ]),
          const SizedBox(height: 12),
        ]),
      ),
    );
  }

  Widget _reminderChip(BuildContext ctx, String label, BuildContext parentCtx) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () { Navigator.pop(ctx); showHrmSuccessSnackbar(parentCtx, 'Đã đặt nhắc: $label'); },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.3))),
          child: Text(label, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12)),
        ),
      ),
    );
  }

  void _showEditTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 12),
            Text('Sửa công việc', style: AppTextStyles.headlineSmall.copyWith(fontSize: 18)),
            const SizedBox(height: 16),
            Text('Tiêu đề *', style: AppTextStyles.labelLarge),
            const SizedBox(height: 6),
            TextField(controller: TextEditingController(text: task.title)),
            const SizedBox(height: 14),
            Text('Mô tả', style: AppTextStyles.labelLarge),
            const SizedBox(height: 6),
            TextField(controller: TextEditingController(text: task.description), maxLines: 2),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(
                onPressed: () { Navigator.pop(ctx); showHrmSuccessSnackbar(context, 'Đã cập nhật công việc'); },
                child: const Text('Lưu'),
              )),
            ]),
          ]),
        ),
      ),
    );
  }

  void _showDeleteTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.errorLight, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.warning_rounded, color: AppColors.error, size: 22)),
          const SizedBox(width: 12),
          const Expanded(child: Text('Xóa công việc')),
        ]),
        content: Text('Bạn có chắc chắn muốn xóa "${task.title}"?', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () { Navigator.pop(ctx); onClose(); showHrmSuccessSnackbar(context, 'Đã xóa công việc'); },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colors.textTertiary),
          const SizedBox(width: 10),
          SizedBox(width: 70, child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary))),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500, color: colors.textPrimary))),
        ],
      ),
    );
  }

  Widget _timesheetRow(BuildContext context, String date, String hours) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date, style: AppTextStyles.bodySmall.copyWith(color: colors.textPrimary)),
          Text(hours, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, color: colors.textPrimary)),
        ],
      ),
    );
  }

  Widget _commentBubble(BuildContext context, String author, String text, String time) {
    final colors = AppColors.of(context);
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
                    Text(author, style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600, color: colors.textPrimary)),
                    const SizedBox(width: 8),
                    Text(time, style: AppTextStyles.labelSmall.copyWith(fontSize: 10, color: colors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: colors.surfaceVariant, borderRadius: BorderRadius.circular(8)),
                  child: Text(text, style: AppTextStyles.bodySmall.copyWith(color: colors.textPrimary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(BuildContext context, TaskStatus status) {
    final swatches = {TaskStatus.todo: AppColors.kanbanTodo, TaskStatus.inProgress: AppColors.kanbanInProgress, TaskStatus.review: AppColors.kanbanReview, TaskStatus.done: AppColors.kanbanDone};
    final labels = {TaskStatus.todo: 'Cần làm', TaskStatus.inProgress: 'Đang làm', TaskStatus.review: 'Đánh giá', TaskStatus.done: 'Hoàn thành'};
    final c = swatches[status]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
      child: Text(labels[status]!, style: AppTextStyles.labelSmall.copyWith(color: c, fontWeight: FontWeight.w600, fontSize: 11)),
    );
  }

  Widget _priorityChip(BuildContext context, TaskPriority priority) {
    final swatches = {TaskPriority.critical: AppColors.priorityCritical, TaskPriority.high: AppColors.priorityHigh, TaskPriority.medium: AppColors.priorityMedium, TaskPriority.low: AppColors.priorityLow};
    final labels = {TaskPriority.critical: 'Khẩn cấp', TaskPriority.high: 'Cao', TaskPriority.medium: 'Trung bình', TaskPriority.low: 'Thấp'};
    final c = swatches[priority]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
      child: Text(labels[priority]!, style: AppTextStyles.labelSmall.copyWith(color: c, fontWeight: FontWeight.w600, fontSize: 11)),
    );
  }
}
