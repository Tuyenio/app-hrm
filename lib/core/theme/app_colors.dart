import 'package:flutter/material.dart';
import 'theme_provider.dart';

/// ============================================================================
/// HRM DESIGN SYSTEM - COLOR PALETTE
/// Supports Light & Dark mode with dynamic accent colors.
/// Use AppColors.of(context) for theme-aware colors.
/// Static constants remain for backward compatibility.
/// ============================================================================
class AppColors {
  AppColors._();

  // ── Static fallback (Light mode, Blue accent) ─────────────────────────────
  static const Color primary = Color(0xFF0F4C81);
  static const Color primaryLight = Color(0xFF1A73E8);
  static const Color primaryDark = Color(0xFF0A3560);
  static const Color primarySurface = Color(0xFFE8F0FE);

  // ── Background & Surface ─────────────────────────────────────────────────
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

  // ══════════════════════════════════════════════════════════════════════════
  // DYNAMIC THEME-AWARE COLOR RESOLVER
  // ══════════════════════════════════════════════════════════════════════════
  static _DynamicColors of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    // Try to get accent from provider, fallback to default
    AccentColorPreset accent;
    try {
      accent = ThemeProvider.stateOf(context).accent;
    } catch (_) {
      accent = accentPresets[0]; // Default blue
    }

    return isDark ? _DynamicColors.dark(accent) : _DynamicColors.light(accent);
  }
}

/// Dynamic color set resolved per-theme
class _DynamicColors {
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color primarySurface;
  final Color success;
  final Color successLight;
  final Color warning;
  final Color warningLight;
  final Color error;
  final Color errorLight;
  final Color info;
  final Color infoLight;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color divider;
  final Color border;
  final Color borderLight;
  final Color chatBubbleReceived;
  final Color chatInputBg;
  final Color sidebarBg;
  final Color sidebarItemActive;
  final Color sidebarText;
  final Color sidebarDivider;

  const _DynamicColors({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.primarySurface,
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningLight,
    required this.error,
    required this.errorLight,
    required this.info,
    required this.infoLight,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.divider,
    required this.border,
    required this.borderLight,
    required this.chatBubbleReceived,
    required this.chatInputBg,
    required this.sidebarBg,
    required this.sidebarItemActive,
    required this.sidebarText,
    required this.sidebarDivider,
  });

  factory _DynamicColors.light(AccentColorPreset accent) {
    return _DynamicColors(
      primary: accent.primary,
      primaryLight: accent.primaryLight,
      primaryDark: accent.primaryDark,
      primarySurface: accent.primarySurface,
      success: const Color(0xFF10B981),
      successLight: const Color(0xFFD1FAE5),
      warning: const Color(0xFFF59E0B),
      warningLight: const Color(0xFFFEF3C7),
      error: const Color(0xFFEF4444),
      errorLight: const Color(0xFFFEE2E2),
      info: const Color(0xFF3B82F6),
      infoLight: const Color(0xFFDBEAFE),
      background: const Color(0xFFF8F9FA),
      surface: const Color(0xFFFFFFFF),
      surfaceVariant: const Color(0xFFF1F3F4),
      surfaceElevated: const Color(0xFFFFFFFE),
      textPrimary: const Color(0xFF1F2937),
      textSecondary: const Color(0xFF6B7280),
      textTertiary: const Color(0xFF9CA3AF),
      divider: const Color(0xFFE5E7EB),
      border: const Color(0xFFD1D5DB),
      borderLight: const Color(0xFFE5E7EB),
      chatBubbleReceived: const Color(0xFFF1F3F4),
      chatInputBg: const Color(0xFFF8F9FA),
      sidebarBg: const Color(0xFF111827),
      sidebarItemActive: Color.alphaBlend(
        accent.primary.withValues(alpha: 0.3),
        const Color(0xFF111827),
      ),
      sidebarText: const Color(0xFF9CA3AF),
      sidebarDivider: const Color(0xFF374151),
    );
  }

  factory _DynamicColors.dark(AccentColorPreset accent) {
    return _DynamicColors(
      primary: accent.primaryLight, // Lighter variant for contrast
      primaryLight: accent.primaryLight,
      primaryDark: accent.primary,
      primarySurface: Color.alphaBlend(
        accent.primary.withValues(alpha: 0.15),
        const Color(0xFF1A1A2E),
      ),
      success: const Color(0xFF10B981),
      successLight: const Color(0xFFD1FAE5),
      warning: const Color(0xFFF59E0B),
      warningLight: const Color(0xFFFEF3C7),
      error: const Color(0xFFEF4444),
      errorLight: const Color(0xFFFEE2E2),
      info: const Color(0xFF3B82F6),
      infoLight: const Color(0xFFDBEAFE),
      background: const Color(0xFF0D1117),
      surface: const Color(0xFF161B22),
      surfaceVariant: const Color(0xFF21262D),
      surfaceElevated: const Color(0xFF1C2128),
      textPrimary: const Color(0xFFF0F6FC),
      textSecondary: const Color(0xFF8B949E),
      textTertiary: const Color(0xFF6E7681),
      divider: const Color(0xFF30363D),
      border: const Color(0xFF30363D),
      borderLight: const Color(0xFF21262D),
      chatBubbleReceived: const Color(0xFF21262D),
      chatInputBg: const Color(0xFF0D1117),
      sidebarBg: const Color(0xFF010409),
      sidebarItemActive: Color.alphaBlend(
        accent.primaryLight.withValues(alpha: 0.2),
        const Color(0xFF010409),
      ),
      sidebarText: const Color(0xFF8B949E),
      sidebarDivider: const Color(0xFF30363D),
    );
  }
}
