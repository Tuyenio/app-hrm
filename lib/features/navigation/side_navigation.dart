import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/user_avatar.dart';

/// ============================================================================
/// SIDEBAR NAVIGATION
/// Navigation chính cho desktop/tablet. Thiết kế dark sidebar premium.
/// ============================================================================

class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

class SideNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  const SideNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.isCollapsed = false,
    required this.onToggleCollapse,
  });

  static const List<NavItem> items = [
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
      label: 'Nhân viên',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
    NavItem(
      label: 'Chat',
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: isCollapsed ? 72 : 260,
      decoration: const BoxDecoration(color: AppColors.sidebarBg),
      child: Column(
        children: [
          // ── Logo/Brand Header ───────────────────────────────────────
          _buildHeader(),
          const SizedBox(height: 8),
          // ── Navigation Items ────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              itemCount: items.length,
              itemBuilder: (context, index) => _buildNavItem(index),
            ),
          ),
          // ── Divider ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              color: AppColors.sidebarDivider.withValues(alpha: 0.5),
              height: 1,
            ),
          ),
          // ── User Profile ────────────────────────────────────────────
          _buildUserProfile(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 16 : 20),
      child: Row(
        children: [
          // Logo icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            padding: const EdgeInsets.all(3),
            child: Image.asset('assets/branding/logo.png', fit: BoxFit.contain),
          ),
          if (!isCollapsed) ...[
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
          ],
          if (!isCollapsed)
            InkWell(
              onTap: onToggleCollapse,
              borderRadius: BorderRadius.circular(8),
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
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = items[index];
    final isSelected = index == selectedIndex;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () => onItemSelected(index),
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 12 : 14,
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
                if (!isCollapsed) ...[
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
                  if (index == 4)
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

  Widget _buildUserProfile() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 16 : 20,
        vertical: 8,
      ),
      child: Row(
        children: [
          const UserAvatar(
            initials: 'AD',
            size: 36,
            showStatus: true,
            isOnline: true,
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin HRM',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'admin@hrm.vn',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.sidebarText,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.settings_outlined,
              color: AppColors.sidebarText,
              size: 18,
            ),
          ],
        ],
      ),
    );
  }
}
