/// MOCK DATA - PROJECTS & TASKS
enum TaskPriority { critical, high, medium, low }
enum TaskStatus { todo, inProgress, review, done }

class MockProject {
  final String id, name, description, color;
  final int taskCount;
  final double progress;
  const MockProject({required this.id, required this.name, required this.description, required this.taskCount, required this.progress, required this.color});
}

class MockTask {
  final String id, title, description, assignee, assigneeAvatar, dueDate, projectId;
  final TaskPriority priority;
  TaskStatus status;
  final bool isOverdue;
  final double progress;
  final int subtasksDone, subtasksTotal, comments;
  final List<String> tags;
  MockTask({required this.id, required this.title, required this.description, required this.assignee, required this.assigneeAvatar, required this.priority, required this.status, required this.dueDate, required this.isOverdue, required this.progress, required this.subtasksDone, required this.subtasksTotal, required this.comments, required this.projectId, required this.tags});
}

class GanttEntry {
  final String taskName, assignee, color;
  final int startDay, duration;
  final double progress;
  const GanttEntry({required this.taskName, required this.startDay, required this.duration, required this.progress, required this.assignee, required this.color});
}

final List<MockProject> mockProjectList = [
  const MockProject(id: 'p1', name: 'ERP Migration Phase 2', description: 'Di chuyển ERP sang cloud', taskCount: 45, progress: 0.82, color: '#1A73E8'),
  const MockProject(id: 'p2', name: 'Mobile App v3.0', description: 'App mobile phiên bản 3', taskCount: 32, progress: 0.61, color: '#F59E0B'),
  const MockProject(id: 'p3', name: 'Data Warehouse', description: 'Kho dữ liệu tập trung', taskCount: 28, progress: 0.35, color: '#EF4444'),
  const MockProject(id: 'p4', name: 'Cloud Infrastructure', description: 'Hạ tầng cloud', taskCount: 18, progress: 0.91, color: '#10B981'),
  const MockProject(id: 'p5', name: 'CRM Integration', description: 'Tích hợp CRM', taskCount: 22, progress: 0.55, color: '#8B5CF6'),
];

