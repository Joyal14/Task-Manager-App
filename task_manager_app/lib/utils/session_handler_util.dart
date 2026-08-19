import 'package:flutter/foundation.dart';
import 'package:flutter_base/constants/app_constants.dart';
import 'package:flutter_base/network/service/api_service.dart';
import 'package:flutter_base/utils/preferences_util.dart';

class SessionHandlerUtil {
  final httpService = APIService();

  Future<int> checkForSessionExpiry() async {
    int statusCode;
    final response = await httpService.getAuthToken(PreferencesUtil.getString(AppConstants.appRefreshToken) ?? '');
    if (response.status?.code == 0) {
    } else if (response.status?.code == 2024 || response.status?.code == 1024) {
    } else {
      if (kDebugMode) {
        print("session error");
      }
    }
    statusCode = response.status!.code!;
    return statusCode;
  }
}
