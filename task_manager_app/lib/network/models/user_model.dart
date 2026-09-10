class User {
  String? sId;
  String? email;
  String? countryCode;
  String? mobileNo;
  int? roleId;
  String? name;
  String? userName;
  String? fullMobile;
  String? updatedAt;
  String? createdAt;
  String? password;
  String? profile;

  User({
    this.sId,
    this.email,
    this.countryCode,
    this.mobileNo,
    this.roleId,
    this.name,
    this.userName,
    this.fullMobile,
    this.updatedAt,
    this.createdAt,
    this.password,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      sId: json['_id'],
      email: json['email'],
      countryCode: json['country_code'],
      mobileNo: json['mobile_no'],
      roleId: json['roleId'],
      name: json['name'],
      userName: json['user_name'],
      fullMobile: json['full_mobile'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      password: json['password'],
      profile: json['profile'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['email'] = email;
    data['country_code'] = countryCode;
    data['mobile_no'] = mobileNo;
    data['roleId'] = roleId;
    data['name'] = name;
    data['user_name'] = userName;
    data['full_mobile'] = fullMobile;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['password'] = password;
    data['profile'] = profile;
    return data;
  }
}
