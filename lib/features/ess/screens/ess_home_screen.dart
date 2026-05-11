import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../core/widgets/interactive_overlays.dart';
import '../../../data/mock/employee_data.dart';
import '../../tasks/screens/task_workspace_screen.dart';

/// ============================================================================
/// ESS HOME SCREEN - Cổng nhân viên (Mobile-first)
/// Thiết kế consumer-grade, friendly, modern.
/// UPDATED: StatefulWidget, task tap navigation, InkWell ripple effects.
/// ============================================================================
class EssHomeScreen extends StatefulWidget {
  const EssHomeScreen({super.key});

  @override
  State<EssHomeScreen> createState() => _EssHomeScreenState();
}

class _EssHomeScreenState extends State<EssHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingHeader(context),
              _buildClockInOut(context),
              _buildQuickActions(context),
              _buildMyTasks(context),
              _buildAttendanceCard(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingHeader(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const UserAvatar(
                initials: 'NMT',
                size: 46,
                backgroundColor: Color(0x44FFFFFF),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xin chào! 👋',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      currentUser.name,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              _buildNotificationButton(context),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _infoChip(Icons.business_rounded, currentUser.department),
              const SizedBox(width: 8),
              _infoChip(Icons.badge_outlined, currentUser.position),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return GestureDetector(
      onTap: () => showNotificationCenter(context),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white70),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClockInOut(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.success, Color(0xFF059669)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.fingerprint_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chấm công hôm nay',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.login_rounded,
                        size: 14,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Vào: 08:02',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: colors.textTertiary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'Trụ sở HN',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => showHrmSuccessSnackbar(
                context,
                'Chấm công ra lúc ${TimeOfDay.now().format(context)}',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error.withValues(alpha: 0.1),
                foregroundColor: AppColors.error,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.logout_rounded, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Ra',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
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

  Widget _buildQuickActions(BuildContext context) {
    final colors = AppColors.of(context);
    final actions = [
      (
        Icons.event_note_rounded,
        'Xin nghỉ\nphép',
        colors.primaryLight,
        'leave',
      ),
      (Icons.access_time_rounded, 'Đăng ký\nOT', AppColors.warning, 'ot'),
      (
        Icons.calendar_month_rounded,
        'Xem\nchấm công',
        AppColors.success,
        'attendance',
      ),
      (
        Icons.assignment_turned_in_rounded,
        'Công việc\ncủa tôi',
        AppColors.info,
        'mytask',
      ),
      (
        Icons.headset_mic_rounded,
        'HR\nHelpdesk',
        const Color(0xFF8B5CF6),
        'helpdesk',
      ),
      (
        Icons.campaign_rounded,
        'Thông báo\nnội bộ',
        const Color(0xFFEC4899),
        'announcement',
      ),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thao tác nhanh',
            style: AppTextStyles.headlineSmall.copyWith(
              fontSize: 16,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            itemCount: actions.length,
            itemBuilder: (context, i) {
              final a = actions[i];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _handleQuickAction(context, a.$4),
                  borderRadius: BorderRadius.circular(14),
                  splashColor: a.$3.withValues(alpha: 0.15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.borderLight),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: a.$3.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(a.$1, color: a.$3, size: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          a.$2,
                          style: AppTextStyles.labelSmall.copyWith(
                            fontSize: 10,
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// UPDATED: Tasks are now tappable and navigate to detail view
  Widget _buildMyTasks(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Công việc hôm nay',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontSize: 16,
                  color: colors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${mockEssTasks.length} tasks',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(mockEssTasks.length, (index) {
            final task = mockEssTasks[index];
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showEssTaskDetail(context, task),
                borderRadius: BorderRadius.circular(12),
                splashColor: colors.primary.withValues(alpha: 0.08),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: task.isOverdue
                          ? AppColors.error.withValues(alpha: 0.3)
                          : colors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: task.progress,
                              strokeWidth: 3,
                              backgroundColor: colors.surfaceVariant,
                              valueColor: AlwaysStoppedAnimation(
                                task.isOverdue
                                    ? AppColors.error
                                    : colors.primaryLight,
                              ),
                            ),
                            Text(
                              '${(task.progress * 100).toInt()}%',
                              style: AppTextStyles.labelSmall.copyWith(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: AppTextStyles.titleSmall.copyWith(
                                fontSize: 13,
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              task.project,
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 11,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: task.isOverdue
                              ? AppColors.errorLight
                              : colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          task.dueDate,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: task.isOverdue
                                ? AppColors.error
                                : colors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: colors.textTertiary,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// ESS Task Detail bottom sheet - provides detailed view of a specific task
  void _showEssTaskDetail(BuildContext context, EssTask task) {
    final colors = AppColors.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            (task.isOverdue
                                    ? AppColors.error
                                    : AppColors.primary)
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        task.isOverdue
                            ? Icons.warning_rounded
                            : Icons.task_alt_rounded,
                        color: task.isOverdue
                            ? AppColors.error
                            : AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chi tiết công việc',
                            style: AppTextStyles.headlineSmall.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            task.project,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        task.title,
                        style: AppTextStyles.headlineMedium.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Status chips
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: task.isOverdue
                                  ? AppColors.errorLight
                                  : AppColors.successLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              task.isOverdue ? 'Quá hạn' : 'Đúng tiến độ',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: task.isOverdue
                                    ? AppColors.error
                                    : AppColors.success,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              task.dueDate,
                              style: AppTextStyles.labelSmall.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Progress
                      Text(
                        'Tiến độ hoàn thành',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: task.progress,
                                backgroundColor: AppColors.surfaceVariant,
                                valueColor: AlwaysStoppedAnimation(
                                  task.isOverdue
                                      ? AppColors.error
                                      : AppColors.primaryLight,
                                ),
                                minHeight: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${(task.progress * 100).toInt()}%',
                            style: AppTextStyles.titleSmall.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      // Info rows
                      _detailRow(Icons.folder_outlined, 'Dự án', task.project),
                      _detailRow(
                        Icons.calendar_today_rounded,
                        'Hạn chót',
                        task.dueDate,
                      ),
                      _detailRow(
                        Icons.person_outline_rounded,
                        'Phụ trách',
                        currentUser.name,
                      ),
                      _detailRow(
                        Icons.business_rounded,
                        'Phòng ban',
                        currentUser.department,
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                showHrmSuccessSnackbar(
                                  context,
                                  'Đang cập nhật tiến độ...',
                                );
                              },
                              icon: const Icon(Icons.edit_rounded, size: 16),
                              label: const Text('Cập nhật tại chỗ'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                showHrmSuccessSnackbar(
                                  context,
                                  'Đã đánh dấu hoàn thành ✅',
                                );
                              },
                              icon: const Icon(Icons.check_rounded, size: 16),
                              label: const Text('Hoàn thành'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const TaskWorkspaceScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.open_in_new_rounded, size: 16),
                          label: const Text('Mở trong Dự án & Công việc'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context) {
    final colors = AppColors.of(context);
    final days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    final statuses = ['on', 'on', 'on', 'late', 'on', 'off', 'off'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chấm công tuần này',
            style: AppTextStyles.headlineSmall.copyWith(
              fontSize: 16,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.borderLight),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (i) {
                    final isToday = i == 1;
                    final color = statuses[i] == 'on'
                        ? AppColors.success
                        : statuses[i] == 'late'
                        ? AppColors.warning
                        : colors.textTertiary;
                    return Column(
                      children: [
                        Text(
                          days[i],
                          style: AppTextStyles.labelSmall.copyWith(
                            fontSize: 10,
                            color: isToday
                                ? colors.primary
                                : colors.textSecondary,
                            fontWeight: isToday
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: statuses[i] == 'off'
                                ? colors.surfaceVariant
                                : color.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            border: isToday
                                ? Border.all(color: colors.primary, width: 2)
                                : null,
                          ),
                          child: Icon(
                            statuses[i] == 'on'
                                ? Icons.check_rounded
                                : statuses[i] == 'late'
                                ? Icons.schedule_rounded
                                : Icons.remove_rounded,
                            size: 16,
                            color: color,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _attendanceStat('Đúng giờ', '5', AppColors.success, colors),
                    _attendanceStat('Đi muộn', '1', AppColors.warning, colors),
                    _attendanceStat('Nghỉ', '0', AppColors.error, colors),
                    _attendanceStat('Tổng giờ', '42h', colors.primary, colors),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendanceStat(
    String label,
    String value,
    Color color,
    dynamic colors,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.titleLarge.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            fontSize: 9,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _handleQuickAction(BuildContext context, String action) {
    final colors = AppColors.of(context);
    switch (action) {
      case 'leave':
        _showLeaveRequestSheet(context, colors);
        break;
      case 'ot':
        _showOtRegistrationSheet(context, colors);
        break;
      case 'attendance':
        showHrmSuccessSnackbar(context, 'Đang mở bảng chấm công...');
        break;
      case 'mytask':
        showHrmSuccessSnackbar(context, 'Đang chuyển đến Dự án & Công việc...');
        break;
      case 'helpdesk':
        _showHelpdeskSheet(context, colors);
        break;
      case 'announcement':
        _showAnnouncementSheet(context, colors);
        break;
    }
  }

  void _showLeaveRequestSheet(BuildContext context, dynamic colors) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.75,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Xin nghỉ phép',
              style: AppTextStyles.headlineSmall.copyWith(
                fontSize: 18,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loại nghỉ *',
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
                  value: 'Nghỉ phép năm',
                  dropdownColor: colors.surface,
                  items:
                      [
                            'Nghỉ phép năm',
                            'Nghỉ ốm',
                            'Nghỉ không lương',
                            'Nghỉ đặc biệt',
                          ]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (_) {},
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Từ ngày - Đến ngày *',
              style: AppTextStyles.labelLarge.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const TextField(
              decoration: InputDecoration(
                hintText: '06/05/2026 - 07/05/2026',
                prefixIcon: Icon(Icons.calendar_today_rounded, size: 18),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Lý do *',
              style: AppTextStyles.labelLarge.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(hintText: 'Nhập lý do xin nghỉ...'),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      showHrmSuccessSnackbar(
                        context,
                        'Đã gửi đơn xin nghỉ phép',
                      );
                    },
                    child: const Text('Gửi đơn'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOtRegistrationSheet(BuildContext context, dynamic colors) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.65,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Đăng ký OT',
              style: AppTextStyles.headlineSmall.copyWith(
                fontSize: 18,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ngày OT *',
              style: AppTextStyles.labelLarge.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const TextField(
              decoration: InputDecoration(
                hintText: '06/05/2026',
                prefixIcon: Icon(Icons.calendar_today_rounded, size: 18),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Giờ OT *',
              style: AppTextStyles.labelLarge.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const TextField(
              decoration: InputDecoration(
                hintText: '18:00 - 21:00',
                prefixIcon: Icon(Icons.access_time_rounded, size: 18),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Lý do *',
              style: AppTextStyles.labelLarge.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const TextField(
              maxLines: 2,
              decoration: InputDecoration(hintText: 'Lý do làm OT...'),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      showHrmSuccessSnackbar(context, 'Đã gửi đăng ký OT');
                    },
                    child: const Text('Gửi đăng ký'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpdeskSheet(BuildContext context, dynamic colors) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
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
                  color: colors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'HR Helpdesk',
              style: AppTextStyles.headlineSmall.copyWith(
                fontSize: 18,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _helpdeskItem(
              Icons.phone_rounded,
              'Hotline HR',
              '1900-xxxx',
              AppColors.success,
              colors,
              () => showHrmSuccessSnackbar(ctx, 'Đang gọi Hotline...'),
            ),
            _helpdeskItem(
              Icons.email_rounded,
              'Email HR',
              'hr@company.vn',
              AppColors.info,
              colors,
              () => showHrmSuccessSnackbar(ctx, 'Đang mở email...'),
            ),
            _helpdeskItem(
              Icons.chat_rounded,
              'Zalo HR',
              'zalo.me/hr',
              const Color(0xFF0068FF),
              colors,
              () => showHrmSuccessSnackbar(ctx, 'Đang mở Zalo...'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _helpdeskItem(
    IconData icon,
    String title,
    String sub,
    Color color,
    dynamic colors,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: AppTextStyles.titleSmall.copyWith(color: colors.textPrimary),
      ),
      subtitle: Text(
        sub,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 11,
          color: colors.textSecondary,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: colors.textTertiary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _showAnnouncementSheet(BuildContext context, dynamic colors) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Thông báo nội bộ',
              style: AppTextStyles.headlineSmall.copyWith(
                fontSize: 18,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _announcementItem(
                    '🎉 Team building Q2/2026',
                    'Đăng ký tham gia trước 10/05',
                    '06/05',
                    colors,
                  ),
                  _announcementItem(
                    '📋 Cập nhật chính sách OT',
                    'Áp dụng từ tháng 06/2026',
                    '05/05',
                    colors,
                  ),
                  _announcementItem(
                    '🔧 Bảo trì hệ thống',
                    'Ngày 08/05, 22:00 - 02:00',
                    '04/05',
                    colors,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _announcementItem(
    String title,
    String sub,
    String date,
    dynamic colors,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontSize: 13,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 11,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 10,
              color: colors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colors.textTertiary),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
