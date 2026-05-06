import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/project_data.dart';
import '../widgets/project_sidebar.dart';
import '../widgets/kanban_board.dart';
import '../widgets/gantt_chart_view.dart';
import '../widgets/task_detail_drawer.dart';

/// ============================================================================
/// TASK WORKSPACE SCREEN - Mobile-first redesign
/// Mobile: Không có sidebar, header compact, Kanban horizontal scroll.
/// Desktop: Split sidebar + content + detail drawer.
/// ============================================================================
class TaskWorkspaceScreen extends StatefulWidget {
  const TaskWorkspaceScreen({super.key});

  @override
  State<TaskWorkspaceScreen> createState() => _TaskWorkspaceScreenState();
}

class _TaskWorkspaceScreenState extends State<TaskWorkspaceScreen> {
  int _viewIndex = 1; // Default: Kanban
  String _selectedProjectId = 'all';
  MockTask? _selectedTask;
  bool _showSidebar = true;
  late final PageController _kanbanPageController;
  int _kanbanPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _kanbanPageController = PageController(initialPage: _kanbanPageIndex);
  }

  @override
  void dispose() {
    _kanbanPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      return _buildMobileLayout();
    }
    return _buildDesktopLayout();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // MOBILE LAYOUT
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildMobileHeader(),
            Expanded(
              child: _viewIndex == 0
                  ? _buildMobileListView()
                  : _viewIndex == 1
                  ? _buildMobileKanbanView()
                  : _buildMobileGanttView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Expanded(
                child: Text(
                  'Quản trị Công việc',
                  style: AppTextStyles.headlineLarge.copyWith(fontSize: 20),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () => _showMobileProjectPicker(),
                  icon: const Icon(Icons.folder_outlined, size: 18),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${mockTasks.length} tasks • 5 dự án',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 10),
          // View toggle
          ViewToggle(
            selectedIndex: _viewIndex,
            onChanged: (i) => setState(() => _viewIndex = i),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileKanbanView() {
    final columns = [
      (
        'Cần làm',
        TaskStatus.todo,
        AppColors.kanbanTodo,
        Icons.radio_button_unchecked_rounded,
      ),
      (
        'Đang làm',
        TaskStatus.inProgress,
        AppColors.kanbanInProgress,
        Icons.play_circle_outline_rounded,
      ),
      (
        'Đánh giá',
        TaskStatus.review,
        AppColors.kanbanReview,
        Icons.rate_review_outlined,
      ),
      (
        'Hoàn thành',
        TaskStatus.done,
        AppColors.kanbanDone,
        Icons.check_circle_outline_rounded,
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: columns.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final column = columns[i];
              return _buildKanbanChip(column.$1, column.$3, column.$4, i);
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: PageView.builder(
            controller: _kanbanPageController,
            onPageChanged: (index) => setState(() => _kanbanPageIndex = index),
            itemCount: columns.length,
            itemBuilder: (context, i) {
              final column = columns[i];
              return _buildMobileKanbanColumn(
                column.$1,
                column.$2,
                column.$3,
                column.$4,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildKanbanChip(String title, Color color, IconData icon, int index) {
    final isActive = index == _kanbanPageIndex;
    return GestureDetector(
      onTap: () {
        setState(() => _kanbanPageIndex = index);
        _kanbanPageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.12) : AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isActive
                ? color.withValues(alpha: 0.6)
                : AppColors.borderLight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? color : AppColors.textTertiary,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: AppTextStyles.labelMedium.copyWith(
                color: isActive ? color : AppColors.textTertiary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileKanbanColumn(
    String title,
    TaskStatus status,
    Color color,
    IconData icon,
  ) {
    final columnTasks = mockTasks.where((t) => t.status == status).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${columnTasks.length}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            Expanded(
              child: columnTasks.isEmpty
                  ? Center(
                      child: Text(
                        'Chưa có công việc',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: columnTasks.length,
                      itemBuilder: (context, index) {
                        final task = columnTasks[index];
                        return GestureDetector(
                          onTap: () => _showMobileTaskDetail(task),
                          child: _buildMobileTaskCard(task),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileTaskCard(MockTask task) {
    final priorityColors = {
      TaskPriority.critical: AppColors.priorityCritical,
      TaskPriority.high: AppColors.priorityHigh,
      TaskPriority.medium: AppColors.priorityMedium,
      TaskPriority.low: AppColors.priorityLow,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: priorityColors[task.priority],
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(10),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: AppTextStyles.titleSmall.copyWith(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: AppColors.primarySurface,
                          child: Text(
                            task.assigneeAvatar,
                            style: const TextStyle(
                              fontSize: 7,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: task.isOverdue
                                ? AppColors.errorLight
                                : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            task.dueDate,
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 9,
                              color: task.isOverdue
                                  ? AppColors.error
                                  : AppColors.textTertiary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (task.progress > 0)
                          Text(
                            '${(task.progress * 100).toInt()}%',
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: mockTasks.length,
      itemBuilder: (context, i) {
        final task = mockTasks[i];
        return GestureDetector(
          onTap: () => _showMobileTaskDetail(task),
          child: _buildMobileTaskCard(task),
        );
      },
    );
  }

  Widget _buildMobileGanttView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: const GanttChartView(
          dayWidth: 24,
          labelWidth: 120,
          rowHeight: 44,
        ),
      ),
    );
  }

  void _showMobileTaskDetail(MockTask task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: TaskDetailDrawer(
                  task: task,
                  onClose: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMobileProjectPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            Text(
              'Chọn dự án',
              style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),
            _projectOption('all', 'Tất cả công việc', Icons.grid_view_rounded),
            ...mockProjectList.map(
              (p) => _projectOption(p.id, p.name, Icons.folder_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _projectOption(String id, String name, IconData icon) {
    final isSelected = id == _selectedProjectId;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        size: 20,
      ),
      title: Text(
        name,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_rounded, color: AppColors.primary, size: 20)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: isSelected ? AppColors.primarySurface : null,
      onTap: () {
        setState(() => _selectedProjectId = id);
        Navigator.pop(context);
      },
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // DESKTOP LAYOUT
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          if (_showSidebar)
            ProjectSidebar(
              selectedProjectId: _selectedProjectId,
              onProjectSelected: (id) =>
                  setState(() => _selectedProjectId = id),
            ),
          Expanded(
            child: Column(
              children: [
                _buildDesktopTopBar(),
                Expanded(
                  child: _viewIndex == 0
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: TaskListView(
                            tasks: mockTasks,
                            onTaskTap: (task) =>
                                setState(() => _selectedTask = task),
                          ),
                        )
                      : _viewIndex == 1
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: 1280,
                            child: KanbanBoard(
                              tasks: mockTasks,
                              onTaskTap: (task) =>
                                  setState(() => _selectedTask = task),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: const GanttChartView(),
                          ),
                        ),
                ),
              ],
            ),
          ),
          if (_selectedTask != null)
            TaskDetailDrawer(
              task: _selectedTask!,
              onClose: () => setState(() => _selectedTask = null),
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => setState(() => _showSidebar = !_showSidebar),
            icon: Icon(
              _showSidebar ? Icons.menu_open_rounded : Icons.menu_rounded,
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceVariant,
              padding: const EdgeInsets.all(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quản trị Công việc', style: AppTextStyles.headlineSmall),
                Text(
                  '${mockTasks.length} tasks • 5 dự án đang hoạt động',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          ViewToggle(
            selectedIndex: _viewIndex,
            onChanged: (i) => setState(() => _viewIndex = i),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.filter_list_rounded, size: 18),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Tạo task'),
          ),
        ],
      ),
    );
  }
}
