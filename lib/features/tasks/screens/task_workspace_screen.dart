import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/interactive_overlays.dart';
import '../../../data/mock/project_data.dart';
import '../../../data/mock/employee_data.dart';
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
  String _searchQuery = '';
  String _priorityFilter = 'Tất cả';
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
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
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
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.divider)),
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
                  style: AppTextStyles.headlineLarge.copyWith(
                    fontSize: 20,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
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
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () => _showCreateTaskSheet(context),
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
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          // Search bar
          Container(
            height: 38,
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm công việc...',
                hintStyle: AppTextStyles.bodySmall.copyWith(
                  color: colors.textTertiary,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: colors.textTertiary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // View toggle
          Row(
            children: [
              Expanded(
                child: ViewToggle(
                  selectedIndex: _viewIndex,
                  onChanged: (i) => setState(() => _viewIndex = i),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.borderLight),
                ),
                child: IconButton(
                  onPressed: () => _showTaskFilterSheet(context),
                  icon: const Icon(Icons.filter_list_rounded, size: 18),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ),
            ],
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
    final colors = AppColors.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
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
                    color: colors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            Text(
              'Chọn dự án',
              style: AppTextStyles.headlineSmall.copyWith(
                fontSize: 18,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _projectOption('all', 'Tất cả công việc', Icons.grid_view_rounded),
            ...mockProjectList.map(
              (p) => _projectOption(p.id, p.name, Icons.folder_rounded),
            ),
            const Divider(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.add_rounded, size: 20, color: colors.success),
              ),
              title: Text(
                'Tạo dự án mới',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.success,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {
                Navigator.pop(context);
                _showCreateProjectSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _projectOption(String id, String name, IconData icon) {
    final isSelected = id == _selectedProjectId;
    final colors = AppColors.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? colors.primary : colors.textSecondary,
        size: 20,
      ),
      title: Text(
        name,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? colors.primary : colors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_rounded, color: colors.primary, size: 20)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: isSelected ? colors.primarySurface : null,
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
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
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
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.divider)),
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
              backgroundColor: colors.surfaceVariant,
              padding: const EdgeInsets.all(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quản trị Công việc',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  '${mockTasks.length} tasks • 5 dự án đang hoạt động',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
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
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.borderLight),
            ),
            child: IconButton(
              onPressed: () => _showTaskFilterSheet(context),
              icon: const Icon(Icons.filter_list_rounded, size: 18),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => _showCreateTaskSheet(context),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Tạo task'),
          ),
        ],
      ),
    );
  }

  // ── CREATE TASK SHEET ─────────────────────────────────────────────────────
  void _showCreateTaskSheet(BuildContext context) {
    final colors = AppColors.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, sc) => Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Row(
                      children: [
                        Text(
                          'Tạo công việc mới',
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontSize: 18,
                            color: colors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: sc,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tiêu đề *',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: 'Nhập tiêu đề công việc',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Mô tả',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Mô tả chi tiết...',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Người thực hiện',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: colors.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: colors.borderLight),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: null,
                                hint: const Text('Chọn người thực hiện'),
                                items: mockEmployeeList
                                    .take(8)
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e.id,
                                        child: Text(e.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (_) {},
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Dự án',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: colors.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: colors.borderLight),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: null,
                                hint: const Text('Chọn dự án'),
                                items: mockProjectList
                                    .map(
                                      (p) => DropdownMenuItem(
                                        value: p.id,
                                        child: Text(p.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (_) {},
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Hạn hoàn thành',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () => showDatePicker(
                              context: context,
                              initialDate: DateTime.now().add(
                                const Duration(days: 7),
                              ),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2027),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: colors.borderLight),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    size: 18,
                                    color: colors.textTertiary,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Chọn ngày',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: colors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Độ ưu tiên',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              _priorityChip('Thấp', AppColors.priorityLow),
                              _priorityChip(
                                'Trung bình',
                                AppColors.priorityMedium,
                              ),
                              _priorityChip('Cao', AppColors.priorityHigh),
                              _priorityChip(
                                'Khẩn cấp',
                                AppColors.priorityCritical,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Hủy'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showHrmSuccessSnackbar(
                                      context,
                                      'Đã tạo công việc mới',
                                    );
                                  },
                                  child: const Text('Tạo công việc'),
                                ),
                              ),
                            ],
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
      ),
    );
  }

  Widget _priorityChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  // ── CREATE PROJECT SHEET ──────────────────────────────────────────────────
  void _showCreateProjectSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tạo dự án mới',
                style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Text('Tên dự án *', style: AppTextStyles.labelLarge),
              const SizedBox(height: 6),
              const TextField(
                decoration: InputDecoration(hintText: 'VD: Mobile App v4.0'),
              ),
              const SizedBox(height: 14),
              Text('Mô tả', style: AppTextStyles.labelLarge),
              const SizedBox(height: 6),
              const TextField(
                maxLines: 2,
                decoration: InputDecoration(hintText: 'Mô tả dự án...'),
              ),
              const SizedBox(height: 14),
              Text('Quản lý dự án', style: AppTextStyles.labelLarge),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: null,
                    hint: const Text('Chọn PM'),
                    items: mockEmployeeList
                        .take(5)
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (_) {},
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Hủy'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showHrmSuccessSnackbar(context, 'Đã tạo dự án mới');
                      },
                      child: const Text('Tạo dự án'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── FILTER SHEET ──────────────────────────────────────────────────────────
  void _showTaskFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Bộ lọc công việc',
              style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text('Độ ưu tiên', style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _priorityChip('Tất cả', AppColors.primary),
                _priorityChip('Khẩn cấp', AppColors.priorityCritical),
                _priorityChip('Cao', AppColors.priorityHigh),
                _priorityChip('Trung bình', AppColors.priorityMedium),
                _priorityChip('Thấp', AppColors.priorityLow),
              ],
            ),
            const SizedBox(height: 16),
            Text('Trạng thái', style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _priorityChip('Cần làm', AppColors.kanbanTodo),
                _priorityChip('Đang làm', AppColors.kanbanInProgress),
                _priorityChip('Đánh giá', AppColors.kanbanReview),
                _priorityChip('Hoàn thành', AppColors.kanbanDone),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Đặt lại'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showHrmSuccessSnackbar(context, 'Đã áp dụng bộ lọc');
                    },
                    child: const Text('Áp dụng'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
