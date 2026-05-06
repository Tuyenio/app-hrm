import 'package:flutter/material.dart';

/// ============================================================================
/// HRM DESIGN SYSTEM - COLOR PALETTE
/// Bảng màu chuyên nghiệp cho hệ thống quản trị nhân sự cấp doanh nghiệp.
/// Thiết kế theo nguyên tắc Corporate Trust + Modern Minimalism.
/// ============================================================================
class AppColors {
  AppColors._();

  // ── Primary Brand Colors ──────────────────────────────────────────────────
  /// Corporate Blue - Màu chủ đạo, tạo cảm giác tin cậy và chuyên nghiệp
  static const Color primary = Color(0xFF0F4C81);
  static const Color primaryLight = Color(0xFF1A73E8);
  static const Color primaryDark = Color(0xFF0A3560);
  static const Color primarySurface = Color(0xFFE8F0FE);

  // ── Background & Surface ─────────────────────────────────────────────────
  /// Off-white background giúp cards nổi bật, tránh mỏi mắt
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F4);
  static const Color surfaceElevated = Color(0xFFFFFFFE);

  // ── Text Colors ───────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Semantic / RAG Status Colors ──────────────────────────────────────────
  /// Red-Amber-Green indicators cho dashboard dự án
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // ── Border & Divider ─────────────────────────────────────────────────────
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFD1D5DB);
  static const Color borderLight = Color(0xFFE5E7EB);

  // ── Chat Colors ───────────────────────────────────────────────────────────
  static const Color chatBubbleSent = Color(0xFF0F4C81);
  static const Color chatBubbleReceived = Color(0xFFF1F3F4);
  static const Color chatInputBg = Color(0xFFF8F9FA);
  static const Color online = Color(0xFF10B981);

  // ── Heatmap Gradient ──────────────────────────────────────────────────────
  static const Color heatmapLow = Color(0xFFD1FAE5);
  static const Color heatmapMedium = Color(0xFFFEF3C7);
  static const Color heatmapHigh = Color(0xFFFECACA);
  static const Color heatmapCritical = Color(0xFFEF4444);

  // ── Priority Colors ───────────────────────────────────────────────────────
  static const Color priorityCritical = Color(0xFFEF4444);
  static const Color priorityHigh = Color(0xFFF97316);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityLow = Color(0xFF10B981);

  // ── Kanban Column Colors ──────────────────────────────────────────────────
  static const Color kanbanTodo = Color(0xFF6B7280);
  static const Color kanbanInProgress = Color(0xFF3B82F6);
  static const Color kanbanReview = Color(0xFFF59E0B);
  static const Color kanbanDone = Color(0xFF10B981);

  // ── Sidebar ───────────────────────────────────────────────────────────────
  static const Color sidebarBg = Color(0xFF111827);
  static const Color sidebarItemActive = Color(0xFF1E3A5F);
  static const Color sidebarText = Color(0xFF9CA3AF);
  static const Color sidebarTextActive = Color(0xFFFFFFFF);
  static const Color sidebarDivider = Color(0xFF374151);
}
