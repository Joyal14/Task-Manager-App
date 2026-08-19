class Session {
  String? tokenType;
  int? expiresIn;
  String? accessToken;
  String? refreshToken;

  Session({this.tokenType, this.expiresIn, this.accessToken, this.refreshToken});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    return data;
  }
}
