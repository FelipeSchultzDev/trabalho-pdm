class ChatUser {
  ChatUser({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    required this.status,
    required this.createdAt,
  });

  late String id;
  late String name;
  late String email;
  late String? image;
  late String status;
  late String createdAt;

  ChatUser.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    image = json['image'];
    status = json['status'] ?? '';
    createdAt = json['created_at'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['image'] = image;
    data['status'] = status;
    data['created_at'] = createdAt;

    return data;
  }
}
