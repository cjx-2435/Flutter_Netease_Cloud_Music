import 'package:flutter/material.dart';

class AccountModel extends ChangeNotifier {
  AccountModel();
  bool _isLogin = false;

  bool get isLogin => _isLogin;
  set isLogin(bool status) {
    _isLogin = status;
    notifyListeners();
  }
}
