import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../data/mock/employee_data.dart';

/// ============================================================================
/// ESS HOME SCREEN - Cổng nhân viên (Mobile-first)
/// Thiết kế consumer-grade, friendly, modern.
/// ============================================================================
class EssHomeScreen extends StatelessWidget {
  const EssHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Greeting Header ─────────────────────────────────────
              _buildGreetingHeader(),
              // ── Clock In/Out Button ─────────────────────────────────
              _buildClockInOut(),
              // ── Quick Actions Grid ──────────────────────────────────
              _buildQuickActions(),
              // ── My Tasks Today ──────────────────────────────────────
              _buildMyTasks(),
              // ── E-Payslip ───────────────────────────────────────────
              _buildPayslip(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar
          Row(
            children: [
              const UserAvatar(initials: 'NMT', size: 46, backgroundColor: Color(0x44FFFFFF)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Xin chào! 👋', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
                    Text(currentUser.name, style: AppTextStyles.headlineMedium.copyWith(color: Colors.white, fontSize: 20)),
                  ],
                ),
              ),
              // Notification
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                  ),
                  Positioned(right: 6, top: 6, child: Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(color: AppColors.error, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
                  )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Info chips
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

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white70),
          const SizedBox(width: 5),
          Text(label, style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildClockInOut() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)],
        ),
        child: Row(
          children: [
            // Clock icon with pulse animation effect
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.success, Color(0xFF059669)]),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.success.withValues(alpha: 0.3), blurRadius: 12, spreadRadius: 2)],
              ),
              child: const Icon(Icons.fingerprint_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Chấm công hôm nay', style: AppTextStyles.titleSmall),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.login_rounded, size: 14, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text('Vào: 08:02', style: AppTextStyles.bodySmall.copyWith(color: AppColors.success, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 16),
                      Icon(Icons.location_on_outlined, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 2),
                      Text('Trụ sở HN', style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            // Clock out button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error.withValues(alpha: 0.1),
                foregroundColor: AppColors.error,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.logout_rounded, size: 16),
                  const SizedBox(width: 4),
                  Text('Ra', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      (Icons.event_note_rounded, 'Xin nghỉ\nphép', AppColors.primaryLight),
      (Icons.access_time_rounded, 'Đăng ký\nOT', AppColors.warning),
      (Icons.receipt_long_rounded, 'Xem\nPayslip', AppColors.success),
      (Icons.assignment_turned_in_rounded, 'Công việc\ncủa tôi', AppColors.info),
      (Icons.headset_mic_rounded, 'HR\nHelpdesk', Color(0xFF8B5CF6)),
      (Icons.campaign_rounded, 'Thông báo\nnội bộ', Color(0xFFEC4899)),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thao tác nhanh', style: AppTextStyles.headlineSmall.copyWith(fontSize: 16)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.1,
            ),
            itemCount: actions.length,
            itemBuilder: (context, i) {
              final a = actions[i];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: a.$3.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                          child: Icon(a.$1, color: a.$3, size: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(a.$2, style: AppTextStyles.labelSmall.copyWith(fontSize: 10, color: AppColors.textPrimary, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
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

  Widget _buildMyTasks() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Công việc hôm nay', style: AppTextStyles.headlineSmall.copyWith(fontSize: 16)),
              const Spacer(),
              Text('${mockEssTasks.length} tasks', style: AppTextStyles.bodySmall),
            ],
          ),
          const SizedBox(height: 12),
          ...mockEssTasks.map((task) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: task.isOverdue ? AppColors.error.withValues(alpha: 0.3) : AppColors.borderLight),
            ),
            child: Row(
              children: [
                // Progress circle
                SizedBox(
                  width: 40, height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: task.progress,
                        strokeWidth: 3,
                        backgroundColor: AppColors.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation(task.isOverdue ? AppColors.error : AppColors.primaryLight),
                      ),
                      Text('${(task.progress * 100).toInt()}%', style: AppTextStyles.labelSmall.copyWith(fontSize: 9, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.title, style: AppTextStyles.titleSmall.copyWith(fontSize: 13)),
                      const SizedBox(height: 2),
                      Text(task.project, style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: task.isOverdue ? AppColors.errorLight : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(task.dueDate, style: AppTextStyles.labelSmall.copyWith(
                    color: task.isOverdue ? AppColors.error : AppColors.textSecondary,
                    fontWeight: FontWeight.w600, fontSize: 10,
                  )),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPayslip(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Phiếu lương', style: AppTextStyles.headlineSmall.copyWith(fontSize: 16)),
          const SizedBox(height: 12),
          // E-Payslip card with biometric lock
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0F4C81), Color(0xFF1A5C9E)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showPayslipSheet(context),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Lock icon
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.lock_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('E-Payslip Tháng 04/2026', style: AppTextStyles.titleLarge.copyWith(color: Colors.white, fontSize: 15)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.fingerprint_rounded, size: 16, color: Colors.white60),
                                const SizedBox(width: 6),
                                Flexible(child: Text('Nhấn để mở khóa bằng sinh trắc học', style: AppTextStyles.bodySmall.copyWith(color: Colors.white60, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPayslipSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.receipt_long_rounded, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text('Phiếu Lương Tháng 04/2026', style: AppTextStyles.headlineSmall),
                ],
              ),
            ),
            const Divider(height: 1),
            // Payslip details
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Employee info
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          const UserAvatar(initials: 'NMT', size: 40),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(currentUser.name, style: AppTextStyles.titleSmall),
                              Text('${currentUser.position} • ${currentUser.department}', style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Income section
                    _sectionLabel('THU NHẬP'),
                    ...mockPayslipItems.where((i) => !i.isDeduction).map((item) => _payslipRow(item.label, item.value, false)),
                    const SizedBox(height: 12),
                    // Deduction section
                    _sectionLabel('KHẤU TRỪ'),
                    ...mockPayslipItems.where((i) => i.isDeduction).map((item) => _payslipRow(item.label, item.value, true)),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    // Net salary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('THỰC LÃNH', style: AppTextStyles.titleLarge.copyWith(color: Colors.white, fontSize: 15)),
                          Text('₫29,455,000', style: AppTextStyles.headlineMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                        ],
                      ),
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

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: AppTextStyles.overline.copyWith(color: AppColors.textTertiary, letterSpacing: 1.5)),
          const Expanded(child: Divider(indent: 8)),
        ],
      ),
    );
  }

  Widget _payslipRow(String label, String value, bool isDeduction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
          Text('₫$value', style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: isDeduction ? AppColors.error : AppColors.textPrimary,
          )),
        ],
      ),
    );
  }
}
