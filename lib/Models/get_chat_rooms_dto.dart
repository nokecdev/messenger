class GetChatRoomsDto {
  int roomOffset;
  int messagesOffset;
  int currentPage;

  GetChatRoomsDto({
  required this.roomOffset,
  required this.messagesOffset,
  required this.currentPage
  });

  
  Map<String, dynamic> toJson() {
    return {
      'roomOffset': roomOffset,
      'messagesOffset': messagesOffset,
      'currentPage': currentPage,
    };
  }

  getChatRooms() {
    return GetChatRoomsDto(
      roomOffset: roomOffset,
      messagesOffset: messagesOffset,
      currentPage: currentPage
    );
  }

  setChatRooms(int roomOffset, int messagesOffset, int currentPage) {
    this.roomOffset = roomOffset;
    this.messagesOffset = messagesOffset;
    this.currentPage = currentPage;
  }
}