import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../core/widgets/interactive_overlays.dart';

/// ============================================================================
/// PERFORMANCE SCREEN - Đánh giá Hiệu suất & KPIs
/// Mobile-first: Tabs cho Overview / KPI / 9-Box Grid
/// ============================================================================
class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isMobile),
            _buildTabs(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _tabIndex == 0 ? _buildOverview(isMobile) : _tabIndex == 1 ? _buildKpiList() : _buildNineBoxGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.fromLTRB(isMobile ? 16 : 24, 12, isMobile ? 16 : 24, 12),
      decoration: BoxDecoration(color: AppColors.surface, border: Border(bottom: BorderSide(color: AppColors.divider))),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Hiệu suất', style: AppTextStyles.headlineLarge.copyWith(fontSize: isMobile ? 20 : 24)),
            Text('Chu kỳ đánh giá Q2/2026', style: AppTextStyles.bodySmall),
          ])),
          if (!isMobile) ElevatedButton.icon(
            onPressed: () => showHrmSuccessSnackbar(context, 'Đang mở form tạo đánh giá...'),
            icon: const Icon(Icons.add_chart_rounded, size: 18),
            label: const Text('Tạo đánh giá'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = [('Tổng quan', Icons.dashboard_rounded), ('KPIs/OKRs', Icons.track_changes_rounded), ('9-Box Grid', Icons.grid_3x3_rounded)];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = i == _tabIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tabIndex = i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: isActive ? null : Border.all(color: AppColors.borderLight),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(tabs[i].$2, size: 14, color: isActive ? Colors.white : AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Text(tabs[i].$1, style: AppTextStyles.labelMedium.copyWith(
                    color: isActive ? Colors.white : AppColors.textTertiary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400, fontSize: 11,
                  )),
                ]),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOverview(bool isMobile) {
    return Column(
      children: [
        // Summary cards
        GridView.count(
          crossAxisCount: isMobile ? 2 : 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: isMobile ? 1.4 : 1.8,
          children: [
            _summaryCard('Đã đánh giá', '186', '/ 247', AppColors.success, Icons.check_circle_rounded),
            _summaryCard('Đang chờ', '42', 'nhân viên', AppColors.warning, Icons.hourglass_top_rounded),
            _summaryCard('Quá hạn', '19', 'phiếu', AppColors.error, Icons.warning_rounded),
            _summaryCard('Điểm TB', '4.2', '/ 5.0', AppColors.info, Icons.star_rounded),
          ],
        ),
        const SizedBox(height: 16),
        // Recent reviews
        _sectionTitle('Đánh giá gần đây'),
        const SizedBox(height: 8),
        ..._reviewItems.map((r) => _reviewCard(r)),
      ],
    );
  }

  Widget _summaryCard(String label, String value, String sub, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: AppTextStyles.kpiValue.copyWith(fontSize: 22, color: color)),
                const SizedBox(width: 4),
                Padding(padding: const EdgeInsets.only(bottom: 3), child: Text(sub, style: AppTextStyles.bodySmall.copyWith(fontSize: 10))),
              ],
            ),
          ),
          Text(label, style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildKpiList() {
    return Column(
      children: [
        ..._kpiItems.map((kpi) => _kpiCard(kpi)),
      ],
    );
  }

  Widget _kpiCard(Map<String, dynamic> kpi) {
    final progress = (kpi['progress'] as double);
    final color = progress >= 0.8 ? AppColors.success : progress >= 0.5 ? AppColors.warning : AppColors.error;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(kpi['title'] as String, style: AppTextStyles.titleSmall.copyWith(fontSize: 13))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text('${(progress * 100).toInt()}%', style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.w700, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(kpi['description'] as String, style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: progress, backgroundColor: AppColors.surfaceVariant, valueColor: AlwaysStoppedAnimation(color), minHeight: 6),
          ),
          const SizedBox(height: 6),
          Row(children: [
            Text('Mục tiêu: ${kpi['target']}', style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
            const Spacer(),
            Text('Thực tế: ${kpi['actual']}', style: AppTextStyles.labelSmall.copyWith(fontSize: 10, fontWeight: FontWeight.w600)),
          ]),
        ],
      ),
    );
  }

  Widget _buildNineBoxGrid() {
    final labels = [
      ['Tiềm năng cao\nHiệu suất thấp', 'Tiềm năng cao\nHiệu suất TB', 'Ngôi sao\n⭐'],
      ['Tiềm năng TB\nHiệu suất thấp', 'Nhân viên cốt lõi\n💪', 'Hiệu suất cao\nTiềm năng TB'],
      ['Cần cải thiện\n⚠️', 'Hiệu suất TB\nTiềm năng thấp', 'Chuyên gia\n🎯'],
    ];
    final counts = [
      [5, 12, 8],
      [15, 42, 18],
      [7, 10, 14],
    ];
    final colors = [
      [AppColors.warning, AppColors.info, AppColors.success],
      [AppColors.error, AppColors.primaryLight, AppColors.info],
      [AppColors.error, AppColors.warning, AppColors.success],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ma trận 9-Box (Tiềm năng vs Hiệu suất)', style: AppTextStyles.headlineSmall.copyWith(fontSize: 15)),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 6, crossAxisSpacing: 6, childAspectRatio: 1.0),
          itemCount: 9,
          itemBuilder: (context, i) {
            final row = i ~/ 3;
            final col = i % 3;
            return Container(
              decoration: BoxDecoration(
                color: colors[row][col].withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors[row][col].withValues(alpha: 0.2)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${counts[row][col]}', style: AppTextStyles.kpiValue.copyWith(fontSize: 22, color: colors[row][col])),
                  const SizedBox(height: 2),
                  Text(labels[row][col], style: AppTextStyles.labelSmall.copyWith(fontSize: 8), textAlign: TextAlign.center),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('← Hiệu suất thấp', style: AppTextStyles.labelSmall.copyWith(fontSize: 9)),
          Text('Hiệu suất cao →', style: AppTextStyles.labelSmall.copyWith(fontSize: 9)),
        ]),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Row(children: [
      Text(title, style: AppTextStyles.headlineSmall.copyWith(fontSize: 15)),
      const Spacer(),
      Text('Xem tất cả', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 11)),
    ]);
  }

  Widget _reviewCard(Map<String, String> r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Row(
        children: [
          UserAvatar(initials: r['avatar']!, size: 38),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(r['name']!, style: AppTextStyles.titleSmall.copyWith(fontSize: 13)),
            Text('${r['reviewer']} • ${r['date']}', style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(6)),
            child: Row(children: [
              const Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
              const SizedBox(width: 2),
              Text(r['score']!, style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)),
            ]),
          ),
        ],
      ),
    );
  }

  static final _reviewItems = [
    {'name': 'Nguyễn Văn An', 'avatar': 'NVA', 'reviewer': 'Lê Hoàng Cường', 'score': '4.5', 'date': '05/05/2026'},
    {'name': 'Trần Thị Bình', 'avatar': 'TTB', 'reviewer': 'Lê Hoàng Cường', 'score': '4.8', 'date': '04/05/2026'},
    {'name': 'Phạm Minh Đức', 'avatar': 'PMD', 'reviewer': 'Nguyễn Minh Tuấn', 'score': '4.2', 'date': '03/05/2026'},
    {'name': 'Đỗ Mai Hương', 'avatar': 'DMH', 'reviewer': 'Hoàng Thu Em', 'score': '3.9', 'date': '02/05/2026'},
  ];

  static final _kpiItems = [
    {'title': 'Tỷ lệ hoàn thành Task', 'description': 'Hoàn thành các task đúng hạn', 'target': '90%', 'actual': '85%', 'progress': 0.85},
    {'title': 'Chất lượng Code', 'description': 'Code coverage > 80%, bugs < 5/sprint', 'target': '80%', 'actual': '92%', 'progress': 0.92},
    {'title': 'Customer Satisfaction', 'description': 'Đánh giá CSAT > 4.0', 'target': '4.0', 'actual': '3.8', 'progress': 0.65},
    {'title': 'Doanh thu Q2', 'description': 'Đạt doanh thu mục tiêu Q2', 'target': '5 tỷ', 'actual': '3.8 tỷ', 'progress': 0.76},
    {'title': 'Training Hours', 'description': 'Hoàn thành 40 giờ đào tạo/quý', 'target': '40h', 'actual': '28h', 'progress': 0.70},
  ];
}
