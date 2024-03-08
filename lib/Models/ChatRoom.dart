class ChatRoom {
  int chatRoomId;
  int senderId;
  int receiverId;
  DateTime startedDateTime;
  DateTime endedDateTime;

  ChatRoom({
  required this.chatRoomId,
  required this.senderId,
  required this.receiverId,
  required this.startedDateTime,
  required this.endedDateTime});

  getChatRoom() {
    return ChatRoom(
        chatRoomId: chatRoomId, senderId: senderId,
        receiverId: receiverId,startedDateTime: startedDateTime,
        endedDateTime: endedDateTime);
  }

  setChatRoom(chatRoomId, senderId, receiverId, startedDateTime, endedDateTime) {
    this.chatRoomId = chatRoomId;
    this.senderId = senderId;
    this.receiverId = receiverId;
    this.startedDateTime = startedDateTime;
    this.endedDateTime = endedDateTime;
  }
}
