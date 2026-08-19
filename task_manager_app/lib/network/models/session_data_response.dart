import 'dart:convert';

import 'package:flutter_base/network/models/session_data.dart';
import 'package:flutter_base/network/models/status_model.dart';

class SessionDataResponse {
  Status? status;
  SessionData? data;

  SessionDataResponse({this.status, this.data});

  factory SessionDataResponse.fromJson(Map<String, dynamic> json) {
    return SessionDataResponse(
      status: json['status'] != null ? Status.fromJson(json['status']) : null,
      data: json['data'] != null ? SessionData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (status != null) {
      data['status'] = status?.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

SessionDataResponse getSessionDataFromJson(String str) {
  final jsonData = json.decode(str);
  return SessionDataResponse.fromJson(jsonData);
}
