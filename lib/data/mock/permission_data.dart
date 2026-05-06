/// MOCK DATA - PERMISSIONS & SECURITY
class MockRole {
  final String id, name, description;
  final int userCount;
  final Map<String, Map<String, bool>> permissions;
  MockRole({required this.id, required this.name, required this.description, required this.userCount, required this.permissions});
}

class AuditLogEntry {
  final String user, action, target, ip, timestamp;
  final String type; // 'create', 'update', 'delete', 'login'
  const AuditLogEntry({required this.user, required this.action, required this.target, required this.ip, required this.timestamp, required this.type});
}

const List<String> permissionModules = ['Core HR', 'Tuyển dụng', 'Chấm công', 'Tính lương', 'Dự án', 'Báo cáo', 'Hệ thống'];
const List<String> permissionActions = ['Xem', 'Thêm', 'Sửa', 'Xóa', 'Duyệt', 'Xuất'];

final List<MockRole> mockRoles = [
  MockRole(id: 'r1', name: 'Quản trị viên', description: 'Full quyền hệ thống', userCount: 3, permissions: {
    for (var m in permissionModules) m: {for (var a in permissionActions) a: true}
  }),
  MockRole(id: 'r2', name: 'Giám đốc HR', description: 'Quản lý nhân sự toàn diện', userCount: 5, permissions: {
    'Core HR': {'Xem': true, 'Thêm': true, 'Sửa': true, 'Xóa': false, 'Duyệt': true, 'Xuất': true},
    'Tuyển dụng': {'Xem': true, 'Thêm': true, 'Sửa': true, 'Xóa': false, 'Duyệt': true, 'Xuất': true},
    'Chấm công': {'Xem': true, 'Thêm': false, 'Sửa': true, 'Xóa': false, 'Duyệt': true, 'Xuất': true},
    'Tính lương': {'Xem': true, 'Thêm': false, 'Sửa': false, 'Xóa': false, 'Duyệt': true, 'Xuất': true},
    'Dự án': {'Xem': true, 'Thêm': false, 'Sửa': false, 'Xóa': false, 'Duyệt': false, 'Xuất': true},
    'Báo cáo': {'Xem': true, 'Thêm': false, 'Sửa': false, 'Xóa': false, 'Duyệt': false, 'Xuất': true},
    'Hệ thống': {'Xem': false, 'Thêm': false, 'Sửa': false, 'Xóa': false, 'Duyệt': false, 'Xuất': false},
  }),
  MockRole(id: 'r3', name: 'Trưởng phòng', description: 'Quản lý phòng ban', userCount: 18, permissions: {
    'Core HR': {'Xem': true, 'Thêm': false, 'Sửa': false, 'Xóa': false, 'Duyệt': true, 'Xuất': false},
    'Tuyển dụng': {'Xem': true, 'Thêm': true, 'Sửa': false, 'Xóa': false, 'Duyệt': true, 'Xuất': false},
    'Chấm công': {'Xem': true, 'Thêm': false, 'Sửa': false, 'Xóa': false, 'Duyệt': true, 'Xuất': false},
    'Tính lương': {'Xem': true, 'Thêm': false, 'Sửa': false, 'Xóa': false, 'Duyệt': false, 'Xuất': false},
    'Dự án': {'Xem': true, 'Thêm': true, 'Sửa': true, 'Xóa': false, 'Duyệt': true, 'Xuất': true},
    'Báo cáo': {'Xem': true, 'Thêm': false, 'Sửa': false, 'Xóa': false, 'Duyệt': false, 'Xuất': true},
    'Hệ thống': {'Xem': false, 'Thêm': false, 'Sửa': false, 'Xóa': false, 'Duyệt': false, 'Xuất': false},
  }),
  MockRole(id: 'r4', name: 'Nhân viên', description: 'Quyền cơ bản', userCount: 1200, permissions: {
    'Core HR': {'Xem': true, 'Thêm': false, 'Sửa': false, 'Xóa': false, 'Duyệt': false, 'Xuất': false},
    'Tuyển dụng': {'Xem': false, 'Thêm': false, 'Sửa': false, 'Xóa': false, 'Duyệt': false, 'Xuất': false},
    'Chấm công': {'Xem': true, 'Thêm': true, 'Sửa': false, 'Xóa': false, 'Duyệt': false, 'Xuất': false},
    'Tính lương': {'Xem': true, 'Thêm': false, 'Sửa': false, 'Xóa': false, 'Duyệt': false, 'Xuất': false},
    'Dự án': {'Xem': true, 'Thêm': false, 'Sửa': false, 'Xóa': false, 'Duyệt': false, 'Xuất': false},
    'Báo cáo': {'Xem': false, 'Thêm': false, 'Sửa': false, 'Xóa': false, 'Duyệt': false, 'Xuất': false},
    'Hệ thống': {'Xem': false, 'Thêm': false, 'Sửa': false, 'Xóa': false, 'Duyệt': false, 'Xuất': false},
  }),
];

const List<AuditLogEntry> mockAuditLogs = [
  AuditLogEntry(user: 'admin@hrm.vn', action: 'Cập nhật quyền', target: 'Role: Trưởng phòng', ip: '192.168.1.100', timestamp: '06/05/2026 09:45:12', type: 'update'),
  AuditLogEntry(user: 'hr.manager@hrm.vn', action: 'Thêm nhân viên mới', target: 'NV: Nguyễn Thị Lan', ip: '192.168.1.105', timestamp: '06/05/2026 09:30:08', type: 'create'),
  AuditLogEntry(user: 'admin@hrm.vn', action: 'Xóa tài khoản', target: 'User: test_account', ip: '192.168.1.100', timestamp: '06/05/2026 09:15:22', type: 'delete'),
  AuditLogEntry(user: 'director@hrm.vn', action: 'Đăng nhập hệ thống', target: 'Portal: Admin', ip: '10.0.0.50', timestamp: '06/05/2026 08:55:00', type: 'login'),
  AuditLogEntry(user: 'hr.manager@hrm.vn', action: 'Duyệt nghỉ phép', target: 'NV: Trần Văn Bình - 3 ngày', ip: '192.168.1.105', timestamp: '06/05/2026 08:42:30', type: 'update'),
  AuditLogEntry(user: 'admin@hrm.vn', action: 'Áp dụng chính sách', target: 'Policy: Quy chế lương 2026', ip: '192.168.1.100', timestamp: '05/05/2026 17:30:00', type: 'create'),
];
