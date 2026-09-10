import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../app_config/app_config.dart';

class DioApiHelper {
  static String? accessToken;

  static Dio createDio(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        responseType: ResponseType.json,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          if (kDebugMode) {
            debugPrint('API REQUEST: ${options.method} ${options.uri}');
            debugPrint('API TOKEN: ${accessToken ?? 'null'}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
              'API RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
            );
            debugPrint('API MESSAGE: ${response.data}');
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint(
              'API ERROR: ${error.requestOptions.method} ${error.requestOptions.uri}',
            );
            debugPrint('API MESSAGE: ${error.message}');
            if (error.response?.data != null) {
              debugPrint('API ERROR BODY: ${error.response?.data}');
            }
          }
          handler.next(error);
        },
      ),
    );
    return dio;
  }

  static final Dio userApi = createDio(AppConfig.shared.userBaseUrl);

  static Future<Response<dynamic>> post(
    String uri, {
    Object? data,
  }) {
    return postUser(uri, data: data);
  }

  static Future<Response<dynamic>> postUser(
    String uri, {
    Object? data,
  }) {
    return userApi.post<dynamic>(uri, data: data);
  }

  static Future<Response<dynamic>> postBlog(
    String uri, {
    Object? data,
  }) {
    return userApi.post<dynamic>(uri, data: data);
  }

  static Future<Response<dynamic>> getBlog(
    String uri, {
    Object? data,
  }) {
    return userApi.get<dynamic>(uri, data: data);
  }

}