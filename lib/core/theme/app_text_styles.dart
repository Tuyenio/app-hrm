import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ============================================================================
/// HRM DESIGN SYSTEM - TYPOGRAPHY
/// Hệ thống Typography dùng Google Fonts Inter cho tính chuyên nghiệp tối đa.
/// Tuân thủ hierarchy rõ ràng: Display > Headline > Title > Body > Label.
///
/// NOTE: Colors are intentionally omitted so text inherits from ThemeData,
/// ensuring proper dark mode support. Override color via .copyWith() when needed.
/// ============================================================================
class AppTextStyles {
  AppTextStyles._();

  // ── Display - Tiêu đề cực lớn (KPI số liệu) ─────────────────────────────
  static TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  // ── Headline - Tiêu đề trang & section ────────────────────────────────────
  static TextStyle headlineLarge = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static TextStyle headlineMedium = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headlineSmall = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // ── Title - Tiêu đề card, danh sách ───────────────────────────────────────
  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  // ── Body - Nội dung chính ─────────────────────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ── Label / Caption ───────────────────────────────────────────────────────
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // ── Overline - Category label ─────────────────────────────────────────────
  static TextStyle overline = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  // ── Special: KPI Value ────────────────────────────────────────────────────
  static TextStyle kpiValue = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -1,
  );

  static TextStyle kpiLabel = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}
