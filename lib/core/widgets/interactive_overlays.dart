import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'user_avatar.dart';

/// ============================================================================
/// HRM INTERACTIVE OVERLAYS - Shared overlay components
/// Notification Center, Confirm Dialog, Context Menu, etc.
/// UPDATED: Stateful notification center, mark-all-read without closing.
/// ============================================================================

// ── NOTIFICATION DATA ────────────────────────────────────────────────────────
class HrmNotification {
  final String title, subtitle, time;
  final IconData icon;
  final Color color;
  final bool isRead;
  const HrmNotification({required this.title, required this.subtitle, required this.time, required this.icon, required this.color, this.isRead = false});
}

const List<HrmNotification> _mockNotifications = [
  HrmNotification(title: 'Task mới được giao', subtitle: 'Thiết kế Database Schema mới - ERP Migration', time: '5 phút trước', icon: Icons.task_alt_rounded, color: AppColors.info),
  HrmNotification(title: 'Đơn nghỉ phép đã duyệt', subtitle: 'Nguyễn Văn An đã duyệt đơn nghỉ 3 ngày', time: '15 phút trước', icon: Icons.check_circle_rounded, color: AppColors.success),
  HrmNotification(title: '@mention trong Chat', subtitle: 'Trần Thị Bình nhắc bạn trong Phòng Công nghệ', time: '30 phút trước', icon: Icons.alternate_email_rounded, color: AppColors.primaryLight),
  HrmNotification(title: 'Deadline sắp đến', subtitle: 'Viết API Endpoints Payroll - còn 1 ngày', time: '1 giờ trước', icon: Icons.warning_rounded, color: AppColors.warning),
  HrmNotification(title: 'PR đã được merge', subtitle: 'PR #245 - Fix OT calculation merged vào develop', time: '2 giờ trước', icon: Icons.merge_rounded, color: AppColors.success, isRead: true),
  HrmNotification(title: 'Hệ thống cập nhật', subtitle: 'Phiên bản 3.2.1 đã được triển khai thành công', time: '3 giờ trước', icon: Icons.system_update_rounded, color: AppColors.textSecondary, isRead: true),
  HrmNotification(title: 'Nhân viên mới', subtitle: 'Cao Thị Lan đã được thêm vào Phòng Design', time: 'Hôm qua', icon: Icons.person_add_rounded, color: AppColors.primary, isRead: true),
  HrmNotification(title: 'Báo cáo KPI tháng 4', subtitle: 'Báo cáo hiệu suất đã sẵn sàng để xem', time: 'Hôm qua', icon: Icons.assessment_rounded, color: AppColors.warning, isRead: true),
];

