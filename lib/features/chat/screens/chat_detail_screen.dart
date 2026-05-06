import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../core/widgets/interactive_overlays.dart';
import '../../../data/mock/chat_data.dart';

/// ============================================================================
/// CHAT DETAIL SCREEN - Màn hình chat chi tiết (Zalo/Messenger bubble style)
/// ============================================================================
class ChatDetailScreen extends StatefulWidget {
  final ChatConversation conversation;
  final bool isEmbedded;

  const ChatDetailScreen({super.key, required this.conversation, this.isEmbedded = false});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List.from(mockMessages);
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(
        id: 'm${_messages.length + 1}',
        senderId: 's1',
        senderName: 'Tôi',
        content: _controller.text.trim(),
        time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        isMe: true,
      ));
      _controller.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildMessageList()),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4)],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (!widget.isEmbedded)
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 22),
                onPressed: () => Navigator.pop(context),
              ),
            UserAvatar(
              initials: widget.conversation.avatar,
              size: 40,
              showStatus: true,
              isOnline: widget.conversation.isOnline,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.conversation.name, style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      Container(
                        width: 7, height: 7,
                        decoration: BoxDecoration(
                          color: widget.conversation.isOnline ? AppColors.online : AppColors.textTertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.conversation.isOnline ? 'Đang hoạt động' : 'Offline',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: widget.conversation.isOnline ? AppColors.success : AppColors.textTertiary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action buttons
            _actionIcon(Icons.phone_rounded, () => _showCallDialog(context, false)),
            _actionIcon(Icons.videocam_rounded, () => _showCallDialog(context, true)),
            _actionIcon(Icons.info_outline_rounded, () => _showChatInfoSheet(context)),
          ],
        ),
      ),
    );
  }

  Widget _actionIcon(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Container(
        decoration: BoxDecoration(color: AppColors.surfaceVariant, shape: BoxShape.circle),
        child: IconButton(
          icon: Icon(icon, size: 20, color: AppColors.primary),
          onPressed: onTap,
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (context, i) {
        final msg = _messages[i];
        final showAvatar = !msg.isMe && (i == 0 || _messages[i - 1].isMe);
        final showTime = i == _messages.length - 1 ||
            _messages[i + 1].isMe != msg.isMe;
        return _buildBubble(msg, showAvatar, showTime);
      },
    );
  }

  Widget _buildBubble(ChatMessage msg, bool showAvatar, bool showTime) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar (for received messages)
          if (!msg.isMe)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: showAvatar
                  ? UserAvatar(initials: widget.conversation.avatar, size: 30)
                  : const SizedBox(width: 30),
            ),
          // Bubble
          Flexible(
            child: Column(
              crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: msg.isMe ? AppColors.chatBubbleSent : AppColors.chatBubbleReceived,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(msg.isMe ? 18 : 4),
                      bottomRight: Radius.circular(msg.isMe ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1)),
                    ],
                  ),
                  child: Text(
                    msg.content,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: msg.isMe ? Colors.white : AppColors.textPrimary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                if (showTime)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(msg.time, style: AppTextStyles.labelSmall.copyWith(fontSize: 10, color: AppColors.textTertiary)),
                        if (msg.isMe) ...[
                          const SizedBox(width: 3),
                          Icon(Icons.done_all_rounded, size: 13, color: AppColors.primaryLight),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, MediaQuery.of(context).padding.bottom + 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          // Attachment buttons
          _inputAction(Icons.add_circle_outline_rounded, () => _showAttachmentPicker(context)),
          _inputAction(Icons.image_outlined, () => showHrmSuccessSnackbar(context, 'Đang mở thư viện ảnh...')),
          _inputAction(Icons.attach_file_rounded, () => showHrmSuccessSnackbar(context, 'Đang chọn tệp...')),
          const SizedBox(width: 8),
          // Text input
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.chatInputBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Nhập tin nhắn...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      maxLines: null,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => showHrmSuccessSnackbar(context, 'Chọn biểu tượng cảm xúc'),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(Icons.emoji_emotions_outlined, size: 22, color: AppColors.textTertiary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputAction(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: IconButton(
        icon: Icon(icon, size: 22, color: AppColors.primary.withValues(alpha: 0.7)),
        onPressed: onTap,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── CALL DIALOG ───────────────────────────────────────────────────────────
  void _showCallDialog(BuildContext context, bool isVideo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            UserAvatar(initials: widget.conversation.avatar, size: 64),
            const SizedBox(height: 12),
            Text(widget.conversation.name, style: AppTextStyles.headlineSmall.copyWith(fontSize: 17)),
            const SizedBox(height: 4),
            Text(isVideo ? 'Đang gọi video...' : 'Đang gọi...', style: AppTextStyles.bodySmall.copyWith(color: AppColors.success)),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _callAction(Icons.mic_off_rounded, 'Tắt mic', AppColors.textSecondary, () {}),
              _callAction(Icons.call_end_rounded, 'Kết thúc', AppColors.error, () => Navigator.pop(context)),
              _callAction(Icons.volume_up_rounded, 'Loa', AppColors.textSecondary, () {}),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _callAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
      ]),
    );
  }

  // ── CHAT INFO SHEET ───────────────────────────────────────────────────────
  void _showChatInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (context, sc) => Container(
          decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          child: SingleChildScrollView(
            controller: sc,
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              UserAvatar(initials: widget.conversation.avatar, size: 64),
              const SizedBox(height: 12),
              Text(widget.conversation.name, style: AppTextStyles.headlineMedium.copyWith(fontSize: 20)),
              const SizedBox(height: 4),
              Text(widget.conversation.isOnline ? 'Đang hoạt động' : 'Offline', style: AppTextStyles.bodySmall.copyWith(color: widget.conversation.isOnline ? AppColors.success : AppColors.textTertiary)),
              const SizedBox(height: 20),
              // Quick actions
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _infoAction(Icons.search_rounded, 'Tìm kiếm'),
                _infoAction(Icons.notifications_rounded, 'Thông báo'),
                _infoAction(Icons.image_rounded, 'Media'),
                _infoAction(Icons.group_add_rounded, 'Thêm'),
              ]),
              const Divider(height: 32),
              _infoTile(Icons.photo_library_rounded, 'File đã chia sẻ', '23 ảnh, 5 file'),
              _infoTile(Icons.link_rounded, 'Liên kết', '12 links'),
              _infoTile(Icons.star_rounded, 'Tin nhắn đã ghim', '3 tin nhắn'),
              const Divider(height: 20),
              _infoTile(Icons.block_rounded, 'Chặn', null, color: AppColors.error),
              _infoTile(Icons.report_rounded, 'Báo cáo', null, color: AppColors.error),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _infoAction(IconData icon, String label) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.surfaceVariant, shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      const SizedBox(height: 6),
      Text(label, style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
    ]);
  }

  Widget _infoTile(IconData icon, String title, String? subtitle, {Color? color}) {
    return ListTile(
      leading: Icon(icon, size: 22, color: color ?? AppColors.textSecondary),
      title: Text(title, style: AppTextStyles.bodyMedium.copyWith(color: color, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: AppTextStyles.bodySmall.copyWith(fontSize: 11)) : null,
      trailing: Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textTertiary),
      contentPadding: EdgeInsets.zero,
    );
  }

  // ── ATTACHMENT PICKER ──────────────────────────────────────────────────────
  void _showAttachmentPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _attachOption(context, Icons.image_rounded, 'Ảnh', AppColors.success),
            _attachOption(context, Icons.camera_alt_rounded, 'Camera', AppColors.info),
            _attachOption(context, Icons.insert_drive_file_rounded, 'Tệp', AppColors.warning),
            _attachOption(context, Icons.location_on_rounded, 'Vị trí', AppColors.error),
          ]),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _attachOption(context, Icons.contact_page_rounded, 'Liên hệ', AppColors.primary),
            _attachOption(context, Icons.poll_rounded, 'Khảo sát', AppColors.primaryLight),
            _attachOption(context, Icons.event_rounded, 'Sự kiện', AppColors.warning),
            _attachOption(context, Icons.more_horiz_rounded, 'Khác', AppColors.textSecondary),
          ]),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  Widget _attachOption(BuildContext context, IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () { Navigator.pop(context); showHrmSuccessSnackbar(context, 'Đang mở $label...'); },
      child: SizedBox(
        width: 72,
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.labelSmall.copyWith(fontSize: 10), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
