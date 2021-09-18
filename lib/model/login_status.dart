class LoginStatusModel {
  LoginStatusModel(
      {required this.code, required this.account, required this.profile});
  LoginStatusModel.formMap(Map<String, dynamic> map)
      : code = map['code'],
        account = map['account'],
        profile = map['profile'];
  final int code;
  final Map<String, dynamic>? account;
  final Map<String, dynamic>? profile;
}
