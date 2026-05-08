import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'theme_provider.dart';

/// ============================================================================
/// HRM DESIGN SYSTEM - THEME DATA
/// Supports Light + Dark mode with dynamic accent color.
/// ============================================================================
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => buildTheme(Brightness.light, accentPresets[0]);
  static ThemeData get darkTheme => buildTheme(Brightness.dark, accentPresets[0]);

  static ThemeData buildTheme(Brightness brightness, AccentColorPreset accent) {
    final isDark = brightness == Brightness.dark;

    // Colors
    final primary = isDark ? accent.primaryLight : accent.primary;
    final bg = isDark ? const Color(0xFF0D1117) : const Color(0xFFF8F9FA);
    final surface = isDark ? const Color(0xFF161B22) : const Color(0xFFFFFFFF);
    final surfaceVariant = isDark ? const Color(0xFF21262D) : const Color(0xFFF1F3F4);
    final textPrimary = isDark ? const Color(0xFFF0F6FC) : const Color(0xFF1F2937);
    final textSecondary = isDark ? const Color(0xFF8B949E) : const Color(0xFF6B7280);
    final textTertiary = isDark ? const Color(0xFF6E7681) : const Color(0xFF9CA3AF);
    final borderColor = isDark ? const Color(0xFF30363D) : const Color(0xFFD1D5DB);
    final borderLight = isDark ? const Color(0xFF21262D) : const Color(0xFFE5E7EB);
    final divider = isDark ? const Color(0xFF30363D) : const Color(0xFFE5E7EB);
    final primarySurface = isDark
        ? Color.alphaBlend(accent.primary.withValues(alpha: 0.15), const Color(0xFF1A1A2E))
        : accent.primarySurface;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: primarySurface,
        secondary: accent.primaryLight,
        onSecondary: Colors.white,
        surface: surface,
        onSurface: textPrimary,
        error: AppColors.error,
        onError: Colors.white,
        outline: borderColor,
      ),
      scaffoldBackgroundColor: bg,
      textTheme: GoogleFonts.interTextTheme(
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: divider,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: accent.primaryLight, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: textTertiary),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return Colors.transparent;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(color: borderColor, width: 1.5),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return isDark ? const Color(0xFF6E7681) : const Color(0xFF9CA3AF);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary.withValues(alpha: 0.4);
          return isDark ? const Color(0xFF30363D) : const Color(0xFFE5E7EB);
        }),
      ),
      dividerTheme: DividerThemeData(color: divider, thickness: 1, space: 1),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(fillColor: surfaceVariant),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return textTertiary;
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? const Color(0xFF21262D) : null,
        contentTextStyle: GoogleFonts.inter(color: Colors.white),
      ),
    );
  }
}
