import 'dart:convert';

List<CommentListResponseData> commentListResponseDataFromJson(String str) => List<CommentListResponseData>.from(json.decode(str).map((x) => CommentListResponseData.fromJson(x)));

String commentListResponseDataToJson(List<CommentListResponseData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentListResponseData {
    String id;
    String content;
    String blogId;
    CreatedBy createdBy;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    CommentListResponseData({
        required this.id,
        required this.content,
        required this.blogId,
        required this.createdBy,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory CommentListResponseData.fromJson(Map<String, dynamic> json) => CommentListResponseData(
        id: json["_id"],
        content: json["content"],
        blogId: json["blogId"],
        createdBy: CreatedBy.fromJson(json["createdBy"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "content": content,
        "blogId": blogId,
        "createdBy": createdBy.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}

class CreatedBy {
    String id;
    String username;
    String email;
    String profileImage;

    CreatedBy({
        required this.id,
        required this.username,
        required this.email,
        required this.profileImage,
    });

    factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        profileImage: json["profileImage"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "profileImage": profileImage,
    };
}
