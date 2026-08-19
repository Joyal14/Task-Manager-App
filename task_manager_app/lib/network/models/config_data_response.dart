import 'dart:convert';

import 'package:flutter_base/network/models/config_data.dart';
import 'package:flutter_base/network/models/status_model.dart';

class ConfigDataResponse {
  Status? status;
  ConfigData? data;

  ConfigDataResponse({this.status, this.data});

  factory ConfigDataResponse.fromJson(Map<String, dynamic> json) {
    return ConfigDataResponse(
      status: json['status'] != null ? Status.fromJson(json['status']) : null,
      data: json['data'] != null ? ConfigData.fromJson(json['data']) : null,
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

ConfigDataResponse getConfigFromJson(String str) {
  final jsonData = json.decode(str);
  return ConfigDataResponse.fromJson(jsonData);
}
