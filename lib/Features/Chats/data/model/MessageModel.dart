class MessageModel {
  final String id;
  final String message;
  final String sender;
  final String receiver;
  final DateTime time;

  const MessageModel(
      {required this.id,
      required this.message,
      required this.sender,
      required this.receiver,
      required this.time});
}
