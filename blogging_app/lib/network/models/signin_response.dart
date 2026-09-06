
import 'dart:convert';

SigninResponseData signinResponseDataFromJson(String str) => SigninResponseData.fromJson(json.decode(str));

String signinResponseDataToJson(SigninResponseData data) => json.encode(data.toJson());

class SigninResponseData {
    String token;
    User user;

    SigninResponseData({
        required this.token,
        required this.user,
    });

    factory SigninResponseData.fromJson(Map<String, dynamic> json) => SigninResponseData(
        token: json["token"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
    };
}

class User {
    String username;
    String email;
    String role;
    String profileImage;

    User({
        required this.username,
        required this.email,
        required this.role,
        required this.profileImage,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        email: json["email"],
        role: json["role"],
        profileImage: json["profileImage"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "role": role,
        "profileImage": profileImage,
    };
}


