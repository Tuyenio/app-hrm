import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/interactive_overlays.dart';
import '../../../data/mock/project_data.dart';

/// ============================================================================
/// PROJECT SIDEBAR - Sidebar dự án (bên trái workspace)
/// ============================================================================
class ProjectSidebar extends StatelessWidget {
  final String selectedProjectId;
  final ValueChanged<String> onProjectSelected;

  const ProjectSidebar({super.key, required this.selectedProjectId, required this.onProjectSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Dự án', style: AppTextStyles.headlineSmall.copyWith(fontSize: 16)),
          ),
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Container(
              height: 36,
              decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)),
              child: TextField(
                style: AppTextStyles.bodySmall,
                decoration: InputDecoration(
                  hintText: 'Tìm dự án...', hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                  prefixIcon: Icon(Icons.search_rounded, size: 18, color: AppColors.textTertiary),
                  border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                // All tasks option
                _buildItem('all', 'Tất cả công việc', Icons.grid_view_rounded, null, null),
                const Divider(height: 16),
                ...mockProjectList.map((p) => _buildItem(p.id, p.name, Icons.folder_rounded, p.progress, _parseColor(p.color))),
              ],
            ),
          ),
          // Add project button
          Padding(
            padding: const EdgeInsets.all(12),
            child: OutlinedButton.icon(
              onPressed: () => showHrmSuccessSnackbar(context, 'Đang mở form tạo dự án...'),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Tạo dự án mới'),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(40), textStyle: AppTextStyles.labelMedium),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String id, String name, IconData icon, double? progress, Color? color) {
    final isSelected = id == selectedProjectId;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onProjectSelected(id),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primarySurface : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: color ?? (isSelected ? AppColors.primary : AppColors.textSecondary)),
                const SizedBox(width: 10),
                Expanded(child: Text(name, style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ), overflow: TextOverflow.ellipsis)),
                if (progress != null)
                  Text('${(progress * 100).toInt()}%', style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
              ],
            ),
          ),
        ),
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

/// ============================================================================
/// VIEW TOGGLE - Segmented control cho List/Kanban/Gantt
/// ============================================================================
class ViewToggle extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const ViewToggle({super.key, required this.selectedIndex, required this.onChanged});

  static const _items = [
    (Icons.list_rounded, 'Danh sách'),
    (Icons.view_kanban_rounded, 'Kanban'),
    (Icons.bar_chart_rounded, 'Gantt'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_items.length, (i) {
          final isSelected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4)] : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_items[i].$1, size: 16, color: isSelected ? AppColors.primary : AppColors.textTertiary),
                  const SizedBox(width: 6),
                  Text(_items[i].$2, style: AppTextStyles.labelMedium.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.textTertiary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  )),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// ============================================================================
/// TASK LIST VIEW - Hiển thị tasks dạng bảng/danh sách
/// ============================================================================
class TaskListView extends StatelessWidget {
  final List<MockTask> tasks;
  final ValueChanged<MockTask>? onTaskTap;

  const TaskListView({super.key, required this.tasks, this.onTaskTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                SizedBox(width: 30, child: Text('#', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600))),
                Expanded(flex: 3, child: Text('Công việc', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600))),
                SizedBox(width: 100, child: Text('Phụ trách', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600))),
                SizedBox(width: 80, child: Text('Ưu tiên', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600))),
                SizedBox(width: 80, child: Text('Trạng thái', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600))),
                SizedBox(width: 90, child: Text('Hạn chót', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600))),
                SizedBox(width: 70, child: Text('Tiến độ', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          const Divider(height: 1),
          // Rows
          ...tasks.asMap().entries.map((e) => _buildRow(e.key, e.value)),
        ],
      ),
    );
  }

  Widget _buildRow(int index, MockTask task) {
    final priorityColors = {TaskPriority.critical: AppColors.priorityCritical, TaskPriority.high: AppColors.priorityHigh, TaskPriority.medium: AppColors.priorityMedium, TaskPriority.low: AppColors.priorityLow};
    final priorityLabels = {TaskPriority.critical: 'Khẩn cấp', TaskPriority.high: 'Cao', TaskPriority.medium: 'TB', TaskPriority.low: 'Thấp'};
    final statusLabels = {TaskStatus.todo: 'Cần làm', TaskStatus.inProgress: 'Đang làm', TaskStatus.review: 'Đánh giá', TaskStatus.done: 'Xong'};
    final statusColors = {TaskStatus.todo: AppColors.kanbanTodo, TaskStatus.inProgress: AppColors.kanbanInProgress, TaskStatus.review: AppColors.kanbanReview, TaskStatus.done: AppColors.kanbanDone};

    return InkWell(
      onTap: () => onTaskTap?.call(task),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: index.isEven ? null : AppColors.surfaceVariant.withValues(alpha: 0.2),
          border: Border(bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.5))),
        ),
        child: Row(
          children: [
            SizedBox(width: 30, child: Text('${index + 1}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary))),
            Expanded(flex: 3, child: Text(task.title, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
            SizedBox(width: 100, child: Text(task.assignee.split(' ').last, style: AppTextStyles.bodySmall)),
            SizedBox(width: 80, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: priorityColors[task.priority]!.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
              child: Text(priorityLabels[task.priority]!, style: AppTextStyles.labelSmall.copyWith(color: priorityColors[task.priority], fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            )),
            SizedBox(width: 80, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: statusColors[task.status]!.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
              child: Text(statusLabels[task.status]!, style: AppTextStyles.labelSmall.copyWith(color: statusColors[task.status], fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            )),
            SizedBox(width: 90, child: Text(task.dueDate, style: AppTextStyles.bodySmall.copyWith(color: task.isOverdue ? AppColors.error : null, fontWeight: task.isOverdue ? FontWeight.w600 : null))),
            SizedBox(
              width: 70,
              child: Row(
                children: [
                  Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(value: task.progress, backgroundColor: AppColors.surfaceVariant, valueColor: AlwaysStoppedAnimation(AppColors.primaryLight), minHeight: 4))),
                  const SizedBox(width: 6),
                  Text('${(task.progress * 100).toInt()}%', style: AppTextStyles.labelSmall.copyWith(fontSize: 9)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
