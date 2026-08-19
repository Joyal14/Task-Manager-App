import 'package:flutter_base/network/models/session_model.dart';
import 'package:flutter_base/network/models/user_model.dart';

class SessionData {
  Session? session;
  User? user;

  SessionData({this.session, this.user});

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      session: json['session'] != null ? Session.fromJson(json['session']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (session != null) {
      data['session'] = session?.toJson();
    }
    if (user != null) {
      data['user'] = user?.toJson();
    }
    return data;
  }
}
