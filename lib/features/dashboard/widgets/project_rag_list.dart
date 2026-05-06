import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/rag_badge.dart';
import '../../../data/mock/dashboard_data.dart';

/// Danh sách RAG Status dự án - Mobile-first responsive
class ProjectRagList extends StatelessWidget {
  const ProjectRagList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(Icons.flag_rounded, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text('Trạng thái Dự án', style: AppTextStyles.headlineSmall.copyWith(fontSize: 15))),
                Text('${mockProjects.length} dự án', style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
              ],
            ),
          ),
          const Divider(height: 1),
          ...mockProjects.map((p) => _ProjectRow(project: p)),
        ],
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  final ProjectRag project;
  const _ProjectRow({required this.project});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.5))),
      ),
      child: isMobile ? _buildMobileRow() : _buildDesktopRow(),
    );
  }

  Widget _buildMobileRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(project.name, style: AppTextStyles.titleSmall.copyWith(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            RagBadge(status: project.status),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(project.manager, style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
            const Spacer(),
            Text('${(project.progress * 100).toInt()}%', style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w600, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: project.progress,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation(_statusColor(project.status)),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopRow() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(project.name, style: AppTextStyles.titleSmall),
            const SizedBox(height: 2),
            Text(project.manager, style: AppTextStyles.bodySmall.copyWith(fontSize: 12)),
          ]),
        ),
        SizedBox(width: 90, child: RagBadge(status: project.status)),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${(project.progress * 100).toInt()}%', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: project.progress, backgroundColor: AppColors.surfaceVariant, valueColor: AlwaysStoppedAnimation(_statusColor(project.status)), minHeight: 5),
            ),
          ]),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 80,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(project.deadline, style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
            Text('${project.teamSize} người', style: AppTextStyles.labelSmall),
          ]),
        ),
      ],
    );
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'green': return AppColors.success;
      case 'amber': return AppColors.warning;
      case 'red': return AppColors.error;
      default: return AppColors.textTertiary;
    }
  }
}
