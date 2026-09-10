import 'dart:convert';

CommentAddResponseData commentAddResponseDataFromJson(String str) => CommentAddResponseData.fromJson(json.decode(str));

String commentAddResponseDataToJson(CommentAddResponseData data) => json.encode(data.toJson());

class CommentAddResponseData {
    String content;
    String blogId;
    String createdBy;
    String id;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    CommentAddResponseData({
        required this.content,
        required this.blogId,
        required this.createdBy,
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory CommentAddResponseData.fromJson(Map<String, dynamic> json) => CommentAddResponseData(
        content: json["content"],
        blogId: json["blogId"],
        createdBy: json["createdBy"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "content": content,
        "blogId": blogId,
        "createdBy": createdBy,
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
