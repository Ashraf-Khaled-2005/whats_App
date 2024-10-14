class ChatItemDataModel {
  final String senderid;
  final String name;
  final String message;
  final String time;
  final String imageUrl;

  ChatItemDataModel(
      {required this.senderid,
      required this.name,
      required this.message,
      required this.time,
      required this.imageUrl});

  factory ChatItemDataModel.fromJson(Map<String, dynamic> json) {
    return ChatItemDataModel(
        senderid: json['senderid'],
        name: json['sendername'],
        message: json['lastmessage'],
        time: json['time'],
        imageUrl: json['imageUrl']);
  }
}
