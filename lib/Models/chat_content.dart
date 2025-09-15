class Chatcontent {
  int messageId;
  int authorId;
  int? chatContentId;
  String message;
  DateTime? sentDate;
  Status status = Status.sent;

  Chatcontent({
    required this.messageId,
    required this.authorId,
    this.chatContentId,
    required this.message,
    this.sentDate,
    required this.status
  });

  factory Chatcontent.fromJson(Map<String, dynamic> map) {
    return Chatcontent(
      messageId: map['messageId'],
      authorId: map['authorId'],
      chatContentId: map['chatContentId'],
      message: map['message'],
      sentDate: DateTime.parse(map['sentDate']),
      status: Status.values.firstWhere((e) => e.index == map['status'])
    );
  }
}

enum Status {
  read,
  sent,
  delivered
}