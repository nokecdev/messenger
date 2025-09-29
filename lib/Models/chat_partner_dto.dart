class ChatPartnerDto {
  String avatar;
  String firstName;
  String? middleName;
  String lastName;
  String chatRoomId;

  ChatPartnerDto({
    required this.avatar,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.chatRoomId
  });

  factory ChatPartnerDto.fromJson(Map<String, dynamic> map) {
    return ChatPartnerDto(
      avatar: map['userAvatar'],
      firstName: map['firstName'],
      middleName: map['middleName'],
      lastName: map['lastName'],
      chatRoomId: map['chatRoomId']
    );
  }
}