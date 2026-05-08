import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/navigation/side_navigation.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/tasks/screens/task_workspace_screen.dart';
import 'features/security/screens/security_matrix_screen.dart';
import 'features/employees/screens/employee_list_screen.dart';
import 'features/performance/screens/performance_screen.dart';
import 'features/ess/screens/ess_home_screen.dart';
import 'features/chat/screens/chat_list_screen.dart';
import 'features/departments/screens/department_management_screen.dart';
import 'features/settings/screens/system_settings_screen.dart';

/// ============================================================================
/// ICS HRM - ENTERPRISE SUITE
/// Entry point chính của hệ thống Quản trị Nhân sự Doanh nghiệp.
/// Tích hợp Auth flow + MainShell (Admin + ESS).
/// ============================================================================

final ThemeNotifier _themeNotifier = ThemeNotifier();

void main() {
  runApp(const HrmApp());
}

class HrmApp extends StatelessWidget {
  const HrmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      notifier: _themeNotifier,
      child: ValueListenableBuilder<ThemeState>(
        valueListenable: _themeNotifier,
        builder: (context, themeState, _) {
          return MaterialApp(
            title: 'ICS HRM - Enterprise Suite',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.buildTheme(Brightness.light, themeState.accent),
            darkTheme: AppTheme.buildTheme(Brightness.dark, themeState.accent),
            themeMode: themeState.themeMode,
            home: const SplashGate(),
          );
        },
      ),
    );
  }
}

/// ============================================================================
/// SPLASH GATE - Đồng bộ launch/splash screen với logo mới
/// ============================================================================
class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF060D18), Color(0xFF0A1F39), Color(0xFF1A73E8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -90,
              right: -70,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF5FCBFF).withValues(alpha: 0.16),
                ),
              ),
            ),
            Positioned(
              bottom: -120,
              left: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1A73E8).withValues(alpha: 0.14),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 122,
                    height: 122,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.22),
                          blurRadius: 36,
                          offset: const Offset(0, 16),
                        ),
                        BoxShadow(
                          color: const Color(
                            0xFF5FCBFF,
                          ).withValues(alpha: 0.28),
                          blurRadius: 44,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/branding/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'ICS HRM',
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Enterprise Human Resource Management',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// AUTH WRAPPER - Quản lý trạng thái đăng nhập
/// ============================================================================
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return LoginScreen(
        onLoginSuccess: () => setState(() => _isLoggedIn = true),
      );
    }
    return MainShell(onLogout: () => setState(() => _isLoggedIn = false));
  }
}

/// ============================================================================
/// MAIN SHELL - Layout chính với Sidebar + Content Area
/// Responsive: Sidebar navigation (desktop) / Bottom nav (mobile)
/// 7 modules: Dashboard, Tasks, Security, Employees, Performance, ESS, Chat
/// ============================================================================
class MainShell extends StatefulWidget {
  final VoidCallback onLogout;
  const MainShell({super.key, required this.onLogout});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  bool _sidebarCollapsed = false;

  // 9 screens tương ứng navigation
  static const List<Widget> _screens = [
    DashboardScreen(), // 0: Dashboard
    TaskWorkspaceScreen(), // 1: Dự án & Công việc
    SecurityMatrixScreen(), // 2: Phân quyền
    EmployeeListScreen(), // 3: Nhân sự
    PerformanceScreen(), // 4: Hiệu suất
    DepartmentManagementScreen(), // 5: Phòng ban
    SystemSettingsScreen(), // 6: Cài đặt
    EssHomeScreen(), // 7: Cổng NV (ESS)
    ChatListScreen(), // 8: Chat
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    // Mobile: dùng Bottom Navigation Bar
    if (isMobile) {
      return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: _buildBottomNav(),
      );
    }

