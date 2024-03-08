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

}

enum Status {
  Read,
  Sent,
  Delivered
}