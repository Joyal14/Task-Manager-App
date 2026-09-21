import 'dart:convert';

ChatMessageResponse chatMessageResponseFromJson(String str) => ChatMessageResponse.fromJson(json.decode(str));

String chatMessageResponseToJson(ChatMessageResponse data) => json.encode(data.toJson());

class ChatMessageResponse {
    String sender;
    String username;
    String text;
    String id;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    ChatMessageResponse({
        required this.sender,
        required this.username,
        required this.text,
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory ChatMessageResponse.fromJson(Map<String, dynamic> json) => ChatMessageResponse(
        sender: json["sender"],
        username: json["username"],
        text: json["text"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "sender": sender,
        "username": username,
        "text": text,
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