    // Desktop/Tablet: dùng Sidebar
    return Scaffold(
      body: Row(
        children: [
          _buildDesktopSidebar(),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }

  /// Desktop Sidebar - 7 modules + logout
  Widget _buildDesktopSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: _sidebarCollapsed ? 72 : 260,
      decoration: const BoxDecoration(color: AppColors.sidebarBg),
      child: Column(
        children: [
          // Logo Header
          Container(
            height: 64,
            padding: EdgeInsets.symmetric(
              horizontal: _sidebarCollapsed ? 16 : 20,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Image.asset(
                    'assets/branding/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                if (!_sidebarCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ICS HRM',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          'Enterprise Suite',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.sidebarText,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        setState(() => _sidebarCollapsed = !_sidebarCollapsed),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.menu_open_rounded,
                        color: AppColors.sidebarText,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Nav items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              children: List.generate(
                _navItems.length,
                (i) => _buildSideNavItem(i),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              color: AppColors.sidebarDivider.withValues(alpha: 0.5),
              height: 1,
            ),
          ),
          // Logout button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onLogout,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: _sidebarCollapsed ? 12 : 14,
                    vertical: 11,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.logout_rounded,
                        color: AppColors.error,
                        size: 20,
                      ),
                      if (!_sidebarCollapsed) ...[
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Đăng xuất',
                            style: AppTextStyles.titleSmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSideNavItem(int index) {
    final item = _navItems[index];
    final isSelected = index == _selectedIndex;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () => setState(() => _selectedIndex = index),
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: _sidebarCollapsed ? 12 : 14,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.sidebarItemActive
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? item.activeIcon : item.icon,
                  color: isSelected ? Colors.white : AppColors.sidebarText,
                  size: 22,
                ),
                if (!_sidebarCollapsed) ...[
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      item.label,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.sidebarText,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Badge cho Chat
                  if (index == 8)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '4',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Bottom Navigation Bar cho mobile (5 items max)
  Widget _buildBottomNav() {
    // Mobile chỉ hiển thị 5 tab chính, thêm "More" cho 2 tab còn lại
    final mobileItems = [
      (0, Icons.dashboard_outlined, Icons.dashboard_rounded, 'Home'),
      (1, Icons.task_alt_outlined, Icons.task_alt_rounded, 'Dự án'),
      (7, Icons.person_outline_rounded, Icons.person_rounded, 'ESS'),
      (8, Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, 'Chat'),
    ];

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: isDark ? const Color(0xFF30363D) : AppColors.divider)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...mobileItems.map((item) {
                final isSelected = _selectedIndex == item.$1;
                return _buildBottomNavItem(
                  item.$1,
                  isSelected ? item.$3 : item.$2,
                  item.$4,
                  isSelected,
                  item.$1 == 8,
                );
              }),
              // More button
              _buildMoreButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
    int index,
    IconData icon,
    String label,
    bool isSelected,
    bool showBadge,
  ) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final unselected = theme.brightness == Brightness.dark ? const Color(0xFF6E7681) : AppColors.textTertiary;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Icon(icon, size: 22, color: isSelected ? primaryColor : unselected),
                if (showBadge)
                  Positioned(
                    right: -4, top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colorScheme.surface, width: 1.5),
                      ),
                      child: const Text('4', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected ? primaryColor : unselected,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreButton() {
    final isMoreSelected =
        _selectedIndex == 2 || _selectedIndex == 3 || _selectedIndex == 4 || _selectedIndex == 5 || _selectedIndex == 6;
    return InkWell(
      onTap: () => _showMoreMenu(),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMoreSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.more_horiz_rounded,
              size: 22,
              color: isMoreSelected
                  ? Theme.of(context).colorScheme.primary
                  : (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF6E7681) : AppColors.textTertiary),
            ),
            const SizedBox(height: 2),
            Text(
              'Thêm',
              style: AppTextStyles.labelSmall.copyWith(
                color: isMoreSelected
                    ? Theme.of(context).colorScheme.primary
                    : (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF6E7681) : AppColors.textTertiary),
                fontWeight: isMoreSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: SingleChildScrollView(
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
                const SizedBox(height: 16),
                Text(
                  'Quản trị',
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                _moreMenuItem(
                  2,
                  Icons.admin_panel_settings_rounded,
                  'Phân quyền',
                  'Ma trận quyền hệ thống',
                ),
                _moreMenuItem(
                  3,
                  Icons.people_rounded,
                  'Nhân sự',
                  'Quản lý hồ sơ nhân viên',
                ),
                _moreMenuItem(
                  4,
                  Icons.assessment_rounded,
                  'Hiệu suất',
                  'KPIs, OKRs & đánh giá',
                ),
                _moreMenuItem(
                  5,
                  Icons.business_rounded,
                  'Phòng ban',
                  'Quản lý cơ cấu tổ chức',
                ),
                _moreMenuItem(
                  6,
                  Icons.settings_rounded,
                  'Cài đặt',
                  'Cấu hình hệ thống',
                ),
                const Divider(height: 20),
                _moreMenuItem(
                  -1,
                  Icons.logout_rounded,
                  'Đăng xuất',
                  'Thoát khỏi hệ thống',
                  color: AppColors.error,
                  onTap: () {
                    Navigator.pop(context);
                    widget.onLogout();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _moreMenuItem(
    int index,
    IconData icon,
    String label,
    String sub, {
    Color? color,
    VoidCallback? onTap,
  }) {
    final isSelected = index == _selectedIndex;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? AppColors.primary).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color:
              color ??
              (isSelected ? AppColors.primary : AppColors.textSecondary),
        ),
      ),
      title: Text(
        label,
        style: AppTextStyles.titleSmall.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: color,
        ),
      ),
      subtitle: Text(
        sub,
        style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_rounded, color: AppColors.primary, size: 20)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: isSelected ? AppColors.primarySurface : null,
      onTap:
          onTap ??
          () {
            setState(() => _selectedIndex = index);
            Navigator.pop(context);
          },
    );
  }

  /// Nav items cho cả sidebar và bottom nav
  static const List<NavItem> _navItems = [
    NavItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard_rounded,
    ),
    NavItem(
      label: 'Dự án & Công việc',
      icon: Icons.task_alt_outlined,
      activeIcon: Icons.task_alt_rounded,
    ),
    NavItem(
      label: 'Phân quyền',
      icon: Icons.admin_panel_settings_outlined,
      activeIcon: Icons.admin_panel_settings_rounded,
    ),
    NavItem(
      label: 'Nhân sự',
      icon: Icons.people_outline_rounded,
      activeIcon: Icons.people_rounded,
    ),
    NavItem(
      label: 'Hiệu suất',
      icon: Icons.assessment_outlined,
      activeIcon: Icons.assessment_rounded,
    ),
    NavItem(
      label: 'Phòng ban',
      icon: Icons.business_outlined,
      activeIcon: Icons.business_rounded,
    ),
    NavItem(
      label: 'Cài đặt',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
    ),
    NavItem(
      label: 'Cổng NV (ESS)',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
    NavItem(
      label: 'Chat',
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
    ),
  ];
}
