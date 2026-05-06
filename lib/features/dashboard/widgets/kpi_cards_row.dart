import 'package:flutter/material.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../data/mock/dashboard_data.dart';

/// Row KPI Cards cho Dashboard - responsive: 2x2 trên mobile, 4 trên desktop
class KpiCardsRow extends StatelessWidget {
  const KpiCardsRow({super.key});

  static const _icons = [Icons.people_alt_rounded, Icons.account_balance_wallet_rounded, Icons.rocket_launch_rounded, Icons.check_circle_rounded];
  static const _colors = [Color(0xFF1A73E8), Color(0xFF8B5CF6), Color(0xFFF59E0B), Color(0xFF10B981)];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;
    final crossCount = w > 1200 ? 4 : (isMobile ? 2 : 2);
    // Tính aspect ratio phù hợp hơn cho mobile
    final aspectRatio = isMobile ? 1.3 : (w > 1200 ? 1.8 : 1.6);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossCount,
        mainAxisSpacing: isMobile ? 10 : 16,
        crossAxisSpacing: isMobile ? 10 : 16,
        childAspectRatio: aspectRatio,
      ),
      itemCount: mockKpis.length,
      itemBuilder: (context, i) {
        final kpi = mockKpis[i];
        return StatCard(
          title: kpi.title,
          value: kpi.value,
          change: kpi.change,
          isPositive: kpi.isPositive,
          icon: _icons[i],
          accentColor: _colors[i],
        );
      },
    );
  }
}
