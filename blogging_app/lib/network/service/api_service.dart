import 'dart:convert';

import 'package:blogging_app/network/models/blod_add_response.dart';
import 'package:blogging_app/network/models/blog_list_response.dart';
import 'package:dio/dio.dart';

import '../../constants/api_constants.dart';
import '../models/signin_response.dart';
import 'dio_api_helper.dart';

class ApiService {
  Future<SigninResponseData> signinUser({
    required String email,
    required String password,
  }) async {
    final response = await DioApiHelper.postUser(
      ApiUrlConstants.login,
      data: {'email': email, 'password': password},
    );

   return signinResponseDataFromJson(response.toString());
  }

  Future<SigninResponseData> createUser({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await DioApiHelper.postUser(
      ApiUrlConstants.signup,
      data: {
        'username': username,
        'email': email,
        'password': password,
      },
    );

   return signinResponseDataFromJson(response.toString());
  }

  Future<BlogAddResponseData> addBlog({
    required String title,
    required String content,
    required String imagePath,
  }) async {
    final response = await DioApiHelper.postBlog(
      ApiUrlConstants.addBlog,
      data: FormData.fromMap({
        'title': title,
        'content': content,
        'image': await MultipartFile.fromFile(imagePath),
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add blog');
    }
    final responseData = response.data;
    return blogAddResponseDataFromJson(
      responseData is String ? responseData : jsonEncode(responseData),
    );
  }

  Future<BlogListResponseData> getBlogList() async {
    final response = await DioApiHelper.getBlog(
      ApiUrlConstants.blogList,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to fetch blog list');
    }
    final responseData = response.data;
    return blogListResponseDataFromJson(
      responseData is String ? responseData : jsonEncode(responseData),
    );
  }
  
}