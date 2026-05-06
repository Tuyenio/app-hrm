// MOCK DATA - DASHBOARD
// Du lieu gia lap cho Executive BI Dashboard.

class DashboardKpi {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final String icon;

  const DashboardKpi({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
  });
}

class ProjectRag {
  final String name;
  final String manager;
  final String status; // 'green', 'amber', 'red'
  final double progress;
  final String deadline;
  final int teamSize;

  const ProjectRag({
    required this.name,
    required this.manager,
    required this.status,
    required this.progress,
    required this.deadline,
    required this.teamSize,
  });
}

class WorkloadEntry {
  final String employeeName;
  final String department;
  final List<double> weeklyHours; // 5 tuần

  const WorkloadEntry({
    required this.employeeName,
    required this.department,
    required this.weeklyHours,
  });
}

class DepartmentStat {
  final String name;
  final double completion;
  final int tasks;
  final int completed;

  const DepartmentStat({
    required this.name,
    required this.completion,
    required this.tasks,
    required this.completed,
  });
}

/// Mock KPI cards
const List<DashboardKpi> mockKpis = [
  DashboardKpi(
    title: 'Tổng Nhân Sự',
    value: '1,247',
    change: '+12 tháng này',
    isPositive: true,
    icon: 'people',
  ),
  DashboardKpi(
    title: 'Quỹ Lương Tháng',
    value: '₫18.5 Tỷ',
    change: '+2.3% so với T3',
    isPositive: false,
    icon: 'wallet',
  ),
  DashboardKpi(
    title: 'Dự Án Đang Chạy',
    value: '24',
    change: '3 mới trong tuần',
    isPositive: true,
    icon: 'project',
  ),
  DashboardKpi(
    title: 'Hoàn Thành CV',
    value: '78.5%',
    change: '+5.2% so với tuần trước',
    isPositive: true,
    icon: 'task',
  ),
];

/// Mock project RAG data
const List<ProjectRag> mockProjects = [
  ProjectRag(
    name: 'ERP Migration Phase 2',
    manager: 'Nguyễn Văn An',
    status: 'green',
    progress: 0.82,
    deadline: '30/06/2026',
    teamSize: 15,
  ),
  ProjectRag(
    name: 'Mobile App v3.0',
    manager: 'Trần Thị Bình',
    status: 'amber',
    progress: 0.61,
    deadline: '15/05/2026',
    teamSize: 8,
  ),
  ProjectRag(
    name: 'Data Warehouse',
    manager: 'Lê Hoàng Cường',
    status: 'red',
    progress: 0.35,
    deadline: '01/05/2026',
    teamSize: 12,
  ),
  ProjectRag(
    name: 'Cloud Infrastructure',
    manager: 'Phạm Minh Đức',
    status: 'green',
    progress: 0.91,
    deadline: '20/07/2026',
    teamSize: 6,
  ),
  ProjectRag(
    name: 'CRM Integration',
    manager: 'Hoàng Thu Em',
    status: 'amber',
    progress: 0.55,
    deadline: '10/06/2026',
    teamSize: 10,
  ),
  ProjectRag(
    name: 'Security Audit Q2',
    manager: 'Vũ Thanh Phong',
    status: 'green',
    progress: 0.73,
    deadline: '25/06/2026',
    teamSize: 4,
  ),
  ProjectRag(
    name: 'HR Portal Redesign',
    manager: 'Đỗ Mai Hương',
    status: 'red',
    progress: 0.28,
    deadline: '05/05/2026',
    teamSize: 7,
  ),
];

/// Mock workload heatmap data
const List<WorkloadEntry> mockWorkload = [
  WorkloadEntry(
    employeeName: 'Nguyễn Văn An',
    department: 'IT',
    weeklyHours: [42, 45, 38, 48, 44],
  ),
  WorkloadEntry(
    employeeName: 'Trần Thị Bình',
    department: 'IT',
    weeklyHours: [36, 40, 42, 35, 38],
  ),
  WorkloadEntry(
    employeeName: 'Lê Hoàng Cường',
    department: 'IT',
    weeklyHours: [50, 52, 48, 55, 51],
  ),
  WorkloadEntry(
    employeeName: 'Phạm Minh Đức',
    department: 'DevOps',
    weeklyHours: [30, 28, 32, 25, 30],
  ),
  WorkloadEntry(
    employeeName: 'Hoàng Thu Em',
    department: 'Sales',
    weeklyHours: [44, 46, 40, 43, 45],
  ),
  WorkloadEntry(
    employeeName: 'Vũ Thanh Phong',
    department: 'Security',
    weeklyHours: [38, 40, 42, 38, 40],
  ),
  WorkloadEntry(
    employeeName: 'Đỗ Mai Hương',
    department: 'Design',
    weeklyHours: [55, 52, 58, 50, 54],
  ),
  WorkloadEntry(
    employeeName: 'Ngô Quốc Hùng',
    department: 'HR',
    weeklyHours: [35, 32, 30, 34, 33],
  ),
];

/// Mock department stats
const List<DepartmentStat> mockDepartmentStats = [
  DepartmentStat(
    name: 'Phòng IT',
    completion: 0.85,
    tasks: 120,
    completed: 102,
  ),
  DepartmentStat(
    name: 'Phòng Sales',
    completion: 0.72,
    tasks: 85,
    completed: 61,
  ),
  DepartmentStat(name: 'Phòng HR', completion: 0.91, tasks: 45, completed: 41),
  DepartmentStat(
    name: 'Phòng Design',
    completion: 0.68,
    tasks: 60,
    completed: 41,
  ),
  DepartmentStat(
    name: 'Phòng DevOps',
    completion: 0.78,
    tasks: 55,
    completed: 43,
  ),
  DepartmentStat(
    name: 'Phòng Marketing',
    completion: 0.82,
    tasks: 70,
    completed: 57,
  ),
];

/// Mock revenue per employee chart data (12 months)
const List<double> mockRevenuePerEmployee = [
  42.5,
  44.1,
  43.8,
  46.2,
  47.0,
  48.5,
  47.8,
  49.2,
  50.1,
  51.3,
  52.0,
  53.5,
];

const List<double> mockTurnoverRate = [
  3.2,
  2.8,
  3.0,
  2.5,
  2.3,
  2.1,
  2.4,
  2.0,
  1.8,
  2.2,
  1.9,
  1.7,
];

const List<String> mockMonths = [
  'T1',
  'T2',
  'T3',
  'T4',
  'T5',
  'T6',
  'T7',
  'T8',
  'T9',
  'T10',
  'T11',
  'T12',
];
