import 'package:dio/dio.dart';

/// Custom Exception handling class for Dio errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({
    required this.message,
    this.statusCode,
  });

  factory ApiException.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          message: 'Connection timeout with API server. Please try again.',
        );
      case DioExceptionType.sendTimeout:
        return ApiException(
          message: 'Send timeout in connection with API server.',
        );
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Receive timeout in connection with API server.',
        );
      case DioExceptionType.badResponse:
        return _handleStatusCode(
          dioException.response?.statusCode,
          dioException.response?.data,
        );
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request to API server was cancelled.',
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection or server unreachable.',
        );
      case DioExceptionType.unknown:
      default:
        return ApiException(
          message: dioException.message ?? 'An unexpected error occurred.',
        );
    }
  }

  static ApiException _handleStatusCode(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return ApiException(
          message: 'Bad Request. Please check your data.',
          statusCode: statusCode,
        );
      case 401:
        return ApiException(
          message: 'Unauthorized. Please login again.',
          statusCode: statusCode,
        );
      case 403:
        return ApiException(
          message: 'Forbidden. You do not have access.',
          statusCode: statusCode,
        );
      case 404:
        return ApiException(
          message: 'Requested resource not found.',
          statusCode: statusCode,
        );
      case 500:
        return ApiException(
          message: 'Internal server error. Please try again later.',
          statusCode: statusCode,
        );
      case 503:
        return ApiException(
          message: 'Service unavailable. Server is undergoing maintenance.',
          statusCode: statusCode,
        );
      default:
        return ApiException(
          message: 'Received invalid status code: $statusCode',
          statusCode: statusCode,
        );
    }
  }

  @override
  String toString() => message;
}
