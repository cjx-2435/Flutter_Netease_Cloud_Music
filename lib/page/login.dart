import 'dart:async';

import 'package:demo09/api/config/http_client.dart';
import 'package:demo09/api/config/http_response.dart';
import 'package:demo09/api/config/index.dart';
import 'package:demo09/api/transformer/login_status.dart';
import 'package:demo09/component/login/login_form.dart';
import 'package:demo09/store/account.dart';
import 'package:demo09/store/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  HttpClient? _dio;

  Future<void> _getLoginStatus() async {
    HttpResponse? res = await _dio?.get('/login/status',
        httpTransformer: LoginStatusTransfromer.getInstance());
    if (res?.ok ?? false) {
      context.read<AccountModel>().isLogin = true;
      SharedPreferences storage = await SharedPreferences.getInstance();
      storage.setString('nickname', res?.data['profile']['nickname'] ?? '游客');
      storage.setString('avatar', res?.data['profile']['avatarUrl'] ?? '');
      storage.setString('bgImage', res?.data['profile']['backgroundUrl'] ?? '');
      await Navigator.of(context).pushReplacementNamed(
        '/HomePage',
      );
    } else {
      context.read<AccountModel>().isLogin = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _dio = context.read<HttpModel>().dio;
  }

  @override
  Widget build(BuildContext context) {
    print('Login 页面重构');
    return FutureBuilder(
      future: _getLoginStatus(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: SpinKitWave(
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
            );
          case ConnectionState.done:
          default:
            return LoginForm();
        }
      },
    );
  }
}
