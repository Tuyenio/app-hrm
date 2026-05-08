import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/interactive_overlays.dart';

/// ============================================================================
/// SYSTEM SETTINGS SCREEN - Cài đặt hệ thống
/// 3 tabs: Thông tin công ty, Tùy chỉnh hệ thống, Cấu hình chấm công
/// NOW: Theme + Accent changes are LIVE via ThemeProvider
/// ============================================================================
class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({super.key});
  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Section 1: Company Info
  final _companyNameCtrl = TextEditingController(text: 'ICS Technology');
  final _companyCodeCtrl = TextEditingController(text: 'ICS-VN');
  final _addressCtrl = TextEditingController(text: 'Tầng 12, Tòa nhà ABC, Cầu Giấy, Hà Nội');
  String _sector = 'Công nghệ thông tin';
  String _businessModel = 'B2B';
  final _formKey = GlobalKey<FormState>();

  // Section 3: Timekeeping
  bool _autoApproveExtraShift = true;
  bool _allowCompanyWifi = true;
  bool _allowLocationWifi = false;
  bool _enableFaceId = true;
  bool _enableRemoteWork = false;
  bool _restrictRegisteredDevice = true;
  bool _autoCheckinConsecutive = false;
  bool _requireTaskCompletion = false;
  bool _alertCheckin = true;
  bool _alertCheckout = true;
  bool _alertLate = true;
  bool _alertEarly = false;
  String _partTimeLateLogic = 'shift';
  String _fullTimeLateLogic = 'shift';
  String _managerEditLogic = 'manager';
  final _gpsWarningCtrl = TextEditingController(text: '200');
  final _gpsStrictCtrl = TextEditingController(text: '500');
  final _maxEarlyCheckinCtrl = TextEditingController(text: '30');
  final _maxLateCheckoutCtrl = TextEditingController(text: '60');
  final _lockPayrollCtrl = TextEditingController(text: '5');
  final _lockWeekCtrl = TextEditingController(text: '3');
  final _maxEditCountCtrl = TextEditingController(text: '3');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _companyNameCtrl.dispose();
    _companyCodeCtrl.dispose();
    _addressCtrl.dispose();
    _gpsWarningCtrl.dispose();
    _gpsStrictCtrl.dispose();
    _maxEarlyCheckinCtrl.dispose();
    _maxLateCheckoutCtrl.dispose();
    _lockPayrollCtrl.dispose();
    _lockWeekCtrl.dispose();
    _maxEditCountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          _buildHeader(context, isDark, colors),
          _buildTabBar(colors),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCompanyInfoTab(colors),
                _buildPreferencesTab(context, isDark, colors),
                _buildTimekeepingTab(colors),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, dynamic colors) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      margin: EdgeInsets.fromLTRB(isMobile ? 16 : 24, 16, isMobile ? 16 : 24, 0),
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1C2128), const Color(0xFF161B22)]
              : [const Color(0xFF374151), const Color(0xFF1F2937)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.settings_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cài đặt Hệ thống', style: AppTextStyles.headlineLarge.copyWith(fontSize: isMobile ? 20 : 24, color: Colors.white)),
                const SizedBox(height: 2),
                Text('Quản lý cấu hình công ty & hệ thống', style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(dynamic colors) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(color: colors.primary, borderRadius: BorderRadius.circular(10)),
        labelColor: Colors.white,
        unselectedLabelColor: colors.textSecondary,
        labelStyle: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle: AppTextStyles.labelMedium.copyWith(fontSize: 11),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.all(3),
        tabs: const [
          Tab(text: 'Công ty', height: 36),
          Tab(text: 'Hệ thống', height: 36),
          Tab(text: 'Chấm công', height: 36),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 1: COMPANY INFO
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildCompanyInfoTab(dynamic colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: GestureDetector(
              onTap: () => showHrmSuccessSnackbar(context, 'Chọn logo công ty...'),
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: colors.primarySurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.primary.withValues(alpha: 0.3), width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_rounded, size: 32, color: colors.primary.withValues(alpha: 0.5)),
                    const SizedBox(height: 4),
                    Text('Logo', style: AppTextStyles.labelSmall.copyWith(color: colors.primary, fontSize: 10)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _formField('Mã công ty', _companyCodeCtrl),
          _formField('Tên công ty *', _companyNameCtrl, required: true),
          _formField('Địa chỉ *', _addressCtrl, required: true, maxLines: 2),
          _dropdownField('Ngành nghề', _sector, ['Công nghệ thông tin', 'Tài chính', 'Giáo dục', 'Y tế', 'Sản xuất'], (v) => setState(() => _sector = v!)),
          _dropdownField('Mô hình kinh doanh', _businessModel, ['B2B', 'B2C', 'B2B2C', 'SaaS'], (v) => setState(() => _businessModel = v!)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () { if (_formKey.currentState!.validate()) showHrmSuccessSnackbar(context, 'Đã lưu thông tin công ty'); },
              icon: const Icon(Icons.save_rounded, size: 18),
              label: const Text('Lưu thông tin'),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _formField(String label, TextEditingController ctrl, {bool required = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: AppTextStyles.labelLarge),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl, maxLines: maxLines,
          validator: required ? (v) => (v == null || v.isEmpty) ? 'Trường này bắt buộc' : null : null,
          decoration: InputDecoration(hintText: 'Nhập $label'),
        ),
      ]),
    );
  }

  Widget _dropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: AppTextStyles.labelLarge),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: colors.surfaceVariant, borderRadius: BorderRadius.circular(8), border: Border.all(color: colors.borderLight)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true, value: value, dropdownColor: colors.surface,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 2: SYSTEM PREFERENCES (LIVE THEME CONTROL)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildPreferencesTab(BuildContext context, bool isDark, dynamic colors) {
    final themeNotifier = ThemeProvider.of(context);
    final state = themeNotifier.value;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Theme Mode ──────────────────────────────────────────────────
        _sectionTitle('Giao diện', Icons.palette_rounded, colors),
        const SizedBox(height: 12),
        Row(children: [
          _themeOption('Sáng', ThemeMode.light, Icons.light_mode_rounded, state.themeMode, colors, themeNotifier),
          const SizedBox(width: 8),
          _themeOption('Tối', ThemeMode.dark, Icons.dark_mode_rounded, state.themeMode, colors, themeNotifier),
          const SizedBox(width: 8),
          _themeOption('Hệ thống', ThemeMode.system, Icons.settings_brightness_rounded, state.themeMode, colors, themeNotifier),
        ]),
        const SizedBox(height: 24),

        // ── Accent Colors ───────────────────────────────────────────────
        _sectionTitle('Màu chủ đạo', Icons.color_lens_rounded, colors),
        const SizedBox(height: 4),
        Text('Chọn gam màu phù hợp phong cách tổ chức', style: AppTextStyles.bodySmall.copyWith(color: colors.textTertiary, fontSize: 11)),
        const SizedBox(height: 14),

        // Accent color grid
        ...List.generate(accentPresets.length, (i) {
          final preset = accentPresets[i];
          final isSelected = i == state.accentIndex;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => themeNotifier.setAccentColor(i),
                borderRadius: BorderRadius.circular(14),
                splashColor: preset.primary.withValues(alpha: 0.1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? preset.primary.withValues(alpha: 0.12) : preset.primarySurface)
                        : colors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? preset.primary : colors.borderLight,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(color: preset.primary.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 4)),
                    ] : null,
                  ),
                  child: Row(
                    children: [
                      // Color swatch
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [preset.primary, preset.primaryLight],
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: preset.primary.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))],
                        ),
                        child: isSelected
                            ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                            : null,
                      ),
                      const SizedBox(width: 14),
                      // Name + color info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              preset.name,
                              style: AppTextStyles.titleSmall.copyWith(
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? preset.primary : colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            // Color chips preview
                            Row(
                              children: [
                                _colorDot(preset.primaryDark),
                                _colorDot(preset.primary),
                                _colorDot(preset.primaryLight),
                                _colorDot(preset.primarySurface),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: preset.primary, borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('Đang dùng', style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontSize: 9)),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 24),
        // ── Language ────────────────────────────────────────────────────
        _sectionTitle('Ngôn ngữ', Icons.language_rounded, colors),
        const SizedBox(height: 12),
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
              value: 'vi',
              dropdownColor: colors.surface,
              items: const [
                DropdownMenuItem(value: 'vi', child: Text('🇻🇳  Tiếng Việt')),
                DropdownMenuItem(value: 'en', child: Text('🇺🇸  English')),
              ],
              onChanged: (_) => showHrmSuccessSnackbar(context, 'Đã chọn ngôn ngữ'),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _colorDot(Color color) {
    return Container(
      width: 14, height: 14,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: color, shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon, dynamic colors) {
    return Row(children: [
      Icon(icon, size: 18, color: colors.primary),
      const SizedBox(width: 8),
      Text(title, style: AppTextStyles.headlineSmall.copyWith(fontSize: 16, color: colors.textPrimary)),
    ]);
  }

  Widget _themeOption(String label, ThemeMode mode, IconData icon, ThemeMode current, dynamic colors, ThemeNotifier notifier) {
    final isSelected = current == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => notifier.setThemeMode(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? colors.primarySurface : colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? colors.primary : colors.borderLight, width: isSelected ? 2 : 1),
          ),
          child: Column(children: [
            Icon(icon, size: 24, color: isSelected ? colors.primary : colors.textSecondary),
            const SizedBox(height: 6),
            Text(label, style: AppTextStyles.labelMedium.copyWith(
              color: isSelected ? colors.primary : colors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            )),
          ]),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 3: TIMEKEEPING CONFIG
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildTimekeepingTab(dynamic colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        _buildConfigCard('Tự động & Phương thức truy cập', Icons.settings_suggest_rounded, colors.primary, colors, [
          _toggleItem('Tự động duyệt ca tăng nếu có chấm công', _autoApproveExtraShift, (v) => setState(() => _autoApproveExtraShift = v), colors),
          _toggleItem('Cho phép chấm công qua WiFi công ty', _allowCompanyWifi, (v) => setState(() => _allowCompanyWifi = v), colors),
          _toggleItem('Cho phép chấm công qua WiFi địa điểm', _allowLocationWifi, (v) => setState(() => _allowLocationWifi = v), colors),
          _toggleItem('Bật chấm công bằng Face ID', _enableFaceId, (v) => setState(() => _enableFaceId = v), colors),
          _toggleItem('Bật chấm công làm việc từ xa', _enableRemoteWork, (v) => setState(() => _enableRemoteWork = v), colors),
          _toggleItem('Chỉ cho phép thiết bị đã đăng ký', _restrictRegisteredDevice, (v) => setState(() => _restrictRegisteredDevice = v), colors),
          _toggleItem('Tự động chấm công ca liên tiếp', _autoCheckinConsecutive, (v) => setState(() => _autoCheckinConsecutive = v), colors),
          _toggleItem('Yêu cầu hoàn thành task để check-out', _requireTaskCompletion, (v) => setState(() => _requireTaskCompletion = v), colors),
        ]),
        const SizedBox(height: 12),
        _buildConfigCard('Quy tắc thông báo', Icons.notifications_active_rounded, AppColors.warning, colors, [
          _toggleItem('Gửi thông báo khi Check-in', _alertCheckin, (v) => setState(() => _alertCheckin = v), colors),
          _toggleItem('Gửi thông báo khi Check-out', _alertCheckout, (v) => setState(() => _alertCheckout = v), colors),
          _toggleItem('Gửi thông báo khi đi muộn', _alertLate, (v) => setState(() => _alertLate = v), colors),
          _toggleItem('Gửi thông báo khi về sớm', _alertEarly, (v) => setState(() => _alertEarly = v), colors),
        ]),
        const SizedBox(height: 12),
        _buildConfigCard('Quy tắc tính toán', Icons.calculate_rounded, const Color(0xFF8B5CF6), colors, [
          _radioGroup('Logic đi muộn/về sớm (Part-time)', _partTimeLateLogic,
            [('shift', 'Tính từ giờ ca'), ('actual', 'Tính từ giờ thực tế')],
            (v) => setState(() => _partTimeLateLogic = v!), colors),
          Divider(height: 20, color: colors.divider),
          _radioGroup('Logic đi muộn/về sớm (Full-time)', _fullTimeLateLogic,
            [('shift', 'Tính từ giờ ca'), ('actual', 'Tính từ giờ thực tế')],
            (v) => setState(() => _fullTimeLateLogic = v!), colors),
          Divider(height: 20, color: colors.divider),
          _radioGroup('Logic chỉnh sửa của Quản lý', _managerEditLogic,
            [('manager', 'Dùng giờ Quản lý chỉnh'), ('compare', 'So sánh với giờ ca')],
            (v) => setState(() => _managerEditLogic = v!), colors),
        ]),
        const SizedBox(height: 12),
        _buildConfigCard('Giới hạn GPS & Thời gian', Icons.gps_fixed_rounded, AppColors.error, colors, [
          _numericField('Bán kính cảnh báo GPS (m)', _gpsWarningCtrl, 'Mặc định: Diện tích x2'),
          _numericField('Bán kính GPS nghiêm ngặt (m)', _gpsStrictCtrl, null),
          _numericField('Check-in sớm tối đa (phút)', _maxEarlyCheckinCtrl, null),
          _numericField('Check-out muộn tối đa (phút)', _maxLateCheckoutCtrl, null),
          _numericField('Khóa sửa sau payroll (ngày)', _lockPayrollCtrl, null),
          _numericField('Khóa sửa sau cuối tuần (ngày)', _lockWeekCtrl, null),
          _numericField('Giới hạn lần sửa cho quản lý', _maxEditCountCtrl, null),
        ]),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => showHrmSuccessSnackbar(context, 'Đã lưu cấu hình chấm công'),
            icon: const Icon(Icons.save_rounded, size: 18),
            label: const Text('Lưu cấu hình'),
          ),
        ),
        const SizedBox(height: 32),
      ]),
    );
  }

  Widget _buildConfigCard(String title, IconData icon, Color color, dynamic colors, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderLight),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w700, color: colors.textPrimary)),
        iconColor: colors.textSecondary,
        collapsedIconColor: colors.textTertiary,
        children: children,
      ),
    );
  }

  Widget _toggleItem(String label, bool value, ValueChanged<bool> onChanged, dynamic colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(children: [
        Expanded(child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: colors.textPrimary, fontSize: 13))),
        Switch.adaptive(value: value, onChanged: onChanged, activeColor: colors.primary),
      ]),
    );
  }

  Widget _radioGroup(String label, String groupValue, List<(String, String)> options, ValueChanged<String?> onChanged, dynamic colors) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTextStyles.bodySmall.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
      const SizedBox(height: 6),
      ...options.map((opt) => RadioListTile<String>(
        value: opt.$1, groupValue: groupValue, onChanged: onChanged,
        title: Text(opt.$2, style: AppTextStyles.bodySmall.copyWith(color: colors.textPrimary, fontSize: 13)),
        dense: true, visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.zero,
        activeColor: colors.primary,
      )),
    ]);
  }

  Widget _numericField(String label, TextEditingController ctrl, String? hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Expanded(
          flex: 3,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 12)),
            if (hint != null) Text(hint, style: AppTextStyles.labelSmall.copyWith(fontSize: 9)),
          ]),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), isDense: true),
          ),
        ),
      ]),
    );
  }
}
