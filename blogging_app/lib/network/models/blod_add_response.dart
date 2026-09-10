import 'dart:convert';

BlogAddResponseData blogAddResponseDataFromJson(String str) => BlogAddResponseData.fromJson(json.decode(str));

String blogAddResponseDataToJson(BlogAddResponseData data) => json.encode(data.toJson());

class BlogAddResponseData {
    String message;
    BlogPost blogPost;

    BlogAddResponseData({
        required this.message,
        required this.blogPost,
    });

    factory BlogAddResponseData.fromJson(Map<String, dynamic> json) => BlogAddResponseData(
        message: json["message"],
        blogPost: BlogPost.fromJson(json["blogPost"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "blogPost": blogPost.toJson(),
    };
}

class BlogPost {
    String title;
    String content;
    String coverImage;
    String author;
    String id;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    BlogPost({
        required this.title,
        required this.content,
        required this.coverImage,
        required this.author,
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory BlogPost.fromJson(Map<String, dynamic> json) => BlogPost(
        title: json["title"],
        content: json["content"],
        coverImage: json["coverImage"],
        author: json["author"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "coverImage": coverImage,
        "author": author,
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}


