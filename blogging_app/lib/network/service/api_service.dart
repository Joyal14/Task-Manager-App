import '../../constants/api_constants.dart';
import '../models/signin_response.dart';
import 'dio_api_helper.dart';

class ApiService {
  Future<SigninResponseData> signinUser({
    required String email,
    required String password,
  }) async {
    final response = await DioApiHelper.post(
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
    final response = await DioApiHelper.post(
      ApiUrlConstants.signup,
      data: {
        'username': username,
        'email': email,
        'password': password,
      },
    );

   return signinResponseDataFromJson(response.toString());
  }
}