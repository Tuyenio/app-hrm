import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../core/widgets/interactive_overlays.dart';
import '../../../data/mock/chat_data.dart';
import '../../../data/mock/employee_data.dart';
import 'chat_detail_screen.dart';

/// ============================================================================
/// CHAT LIST SCREEN - Redesign mobile-first
/// Mobile: Full-screen conversation list, tap navigates to detail.
/// Desktop: Split view (list + chat detail).
/// ============================================================================
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String? _selectedConversationId;
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      return _buildMobileLayout();
    }
    return _buildDesktopLayout();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // MOBILE LAYOUT - Full screen conversation list
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildMobileLayout() {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Divider(height: 1, color: colors.divider),
            Expanded(child: _buildConversationListView()),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // DESKTOP LAYOUT - Split view
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildDesktopLayout() {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      body: Row(
        children: [
          SizedBox(
            width: 360,
            child: Container(
              color: colors.surface,
              child: Column(
                children: [
                  _buildHeader(),
                  Divider(height: 1, color: colors.divider),
                  Expanded(child: _buildConversationListView()),
                ],
              ),
            ),
          ),
          Container(width: 1, color: colors.divider),
          Expanded(
            child: _selectedConversationId != null
                ? ChatDetailScreen(
                    conversation: mockConversations.firstWhere((c) => c.id == _selectedConversationId),
                    isEmbedded: true,
                  )
                : _buildEmptyChat(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Chat', style: AppTextStyles.headlineLarge.copyWith(fontSize: 22, color: colors.textPrimary)),
              const Spacer(),
              _iconBtn(Icons.edit_square, () => _showCreateGroupSheet(context)),
              const SizedBox(width: 4),
              _iconBtn(Icons.more_horiz_rounded, () => _showChatSettingsMenu(context)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 40,
            decoration: BoxDecoration(color: colors.surfaceVariant, borderRadius: BorderRadius.circular(20)),
            child: TextField(
              style: AppTextStyles.bodySmall.copyWith(color: colors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm tin nhắn...',
                hintStyle: AppTextStyles.bodySmall.copyWith(color: colors.textTertiary),
                prefixIcon: Icon(Icons.search_rounded, size: 20, color: colors.textTertiary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _tab('Tất cả', 0),
              const SizedBox(width: 6),
              _tab('Chưa đọc', 1),
              const SizedBox(width: 6),
              _tab('Nhóm', 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConversationListView() {
    final filteredConversations = mockConversations.where((conv) {
      if (_tabIndex == 1 && conv.unreadCount == 0) return false;
      if (_tabIndex == 2 && !conv.isGroup) return false;
      return true;
    }).toList();

    if (filteredConversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline_rounded, size: 48, color: AppColors.textTertiary.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text('Không có tin nhắn', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredConversations.length,
      itemBuilder: (context, i) {
        final conv = filteredConversations[i];
        final isSelected = conv.id == _selectedConversationId;
        return _buildConversationTile(conv, isSelected);
      },
    );
  }

  Widget _buildConversationTile(ChatConversation conv, bool isSelected) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Material(
      color: isSelected ? AppColors.primarySurface : Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() => _selectedConversationId = conv.id);
          if (isMobile) {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => ChatDetailScreen(conversation: conv, isEmbedded: false),
            ));
          }
        },
        onLongPress: () => _showConversationContextMenu(context, conv),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.4))),
          ),
          child: Row(
            children: [
              UserAvatar(
                initials: conv.avatar,
                size: 48,
                showStatus: true,
                isOnline: conv.isOnline,
                backgroundColor: conv.isGroup ? AppColors.primaryLight.withValues(alpha: 0.2) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              if (conv.isGroup) ...[
                                Icon(Icons.group_rounded, size: 14, color: AppColors.textTertiary),
                                const SizedBox(width: 4),
                              ],
                              Flexible(
                                child: Text(conv.name, style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: conv.unreadCount > 0 ? FontWeight.w700 : FontWeight.w500,
                                ), overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                        Text(conv.time, style: AppTextStyles.labelSmall.copyWith(
                          color: conv.unreadCount > 0 ? AppColors.primary : AppColors.textTertiary, fontSize: 11,
                        )),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(conv.lastMessage, style: AppTextStyles.bodySmall.copyWith(
                            color: conv.unreadCount > 0 ? AppColors.textPrimary : AppColors.textTertiary,
                            fontWeight: conv.unreadCount > 0 ? FontWeight.w500 : FontWeight.w400,
                          ), overflow: TextOverflow.ellipsis, maxLines: 1),
                        ),
                        if (conv.unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                            child: Text('${conv.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.primarySurface, shape: BoxShape.circle),
            child: Icon(Icons.chat_rounded, size: 48, color: AppColors.primary.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 16),
          Text('Chọn cuộc trò chuyện', style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Text('Chọn từ danh sách bên trái để bắt đầu', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.surfaceVariant, shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _tab(String label, int index) {
    final isActive = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: AppTextStyles.labelMedium.copyWith(
          color: isActive ? Colors.white : AppColors.textSecondary,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400, fontSize: 12,
        )),
      ),
    );
  }

  // ── CREATE GROUP CHAT SHEET ─────────────────────────────────────────────
  /// UPDATED: selectedUsers moved outside StatefulBuilder so it persists.
  /// Added visual counter showing "X đã chọn".
  void _showCreateGroupSheet(BuildContext context) {
    // State lives outside StatefulBuilder to persist across rebuilds
    final selectedUsers = <String>{};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, sc) => Container(
          decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(children: [
                Center(child: Container(margin: const EdgeInsets.only(top: 10), width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(children: [
                    Text('Tạo nhóm chat', style: AppTextStyles.headlineSmall.copyWith(fontSize: 18)),
                    if (selectedUsers.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${selectedUsers.length} đã chọn',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                  ]),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: TextField(decoration: const InputDecoration(hintText: 'Tên nhóm (VD: Team Backend)', prefixIcon: Icon(Icons.group_rounded, size: 20))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      style: AppTextStyles.bodySmall,
                      decoration: InputDecoration(
                        hintText: 'Tìm thành viên...',
                        hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.textTertiary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                // Selected users chips
                if (selectedUsers.isNotEmpty)
                  Container(
                    height: 44,
                    padding: const EdgeInsets.only(top: 8),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: selectedUsers.map((uid) {
                        final emp = mockEmployeeList.firstWhere((e) => e.id == uid);
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Chip(
                            avatar: UserAvatar(initials: emp.avatar, size: 24),
                            label: Text(emp.name.split(' ').last, style: AppTextStyles.labelSmall.copyWith(fontSize: 11, color: AppColors.textPrimary)),
                            deleteIcon: const Icon(Icons.close_rounded, size: 14),
                            onDeleted: () => setModalState(() => selectedUsers.remove(uid)),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    controller: sc,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: mockEmployeeList.length,
                    itemBuilder: (context, i) {
                      final emp = mockEmployeeList[i];
                      final isChecked = selectedUsers.contains(emp.id);
                      return CheckboxListTile(
                        value: isChecked,
                        onChanged: (v) => setModalState(() => v == true ? selectedUsers.add(emp.id) : selectedUsers.remove(emp.id)),
                        title: Text(emp.name, style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: isChecked ? FontWeight.w700 : FontWeight.w500,
                        )),
                        subtitle: Text(emp.position, style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
                        secondary: Stack(
                          children: [
                            UserAvatar(initials: emp.avatar, size: 36),
                            if (isChecked)
                              Positioned(
                                right: -2, bottom: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check_rounded, size: 10, color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        tileColor: isChecked ? AppColors.primarySurface.withValues(alpha: 0.5) : null,
                        controlAffinity: ListTileControlAffinity.trailing,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedUsers.isEmpty ? null : () {
                        Navigator.pop(context);
                        showHrmSuccessSnackbar(context, 'Đã tạo nhóm chat với ${selectedUsers.length} thành viên');
                      },
                      child: Text(selectedUsers.isEmpty ? 'Chọn thành viên' : 'Tạo nhóm (${selectedUsers.length})'),
                    ),
                  ),
                ),
              ]);
            },
          ),
        ),
      ),
    );
  }

  // ── CHAT SETTINGS MENU ─────────────────────────────────────────────────
  void _showChatSettingsMenu(BuildContext context) {
    showHrmContextMenu(context, items: [
      HrmContextMenuItem(icon: Icons.mark_email_read_rounded, label: 'Đánh dấu tất cả đã đọc', onTap: () => showHrmSuccessSnackbar(context, 'Đã đánh dấu tất cả đã đọc')),
      HrmContextMenuItem(icon: Icons.push_pin_rounded, label: 'Tin nhắn đã ghim', onTap: () => showHrmSuccessSnackbar(context, 'Đang mở tin nhắn đã ghim...')),
      HrmContextMenuItem(icon: Icons.group_rounded, label: 'Quản lý nhóm', onTap: () => showHrmSuccessSnackbar(context, 'Đang mở quản lý nhóm...')),
      HrmContextMenuItem(icon: Icons.settings_rounded, label: 'Cài đặt chat', onTap: () => showHrmSuccessSnackbar(context, 'Đang mở cài đặt...')),
      HrmContextMenuItem(icon: Icons.archive_rounded, label: 'Lưu trữ cuộc trò chuyện', onTap: () => showHrmSuccessSnackbar(context, 'Đã lưu trữ')),
    ]);
  }

  // ── CONVERSATION CONTEXT MENU (Long press) ─────────────────────────────
  void _showConversationContextMenu(BuildContext context, ChatConversation conv) {
    showHrmContextMenu(context, items: [
      HrmContextMenuItem(icon: Icons.push_pin_rounded, label: 'Ghim lên đầu', onTap: () => showHrmSuccessSnackbar(context, 'Đã ghim "${conv.name}"')),
      HrmContextMenuItem(icon: Icons.mark_email_read_rounded, label: 'Đánh dấu đã đọc', onTap: () => showHrmSuccessSnackbar(context, 'Đã đánh dấu đã đọc')),
      HrmContextMenuItem(icon: Icons.notifications_off_rounded, label: 'Tắt thông báo', onTap: () => showHrmSuccessSnackbar(context, 'Đã tắt thông báo')),
      HrmContextMenuItem(icon: Icons.visibility_off_rounded, label: 'Ẩn cuộc trò chuyện', onTap: () => showHrmSuccessSnackbar(context, 'Đã ẩn cuộc trò chuyện')),
      HrmContextMenuItem(icon: Icons.delete_rounded, label: 'Xóa cuộc trò chuyện', isDanger: true, onTap: () async {
        final confirmed = await showHrmConfirmDialog(context, title: 'Xóa cuộc trò chuyện?', message: 'Bạn có chắc muốn xóa cuộc trò chuyện với "${conv.name}"? Hành động này không thể hoàn tác.', confirmText: 'Xóa', isDanger: true, icon: Icons.delete_forever_rounded);
        if (confirmed == true && context.mounted) showHrmSuccessSnackbar(context, 'Đã xóa cuộc trò chuyện');
      }),
    ]);
  }
}
