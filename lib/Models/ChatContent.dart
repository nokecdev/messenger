class Chatcontent {
  int MessageId;
  int AuthorId;
  int? ChatContentId;
  String Message;
  DateTime? SentDate;
  Status status = Status.Sent;

  Chatcontent({
    required this.MessageId,
    required this.AuthorId,
    this.ChatContentId,
    required this.Message,
    this.SentDate,
    required this.status
  });

  factory Chatcontent.fromJson(Map<String, dynamic> map) {
    return Chatcontent(
      MessageId: map['messageId'],
      AuthorId: map['authorId'],
      ChatContentId: map['chatContentId'],
      Message: map['message'],
      SentDate: DateTime.parse(map['sentDate']),
      status: Status.values.firstWhere((e) => e.index == map['status'])
    );
  }
}

enum Status {
  Read,
  Sent,
  Delivered
}