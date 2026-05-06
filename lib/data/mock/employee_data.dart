/// MOCK DATA - EMPLOYEE & ESS
class MockEmployee {
  final String id, name, avatar, position, department, email, phone;
  final String employeeId, joinDate, contractType;
  final bool isActive;
  const MockEmployee({
    required this.id, required this.name, required this.avatar,
    required this.position, required this.department, required this.email,
    required this.phone, this.employeeId = '', this.joinDate = '',
    this.contractType = 'Chính thức', this.isActive = true,
  });
}

class EssTask {
  final String title, project, dueDate;
  final double progress;
  final bool isOverdue;
  const EssTask({required this.title, required this.project, required this.dueDate, required this.progress, required this.isOverdue});
}

class PayslipItem {
  final String label, value;
  final bool isDeduction;
  const PayslipItem({required this.label, required this.value, this.isDeduction = false});
}

const currentUser = MockEmployee(
  id: 'emp001', name: 'Nguyễn Minh Tuấn', avatar: 'NMT',
  position: 'Senior Developer', department: 'Phòng Công nghệ',
  email: 'tuan.nm@company.vn', phone: '0912 345 678',
  employeeId: 'NV-001', joinDate: '15/03/2022', contractType: 'Chính thức',
);

/// Danh sách nhân viên đầy đủ cho Core HR
const List<MockEmployee> mockEmployeeList = [
  MockEmployee(id: 'emp001', name: 'Nguyễn Minh Tuấn', avatar: 'NMT', position: 'Senior Developer', department: 'IT', email: 'tuan.nm@company.vn', phone: '0912 345 678', employeeId: 'NV-001', joinDate: '15/03/2022'),
  MockEmployee(id: 'emp002', name: 'Nguyễn Văn An', avatar: 'NVA', position: 'Tech Lead', department: 'IT', email: 'an.nv@company.vn', phone: '0912 345 679', employeeId: 'NV-002', joinDate: '01/01/2021'),
  MockEmployee(id: 'emp003', name: 'Trần Thị Bình', avatar: 'TTB', position: 'Backend Developer', department: 'IT', email: 'binh.tt@company.vn', phone: '0912 345 680', employeeId: 'NV-003', joinDate: '10/06/2021'),
  MockEmployee(id: 'emp004', name: 'Lê Hoàng Cường', avatar: 'LHC', position: 'CTO', department: 'IT', email: 'cuong.lh@company.vn', phone: '0912 345 681', employeeId: 'NV-004', joinDate: '05/01/2020'),
  MockEmployee(id: 'emp005', name: 'Phạm Minh Đức', avatar: 'PMD', position: 'DevOps Engineer', department: 'DevOps', email: 'duc.pm@company.vn', phone: '0912 345 682', employeeId: 'NV-005', joinDate: '20/08/2021'),
  MockEmployee(id: 'emp006', name: 'Hoàng Thu Em', avatar: 'HTE', position: 'Sales Manager', department: 'Sales', email: 'em.ht@company.vn', phone: '0912 345 683', employeeId: 'NV-006', joinDate: '15/02/2022'),
  MockEmployee(id: 'emp007', name: 'Vũ Thanh Phong', avatar: 'VTP', position: 'QA Lead', department: 'IT', email: 'phong.vt@company.vn', phone: '0912 345 684', employeeId: 'NV-007', joinDate: '01/05/2021'),
  MockEmployee(id: 'emp008', name: 'Đỗ Mai Hương', avatar: 'DMH', position: 'UI/UX Designer', department: 'Design', email: 'huong.dm@company.vn', phone: '0912 345 685', employeeId: 'NV-008', joinDate: '10/09/2022'),
  MockEmployee(id: 'emp009', name: 'Ngô Quốc Hùng', avatar: 'NQH', position: 'HR Manager', department: 'HR', email: 'hung.nq@company.vn', phone: '0912 345 686', employeeId: 'NV-009', joinDate: '01/03/2020'),
  MockEmployee(id: 'emp010', name: 'Lý Thu Hà', avatar: 'LTH', position: 'Accountant', department: 'HR', email: 'ha.lt@company.vn', phone: '0912 345 687', employeeId: 'NV-010', joinDate: '20/07/2023', isActive: false),
  MockEmployee(id: 'emp011', name: 'Bùi Đức Trọng', avatar: 'BĐT', position: 'Sales Executive', department: 'Sales', email: 'trong.bd@company.vn', phone: '0912 345 688', employeeId: 'NV-011', joinDate: '05/11/2022'),
  MockEmployee(id: 'emp012', name: 'Cao Thị Lan', avatar: 'CTL', position: 'Product Designer', department: 'Design', email: 'lan.ct@company.vn', phone: '0912 345 689', employeeId: 'NV-012', joinDate: '01/04/2023'),
];

const List<EssTask> mockEssTasks = [
  EssTask(title: 'Hoàn thành API module HR', project: 'ERP Migration', dueDate: 'Hôm nay', progress: 0.75, isOverdue: false),
  EssTask(title: 'Review code cho team', project: 'Mobile App v3', dueDate: 'Hôm nay', progress: 0.30, isOverdue: false),
  EssTask(title: 'Cập nhật tài liệu kỹ thuật', project: 'Data Warehouse', dueDate: 'Quá hạn', progress: 0.50, isOverdue: true),
  EssTask(title: 'Họp standup daily', project: 'ERP Migration', dueDate: '14:00', progress: 0.0, isOverdue: false),
];

const List<PayslipItem> mockPayslipItems = [
  PayslipItem(label: 'Lương cơ bản', value: '25,000,000'),
  PayslipItem(label: 'Phụ cấp chức vụ', value: '3,000,000'),
  PayslipItem(label: 'Phụ cấp ăn trưa', value: '730,000'),
  PayslipItem(label: 'Phụ cấp xăng xe', value: '500,000'),
  PayslipItem(label: 'Thưởng KPI', value: '2,500,000'),
  PayslipItem(label: 'OT (12 giờ)', value: '1,800,000'),
  PayslipItem(label: 'BHXH (8%)', value: '-2,000,000', isDeduction: true),
  PayslipItem(label: 'BHYT (1.5%)', value: '-375,000', isDeduction: true),
  PayslipItem(label: 'BHTN (1%)', value: '-250,000', isDeduction: true),
  PayslipItem(label: 'Thuế TNCN', value: '-1,450,000', isDeduction: true),
];
