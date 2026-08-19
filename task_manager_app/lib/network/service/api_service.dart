import 'dart:convert';

import 'package:flutter_base/constants/api_constants.dart';
import 'package:flutter_base/network/models/session_data_response.dart';
import 'package:flutter_base/network/models/config_data_response.dart';
import 'package:flutter_base/network/service/dio_api_helper.dart';

class APIService {
  Future<ConfigDataResponse> getConfig() async {
    final response = await DioApiHelper.get(APIUrlConstants.apiConfig);
    return getConfigFromJson(response.toString());
  }

  Future<SessionDataResponse> getAuthToken(String refreshToken) async {
    var params = {
      'refresh_token': refreshToken,
    };
    final response = await DioApiHelper.post(APIUrlConstants.apiRefreshToken, data: jsonEncode(params));
    return getSessionDataFromJson(response.toString());
  }
}
