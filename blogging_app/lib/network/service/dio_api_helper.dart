import 'package:dio/dio.dart';

import '../../app_config/app_config.dart';

class DioApiHelper {
  static String? accessToken;

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.shared.baseUrl,
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
          handler.next(options);
        },
      ),
    );
    return dio;
  }

  static final Dio baseApi = createDio();

  static Future<Response<dynamic>> post(
    String uri, {
    Object? data,
  }) {
    return baseApi.post<dynamic>(uri, data: data);
  }
}