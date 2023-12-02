class Message {
  Message({
    required this.toId,
    required this.message,
    required this.fromId,
    required this.sent,
  });

  late String toId;
  late String message;
  late String fromId;
  late String sent;

  Message.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    message = json['message'].toString();
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['message'] = message;
    data['fromId'] = fromId;
    data['sent'] = sent;
    return data;
  }
}
