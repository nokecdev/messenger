import 'dart:core';

class ChatRoomsResponse {
  List<ChatRoomDto> chatRooms;
  PaginationDto roomPagination;

  ChatRoomsResponse({
    required this.chatRooms,
    required this.roomPagination,
  });

  factory ChatRoomsResponse.fromJson(Map<String, dynamic> json) {
    return ChatRoomsResponse(
      chatRooms: (json['chatRooms'] as List<dynamic>)
          .map((e) => ChatRoomDto.fromJson(e))
          .toList(),
      roomPagination: PaginationDto.fromJson(json['roomPagination']),
    );
  }
}

class ChatRoomDto {
  String chatRoomId;
  String lastMessage;
  DateTime startedDateTime;
  DateTime endedDateTime;
  UserDetailsDto chatPartner;
  PaginationDto messagesPagination;

  ChatRoomDto({
    required this.chatRoomId,
    required this.lastMessage,
    required this.startedDateTime,
    required this.endedDateTime,
    required this.chatPartner,
    required this.messagesPagination,
  });

  factory ChatRoomDto.fromJson(Map<String, dynamic> json) {
    return ChatRoomDto(
      chatRoomId: json['chatRoomId'] as String,
      lastMessage: json['lastMessage'] as String,
      startedDateTime: DateTime.parse(json['startedDateTime'] as String),
      endedDateTime: DateTime.parse(json['endedDateTime'] as String),
      chatPartner: UserDetailsDto.fromJson(json['chatPartner']),
      messagesPagination: PaginationDto.fromJson(json['messagesPagination']),
    );
  }
}

class UserDetailsDto {
  String publicId;
  String avatar;
  String firstName;
  String middleName;
  String lastName;

  UserDetailsDto({
    required this.publicId,
    required this.avatar,
    required this.firstName,
    required this.middleName,
    required this.lastName,
  });

  factory UserDetailsDto.fromJson(Map<String, dynamic> json) {
    return UserDetailsDto(
      publicId: json['publicId'] as String,
      avatar: json['avatar'] as String,
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String,
      lastName: json['lastName'] as String,
    );
  }
}

class PaginationDto {
  int page;
  int totalPage;
  int offset;
  int total;

  PaginationDto({
    required this.page,
    required this.totalPage,
    required this.offset,
    required this.total,
  });

  factory PaginationDto.fromJson(Map<String, dynamic> json) {
    return PaginationDto(
      page: json['page'] as int,
      totalPage: json['totalPage'] as int,
      offset: json['offset'] as int,
      total: json['total'] as int,
    );
  }
}
