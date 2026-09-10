class ApiUrlConstants {
  static const String apiRefreshToken = 'users/refresh-token';
  static const String apiVersion = 'version-check?';
  static const String apiConfig = 'config-api';

  static const String login = 'signin';
  static const String signup = 'signup';
  static const String addBlog = '../blog/add-blog-post';
  static const String blogList = '../blog/blog-list';
  static const String addComment = '../comment/add-comment';
  static const String commentList = '../comment/get-comments';
}

class ApiMethods {
  static const String apiGetMethod = 'GET';
  static const String apiPostMethod = 'POST';
}

class ApiStatusCode {
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusAccepted = 202;
  static const int statusNonContent = 204;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusServerError = 500;
}

class ApiStatus {
  static const String statusInprogress = 'in_progress';
  static const String statucSuccess = 'success';
  static const String statusFailed = 'failed';
  static const String statusRead = 'read';
}

class ApiSucessStatus {
  static const int apiSuccess = 0;
  static const int regVerifyOtpSuccess = 5;
}