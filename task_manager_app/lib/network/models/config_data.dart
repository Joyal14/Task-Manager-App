class ConfigData {
  String? basePath;
  String? environment;
  String? subscription;
  bool? paymentSandbox;
  String? paymentSecret;
  String? onesingleAppid;
  String? inviteMsg;

  ConfigData({this.basePath, this.environment, this.subscription, this.paymentSandbox, this.paymentSecret, this.onesingleAppid, this.inviteMsg});

  factory ConfigData.fromJson(Map<String, dynamic> json) {
    return ConfigData(
      basePath: json['base_path'],
      environment: json['environment'],
      subscription: json['subscription'],
      paymentSandbox: json['payment_sandbox'],
      paymentSecret: json['payment_secret'],
      onesingleAppid: json['onesingle_appid'],
      inviteMsg: json['invite_msg'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['base_path'] = basePath;
    data['environment'] = environment;
    data['subscription'] = subscription;
    data['payment_sandbox'] = paymentSandbox;
    data['payment_secret'] = paymentSecret;
    data['onesingle_appid'] = onesingleAppid;
    data['invite_msg'] = inviteMsg;
    return data;
  }
}