final List<MockTask> mockTasks = [
  MockTask(id: 't1', title: 'Thiết kế Database Schema mới', description: 'Thiết kế lại schema cho module HR', assignee: 'Nguyễn Văn An', assigneeAvatar: 'NVA', priority: TaskPriority.high, status: TaskStatus.todo, dueDate: '12/05/2026', isOverdue: false, progress: 0.0, subtasksDone: 0, subtasksTotal: 5, comments: 3, projectId: 'p1', tags: ['Database', 'Backend']),
  MockTask(id: 't2', title: 'Viết API Endpoints Payroll', description: 'REST API tính lương', assignee: 'Trần Thị Bình', assigneeAvatar: 'TTB', priority: TaskPriority.critical, status: TaskStatus.todo, dueDate: '05/05/2026', isOverdue: true, progress: 0.0, subtasksDone: 0, subtasksTotal: 8, comments: 7, projectId: 'p1', tags: ['API']),
  MockTask(id: 't3', title: 'Cập nhật Document Requirements', description: 'Cập nhật tài liệu yêu cầu', assignee: 'Lê Hoàng Cường', assigneeAvatar: 'LHC', priority: TaskPriority.low, status: TaskStatus.todo, dueDate: '20/05/2026', isOverdue: false, progress: 0.0, subtasksDone: 0, subtasksTotal: 3, comments: 1, projectId: 'p2', tags: ['Doc']),
  MockTask(id: 't4', title: 'Phát triển Dashboard Module', description: 'Dashboard cho lãnh đạo', assignee: 'Phạm Minh Đức', assigneeAvatar: 'PMD', priority: TaskPriority.high, status: TaskStatus.inProgress, dueDate: '15/05/2026', isOverdue: false, progress: 0.65, subtasksDone: 4, subtasksTotal: 7, comments: 12, projectId: 'p1', tags: ['Frontend']),
  MockTask(id: 't5', title: 'Tích hợp OAuth2 Authentication', description: 'SSO với OAuth2 + JWT', assignee: 'Nguyễn Văn An', assigneeAvatar: 'NVA', priority: TaskPriority.critical, status: TaskStatus.inProgress, dueDate: '10/05/2026', isOverdue: false, progress: 0.45, subtasksDone: 3, subtasksTotal: 6, comments: 8, projectId: 'p1', tags: ['Security']),
  MockTask(id: 't6', title: 'Thiết kế UI Mobile App', description: 'Wireframe + Prototype mobile', assignee: 'Đỗ Mai Hương', assigneeAvatar: 'DMH', priority: TaskPriority.medium, status: TaskStatus.inProgress, dueDate: '18/05/2026', isOverdue: false, progress: 0.80, subtasksDone: 8, subtasksTotal: 10, comments: 15, projectId: 'p2', tags: ['UI/UX']),
  MockTask(id: 't7', title: 'Code Review Employee Module', description: 'Review module nhân viên', assignee: 'Hoàng Thu Em', assigneeAvatar: 'HTE', priority: TaskPriority.medium, status: TaskStatus.review, dueDate: '08/05/2026', isOverdue: false, progress: 0.90, subtasksDone: 9, subtasksTotal: 10, comments: 20, projectId: 'p1', tags: ['Review']),
  MockTask(id: 't8', title: 'Testing UAT Chấm công', description: 'Kiểm thử chức năng chấm công', assignee: 'Vũ Thanh Phong', assigneeAvatar: 'VTP', priority: TaskPriority.high, status: TaskStatus.review, dueDate: '07/05/2026', isOverdue: true, progress: 0.95, subtasksDone: 19, subtasksTotal: 20, comments: 25, projectId: 'p3', tags: ['QA']),
  MockTask(id: 't9', title: 'Setup CI/CD Pipeline', description: 'Pipeline CI/CD', assignee: 'Phạm Minh Đức', assigneeAvatar: 'PMD', priority: TaskPriority.high, status: TaskStatus.done, dueDate: '01/05/2026', isOverdue: false, progress: 1.0, subtasksDone: 6, subtasksTotal: 6, comments: 10, projectId: 'p4', tags: ['DevOps']),
  MockTask(id: 't10', title: 'Cấu hình Server Production', description: 'Setup production', assignee: 'Ngô Quốc Hùng', assigneeAvatar: 'NQH', priority: TaskPriority.critical, status: TaskStatus.done, dueDate: '28/04/2026', isOverdue: false, progress: 1.0, subtasksDone: 12, subtasksTotal: 12, comments: 18, projectId: 'p4', tags: ['Infra']),
];

const List<GanttEntry> mockGanttEntries = [
  GanttEntry(taskName: 'Phân tích yêu cầu', startDay: 0, duration: 5, progress: 1.0, assignee: 'An', color: '#10B981'),
  GanttEntry(taskName: 'Thiết kế Database', startDay: 3, duration: 7, progress: 0.8, assignee: 'Cường', color: '#1A73E8'),
  GanttEntry(taskName: 'Phát triển Backend', startDay: 8, duration: 15, progress: 0.6, assignee: 'Bình', color: '#F59E0B'),
  GanttEntry(taskName: 'Phát triển Frontend', startDay: 10, duration: 18, progress: 0.45, assignee: 'Đức', color: '#8B5CF6'),
  GanttEntry(taskName: 'Thiết kế UI/UX', startDay: 5, duration: 10, progress: 0.9, assignee: 'Hương', color: '#EC4899'),
  GanttEntry(taskName: 'Testing & QA', startDay: 20, duration: 8, progress: 0.2, assignee: 'Phong', color: '#EF4444'),
  GanttEntry(taskName: 'Deploy & Go-live', startDay: 26, duration: 4, progress: 0.0, assignee: 'Hùng', color: '#6B7280'),
];
