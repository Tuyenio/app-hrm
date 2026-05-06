import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/permission_data.dart';

enum PermissionLayout { table, cards }

/// ============================================================================
/// PERMISSION TABLE - Ma trận checkbox phân quyền
/// DataTable dense với sticky headers, toggle switches trong cells.
/// ============================================================================
class PermissionTable extends StatefulWidget {
  final MockRole role;
  final bool compact;
  final PermissionLayout layout;
  const PermissionTable({
    super.key,
    required this.role,
    this.compact = false,
    this.layout = PermissionLayout.table,
  });

  @override
  State<PermissionTable> createState() => _PermissionTableState();
}

class _PermissionTableState extends State<PermissionTable> {
  late Map<String, Map<String, bool>> _permissions;

  @override
  void initState() {
    super.initState();
    // Deep copy permissions to allow toggling
    _permissions = {
      for (var entry in widget.role.permissions.entries)
        entry.key: Map<String, bool>.from(entry.value),
    };
  }

  @override
  void didUpdateWidget(covariant PermissionTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.role.id != widget.role.id) {
      _permissions = {
        for (var entry in widget.role.permissions.entries)
          entry.key: Map<String, bool>.from(entry.value),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.layout == PermissionLayout.cards) {
      return _buildCardLayout();
    }

    final moduleWidth = widget.compact ? 120.0 : 140.0;
    final minTableWidth = widget.compact ? 520.0 : 600.0;
    final headerPadding = widget.compact
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
    final rowPadding = widget.compact
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    final checkboxScale = widget.compact ? 0.75 : 0.85;
    final headerFontSize = widget.compact ? 10.0 : 11.0;
    final moduleFontSize = widget.compact ? 11.0 : 12.0;
    final iconSize = widget.compact ? 14.0 : 16.0;

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minTableWidth),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Table header row (sticky)
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant.withValues(alpha: 0.6),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  // Sticky left column header
                  Container(
                    width: moduleWidth,
                    padding: headerPadding,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: AppColors.divider),
                      ),
                    ),
                    child: Text(
                      'Module',
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // Action headers
                  ...permissionActions.map(
                    (action) => Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: headerPadding.vertical / 2,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          action,
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: headerFontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Data rows
            ...permissionModules.asMap().entries.map(
              (entry) => _buildRow(
                entry.key,
                entry.value,
                moduleWidth,
                rowPadding,
                checkboxScale,
                moduleFontSize,
                iconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardLayout() {
    return Column(
      children: permissionModules
          .map((module) => _buildModuleCard(module))
          .toList(),
    );
  }

  Widget _buildModuleCard(String module) {
    final modulePerms = _permissions[module] ?? {};
    final selectedCount = permissionActions
        .where((a) => modulePerms[a] ?? false)
        .length;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
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
              Icon(
                _moduleIcon(module),
                size: 16,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  module,
                  style: AppTextStyles.titleSmall.copyWith(fontSize: 13),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$selectedCount/${permissionActions.length}',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 10,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: permissionActions.map((action) {
              final isSelected = modulePerms[action] ?? false;
              return FilterChip(
                label: Text(action),
                selected: isSelected,
                showCheckmark: false,
                onSelected: (val) {
                  setState(() {
                    _permissions[module]?[action] = val;
                  });
                },
                labelStyle: AppTextStyles.labelSmall.copyWith(
                  fontSize: 10,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textTertiary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                backgroundColor: AppColors.surfaceVariant.withValues(
                  alpha: 0.4,
                ),
                selectedColor: AppColors.primary.withValues(alpha: 0.12),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.4)
                      : AppColors.borderLight,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    int index,
    String module,
    double moduleWidth,
    EdgeInsets rowPadding,
    double checkboxScale,
    double moduleFontSize,
    double iconSize,
  ) {
    final modulePerms = _permissions[module] ?? {};
    return Container(
      decoration: BoxDecoration(
        color: index.isEven
            ? null
            : AppColors.surfaceVariant.withValues(alpha: 0.15),
        border: Border(
          bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        children: [
          // Module name (sticky left)
          Container(
            width: moduleWidth,
            padding: rowPadding,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: AppColors.divider.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _moduleIcon(module),
                  size: iconSize,
                  color: AppColors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    module,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontSize: moduleFontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Permission checkboxes
          ...permissionActions.map(
            (action) => Expanded(
              child: Center(
                child: Transform.scale(
                  scale: checkboxScale,
                  child: Checkbox(
                    value: modulePerms[action] ?? false,
                    onChanged: (val) {
                      setState(() {
                        _permissions[module]?[action] = val ?? false;
                      });
                    },
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _moduleIcon(String module) {
    switch (module) {
      case 'Core HR':
        return Icons.people_outline_rounded;
      case 'Tuyển dụng':
        return Icons.person_add_alt_rounded;
      case 'Chấm công':
        return Icons.access_time_rounded;
      case 'Tính lương':
        return Icons.account_balance_wallet_outlined;
      case 'Dự án':
        return Icons.rocket_launch_outlined;
      case 'Báo cáo':
        return Icons.assessment_outlined;
      case 'Hệ thống':
        return Icons.settings_outlined;
      default:
        return Icons.folder_outlined;
    }
  }
}
