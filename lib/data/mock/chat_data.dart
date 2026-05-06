/// MOCK DATA - CHAT (Zalo/Messenger Style)
class ChatConversation {
  final String id, name, avatar, lastMessage, time;
  final int unreadCount;
  final bool isOnline, isGroup;
  const ChatConversation({required this.id, required this.name, required this.avatar, required this.lastMessage, required this.time, required this.unreadCount, required this.isOnline, this.isGroup = false});
}

class ChatMessage {
  final String id, senderId, senderName, content, time;
  final bool isMe;
  final String type; // 'text', 'image', 'file'
  const ChatMessage({required this.id, required this.senderId, required this.senderName, required this.content, required this.time, required this.isMe, this.type = 'text'});
}

const List<ChatConversation> mockConversations = [
  ChatConversation(id: 'c1', name: 'Phòng Công nghệ', avatar: 'PCT', lastMessage: 'Anh ơi review code giúp em nhé 🙏', time: '09:45', unreadCount: 3, isOnline: true, isGroup: true),
  ChatConversation(id: 'c2', name: 'Trần Thị Bình', avatar: 'TTB', lastMessage: 'API payroll đã xong rồi!', time: '09:30', unreadCount: 1, isOnline: true),
  ChatConversation(id: 'c3', name: 'Nguyễn Văn An', avatar: 'NVA', lastMessage: 'OK anh, em push code chiều nay', time: '08:55', unreadCount: 0, isOnline: false),
  ChatConversation(id: 'c4', name: 'Ban Giám đốc', avatar: 'BGĐ', lastMessage: 'Cuộc họp lúc 14h nhé các anh chị', time: 'Hôm qua', unreadCount: 0, isOnline: false, isGroup: true),
  ChatConversation(id: 'c5', name: 'Đỗ Mai Hương', avatar: 'DMH', lastMessage: 'Design mới em gửi trên Figma rồi ạ', time: 'Hôm qua', unreadCount: 0, isOnline: true),
  ChatConversation(id: 'c6', name: 'HR - Thông báo', avatar: 'HR', lastMessage: '📢 Lịch nghỉ lễ 30/4 - 1/5', time: 'T2', unreadCount: 0, isOnline: false, isGroup: true),
  ChatConversation(id: 'c7', name: 'Phạm Minh Đức', avatar: 'PMĐ', lastMessage: 'Deploy thành công rồi! 🎉', time: 'T2', unreadCount: 0, isOnline: false),
];

const List<ChatMessage> mockMessages = [
  ChatMessage(id: 'm1', senderId: 's2', senderName: 'Trần Thị Bình', content: 'Anh Tuấn ơi, em có vấn đề với API payroll', time: '09:10', isMe: false),
  ChatMessage(id: 'm2', senderId: 's1', senderName: 'Tôi', content: 'Gì vậy em? Anh xem giúp', time: '09:12', isMe: true),
  ChatMessage(id: 'm3', senderId: 's2', senderName: 'Trần Thị Bình', content: 'Phần tính OT bị sai công thức, em đang fix lại theo spec mới. Anh check giúp em PR #245 nhé', time: '09:15', isMe: false),
  ChatMessage(id: 'm4', senderId: 's1', senderName: 'Tôi', content: 'OK em, để anh xem. Spec mới thay đổi công thức OT tính theo hệ số 1.5 và 2.0 đúng không?', time: '09:18', isMe: true),
  ChatMessage(id: 'm5', senderId: 's2', senderName: 'Trần Thị Bình', content: 'Dạ đúng rồi anh. Ngày thường x1.5, cuối tuần x2.0, lễ x3.0', time: '09:20', isMe: false),
  ChatMessage(id: 'm6', senderId: 's1', senderName: 'Tôi', content: 'Anh đã review xong, có vài comment trên PR. Em fix rồi merge luôn nhé 👍', time: '09:25', isMe: true),
  ChatMessage(id: 'm7', senderId: 's2', senderName: 'Trần Thị Bình', content: 'API payroll đã xong rồi! 🎉 Em đã fix hết comments và merge vào develop', time: '09:30', isMe: false),
  ChatMessage(id: 'm8', senderId: 's1', senderName: 'Tôi', content: 'Tuyệt vời! Good job em 💪', time: '09:32', isMe: true),
];