// ── 1. NOTIFICATION CENTER ───────────────────────────────────────────────────
/// UPDATED: Stateful notification center
/// - "Đọc tất cả" marks all as read WITHOUT closing the sheet
/// - Individual notification tap marks it as read WITHOUT closing
void showNotificationCenter(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        // Stateful read tracking
        final readStates = List<bool>.generate(
          _mockNotifications.length,
          (i) => _mockNotifications[i].isRead,
        );

        return StatefulBuilder(
          builder: (context, setSheetState) {
            final unreadCount = readStates.where((r) => !r).length;
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  _handleBar(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_rounded, size: 22, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text('Thông báo', style: AppTextStyles.headlineSmall.copyWith(fontSize: 18)),
                        if (unreadCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$unreadCount',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                        const Spacer(),
                        TextButton.icon(
                          onPressed: unreadCount > 0
                              ? () {
                                  setSheetState(() {
                                    for (int i = 0; i < readStates.length; i++) {
                                      readStates[i] = true;
                                    }
                                  });
                                }
                              : null,
                          icon: Icon(
                            unreadCount > 0 ? Icons.done_all_rounded : Icons.check_circle_rounded,
                            size: 16,
                          ),
                          label: Text(
                            unreadCount > 0 ? 'Đọc tất cả' : 'Đã đọc hết',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: unreadCount > 0 ? AppColors.primaryLight : AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: _mockNotifications.length,
                      itemBuilder: (context, i) {
                        final n = _mockNotifications[i];
                        final isRead = readStates[i];
                        return _buildStatefulNotificationTile(
                          n,
                          isRead,
                          () {
                            if (!isRead) {
                              setSheetState(() => readStates[i] = true);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ),
  );
}

Widget _buildStatefulNotificationTile(
  HrmNotification n,
  bool isRead,
  VoidCallback onMarkRead,
) {
  return Material(
    color: isRead ? Colors.transparent : AppColors.primarySurface.withValues(alpha: 0.4),
    child: InkWell(
      onTap: onMarkRead,
      splashColor: AppColors.primary.withValues(alpha: 0.08),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.4))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: n.color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(n.icon, size: 20, color: n.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(n.title, style: AppTextStyles.titleSmall.copyWith(fontWeight: isRead ? FontWeight.w500 : FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(n.subtitle, style: AppTextStyles.bodySmall.copyWith(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(n.time, style: AppTextStyles.labelSmall.copyWith(fontSize: 10, color: AppColors.textTertiary)),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: !isRead
                  ? Container(
                      key: const ValueKey('unread'),
                      margin: const EdgeInsets.only(top: 6),
                      width: 8, height: 8,
                      decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                    )
                  : Icon(
                      Icons.check_rounded,
                      key: const ValueKey('read'),
                      size: 16,
                      color: AppColors.success.withValues(alpha: 0.6),
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ── 2. CONFIRM DIALOG ────────────────────────────────────────────────────────
Future<bool?> showHrmConfirmDialog(BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'Xác nhận',
  String cancelText = 'Hủy',
  bool isDanger = false,
  IconData icon = Icons.help_outline_rounded,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (isDanger ? AppColors.error : AppColors.primary).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: isDanger ? AppColors.error : AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTextStyles.headlineSmall.copyWith(fontSize: 17), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(message, style: AppTextStyles.bodySmall.copyWith(fontSize: 13), textAlign: TextAlign.center),
          const SizedBox(height: 20),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(cancelText)),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDanger ? AppColors.error : AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(confirmText),
        ),
      ],
    ),
  );
}

// ── 3. CONTEXT MENU (Zalo/Messenger style) ───────────────────────────────────
void showHrmContextMenu(BuildContext context, {required List<HrmContextMenuItem> items}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _handleBar(),
          const SizedBox(height: 8),
          ...items.map((item) => ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (item.isDanger ? AppColors.error : AppColors.textSecondary).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, size: 20, color: item.isDanger ? AppColors.error : AppColors.textSecondary),
            ),
            title: Text(item.label, style: AppTextStyles.bodyMedium.copyWith(
              color: item.isDanger ? AppColors.error : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            )),
            onTap: () {
              Navigator.pop(context);
              item.onTap();
            },
          )),
        ],
      ),
    ),
  );
}

class HrmContextMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDanger;
  const HrmContextMenuItem({required this.icon, required this.label, required this.onTap, this.isDanger = false});
}

// ── 4. SUCCESS SNACKBAR ──────────────────────────────────────────────────────
void showHrmSuccessSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(children: [
      const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
      const SizedBox(width: 10),
      Expanded(child: Text(message, style: const TextStyle(fontWeight: FontWeight.w500))),
    ]),
    backgroundColor: AppColors.success,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 2),
  ));
}

// ── 5. EXPORT DIALOG ─────────────────────────────────────────────────────────
void showExportDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _handleBar(),
          const SizedBox(height: 12),
          Text('Xuất báo cáo', style: AppTextStyles.headlineSmall.copyWith(fontSize: 18)),
          const SizedBox(height: 4),
          Text('Chọn định dạng xuất', style: AppTextStyles.bodySmall),
          const SizedBox(height: 16),
          _exportOption(context, Icons.table_chart_rounded, 'Excel (.xlsx)', 'Xuất dữ liệu dạng bảng tính', AppColors.success),
          const SizedBox(height: 8),
          _exportOption(context, Icons.picture_as_pdf_rounded, 'PDF (.pdf)', 'Báo cáo đầy đủ có biểu đồ', AppColors.error),
          const SizedBox(height: 8),
          _exportOption(context, Icons.code_rounded, 'CSV (.csv)', 'Dữ liệu thô, dễ xử lý', AppColors.info),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}

Widget _exportOption(BuildContext context, IconData icon, String title, String sub, Color color) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        Navigator.pop(context);
        showHrmSuccessSnackbar(context, 'Đang xuất $title...');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 22, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600)),
                  Text(sub, style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textTertiary),
          ],
        ),
      ),
    ),
  );
}

// ── SHARED HANDLE BAR ────────────────────────────────────────────────────────
Widget _handleBar() {
  return Center(
    child: Container(
      margin: const EdgeInsets.only(top: 10),
      width: 40, height: 4,
      decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
    ),
  );
}
