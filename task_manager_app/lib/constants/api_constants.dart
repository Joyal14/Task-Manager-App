class APIUrlConstants {
  static const String apiRefreshToken = 'users/refresh-token';
  static const String apiVersion = 'version-check?';
  static const String apiConfig = 'config-api';
}

class ApiMethods {
  static const String apiGetMethod = 'GET';
  static const String apiPostMethod = 'POST';
}

class ApiStatusCode {
//Api Status Codes
  static const statusOk = 200;
  static const statusCreated = 201;
  static const statusAccepted = 202;
  static const statusNonContent = 204;
  static const statusBadRequest = 400;
  static const statusUnauthorized = 401;
  static const statusForbidden = 403;
  static const statusNotFound = 404;
  static const statusServerError = 500;
}

class ApiStatus {
  //Api Status
  static const statusInprogress = "in_progress";
  static const statucSuccess = "success";
  static const statusFailed = "failed";
  static const statusRead = "read";
}

class ApiSucessStatus {
  static const apiSuccess = 0;
  static const regVerifyOtpSuccess = 5;
}

