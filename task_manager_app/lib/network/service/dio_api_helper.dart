import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/app_config/app_config.dart';
import 'package:flutter_base/constants/api_constants.dart';
import 'package:flutter_base/constants/app_constants.dart';
import 'package:flutter_base/network/service/navigation_locator.dart';
import 'package:flutter_base/network/service/navigation_service.dart';
import 'package:flutter_base/screens/onboard/view/login_screen.dart';
import 'package:flutter_base/utils/preferences_util.dart';
import 'package:flutter_base/utils/session_handler_util.dart';

class DioApiHelper {
  //production
  static const String apiBaseUrlProd = 'https://api.day2daynews.in/api/v1/';
  static const String imageBaseUrlProd = "";
  static const String onesignalidProd = "";
  //development
  static const String apiBaseUrlDev = 'https://dev-api.day2daynews.in/api/v1/';
  static const String imageBaseUrlDev = "";
  static const String onesignalidDev = "";

  static BaseOptions opts = BaseOptions(
    baseUrl: AppConfig.shared.baseUrl,
    responseType: ResponseType.json,
    connectTimeout: const Duration(milliseconds: 30000),
    receiveTimeout: const Duration(milliseconds: 30000),
  );

  static Dio createDio() {
    return Dio(opts);
  }

  static Dio addInterceptors(Dio dio) {
    return dio
      ..interceptors.add(
        InterceptorsWrapper(onRequest: (RequestOptions options, requestInterceptorHandler) async {
          debugPrint('*** API Request - Start ***');

          debugPrint('URI ${options.uri}');
          debugPrint('METHOD: ${options.method}');
          debugPrint('HEADERS:');
          options.headers.forEach((key, v) => debugPrint(' - $key,  $v'));
          debugPrint('BODY:');
          // debugPrint(options.data ?? '');

          debugPrint('*** API Request - End ***');
          return requestInterceptorHandler.next(requestInterceptor(options));
        }, onError: (error, errorInterceptorHandler) async {
          if (error.response?.statusCode == 401) {
            final NavigationService navigationService = locator<NavigationService>();

            navigationService.pushRemoveAndNavigateTo(LoginScreen.routeName);
          }
        }, onResponse: (response, responseInterceptorHandler) async {
          return responseInterceptorHandler.next(response);
        }),
      );
  }

  static RequestOptions requestInterceptor(RequestOptions options) {
    options.headers['Authorization'] = PreferencesUtil.getString(AppConstants.appAccessToken);
    // debugPrint("Options:${options.data}");
    return options;
  }

  static final dio = createDio();
  static final baseAPI = addInterceptors(dio);

  static sessionHandler(RequestOptions requestOptions) async {
    await SessionHandlerUtil().checkForSessionExpiry().then((value) {
      if (value == 0) {
        _retry(requestOptions);
      } else {}
    });
  }

  static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    if (requestOptions.method == ApiMethods.apiGetMethod) {
      return baseAPI.get(
        requestOptions.path,
        queryParameters: requestOptions.queryParameters,
      );
    } else {
      return baseAPI.post(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
      );
    }
  }

  static Future<Response<dynamic>> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await baseAPI.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response<dynamic>> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await baseAPI.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response<dynamic>> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await baseAPI.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
