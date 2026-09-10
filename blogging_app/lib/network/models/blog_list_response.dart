
import 'dart:convert';

BlogListResponseData blogListResponseDataFromJson(String str) => BlogListResponseData.fromJson(json.decode(str));

String blogListResponseDataToJson(BlogListResponseData data) => json.encode(data.toJson());

class BlogListResponseData {
    List<Blog> blogs;

    BlogListResponseData({
        required this.blogs,
    });

    factory BlogListResponseData.fromJson(Map<String, dynamic> json) => BlogListResponseData(
        blogs: List<Blog>.from(json["blogs"].map((x) => Blog.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "blogs": List<dynamic>.from(blogs.map((x) => x.toJson())),
    };
}

class Blog {
    String id;
    String title;
    String content;
    String coverImage;
    Author author;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    Blog({
        required this.id,
        required this.title,
        required this.content,
        required this.coverImage,
        required this.author,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory Blog.fromJson(Map<String, dynamic> json) => Blog(
        id: json["_id"],
        title: json["title"],
        content: json["content"],
        coverImage: json["coverImage"],
        author: Author.fromJson(json["author"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "content": content,
        "coverImage": coverImage,
        "author": author.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}

class Author {
    String id;
    String username;
    String email;
    String profileImage;

    Author({
        required this.id,
        required this.username,
        required this.email,
        required this.profileImage,
    });

    factory Author.fromJson(Map<String, dynamic> json) => Author(
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

