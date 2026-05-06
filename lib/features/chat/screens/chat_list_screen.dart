import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../data/mock/chat_data.dart';
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
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const Divider(height: 1),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          SizedBox(
            width: 360,
            child: Container(
              color: AppColors.surface,
              child: Column(
                children: [
                  _buildHeader(),
                  const Divider(height: 1),
                  Expanded(child: _buildConversationListView()),
                ],
              ),
            ),
          ),
          Container(width: 1, color: AppColors.divider),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Chat', style: AppTextStyles.headlineLarge.copyWith(fontSize: 22)),
              const Spacer(),
              _iconBtn(Icons.edit_square, () {}),
              const SizedBox(width: 4),
              _iconBtn(Icons.more_horiz_rounded, () {}),
            ],
          ),
          const SizedBox(height: 10),
          // Search bar
          Container(
            height: 40,
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(20)),
            child: TextField(
              style: AppTextStyles.bodySmall,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm tin nhắn...',
                hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textTertiary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Tabs
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
}
