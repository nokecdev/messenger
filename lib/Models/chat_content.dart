class Chatcontent {
  String publicId;
  String chatRoomId;
  String authorId;
  String message;
  bool isAuthor;
  DateTime sentDate;
  Status status = Status.sent;
  Object? chatFile;

  Chatcontent({
    required this.publicId,
    required this.chatRoomId,
    required this.authorId,
    required this.message,
    required this.isAuthor,
    required this.sentDate,
    required this.status,
    this.chatFile,
  });

  factory Chatcontent.fromJson(Map<String, dynamic> map) {
    return Chatcontent(
      chatRoomId: map['chatRoomId'],
      publicId: map['publicId'],
      authorId: map['authorId'],
      message: map['message'],
      isAuthor: map['isAuthor'],
      sentDate: DateTime.parse(map['sentDate']),
      status: Status.values.firstWhere(
        (e) => e.name.toLowerCase() == (map['status'] as String).toLowerCase(),
      ),
      chatFile: map['chatFile']

    );
  }
}

enum Status {
  read,
  sent,
  delivered
}