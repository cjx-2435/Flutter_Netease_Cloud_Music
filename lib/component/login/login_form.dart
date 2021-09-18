import 'dart:async';
import 'package:demo09/api/config/http_client.dart';
import 'package:demo09/api/config/http_response.dart';
import 'package:demo09/iconfont/index.dart';
import 'package:demo09/store/account.dart';
import 'package:demo09/store/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  double radius = 10;
  double switchHeight = 50;
  int activeIndex = 0;
  Timer? _timer;
  int countdownTime = 0;
  final _formKey = GlobalKey<FormState>();
  HttpClient? _dio;
  TextEditingController _phone = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _captcha = TextEditingController();
  PageController _pageController = PageController();

  String? _phoneValidate(String? content) {
    if (content != null && content.length == 11) {
      return null;
    }
    return '手机号必须为11位';
  }

  void sendCaptcha() async {
    EasyLoading.instance
      ..indicatorColor = Colors.black
      ..backgroundColor = Colors.black
      ..indicatorType = EasyLoadingIndicatorType.circle
      ..indicatorSize = 50
      ..radius = 10;
    EasyLoading.show(
      status: '发送验证码...',
      maskType: EasyLoadingMaskType.black,
    );

    HttpResponse? res = await _dio?.get(
      '/captcha/sent?phone=${_phone.text}',
    );

    if (res?.ok ?? false) {
      startCountdown();
      EasyLoading.showSuccess('发送成功!');
    } else {
      EasyLoading.showError(res?.error?.message ?? '异常');
    }
  }

  void startCountdown() {
    countdownTime = 60;
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        countdownTime--;
        if (countdownTime < 1) {
          _timer?.cancel();
        }
        setState(() {});
      },
    );
  }

  void loginWithCaptcha() async {
    EasyLoading.show(status: '登陆中...');
    HttpResponse? res = await _dio?.post(
      '/login/cellphone',
      data: {'phone': _phone.text, 'captcha': _captcha.text},
    );
    if (EasyLoading.isShow) EasyLoading.dismiss(animation: true);
    if (res?.ok ?? false) {
      context.read<AccountModel>().isLogin = true;
    } else {
      EasyLoading.showError('登陆失败(${res?.error?.message ?? '未知异常'})');
      context.read<AccountModel>().isLogin = false;
    }
  }

  void loginWithPassword() async {
    EasyLoading.show(status: '登陆中...');
    HttpResponse? res = await _dio?.post('/login/cellphone',
        data: {'phone': _phone.text, 'password': _password.text});
    if (EasyLoading.isShow) EasyLoading.dismiss(animation: true);

    if (res?.ok ?? false) {
      context.read<AccountModel>().isLogin = true;
    } else {
      EasyLoading.showError('${res?.error?.message ?? '未知异常'}');
      context.read<AccountModel>().isLogin = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _dio = context.read<HttpModel>().dio;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Login 登陆表单重构');
    return GestureDetector(
      child: Scaffold(
        body: Container(
          color: Theme.of(context).primaryColor,
          constraints: BoxConstraints.tightFor(
            width: 360,
            height: double.infinity,
          ),
          child: ListView(
            children: [
              _logo(),
              _input(context),
            ],
          ),
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  Widget _logo() {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(360, 320)),
      child: Container(
        margin: EdgeInsets.only(top: 120, bottom: 50),
        height: 80,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColorDark,
          child: iconHome(size: 60, color: Colors.white),
        ),
      ),
    );
  }

  Widget _input(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: double.infinity, height: 300),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              offset: Offset(-1, 1),
              blurRadius: 5,
              spreadRadius: 1,
              color: Colors.black38,
            )
          ],
        ),
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            _switchBar(context),
            _switchForm(context),
            _login(context),
          ],
        ),
      ),
    );
  }

  Widget _switchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Theme.of(context).primaryColor),
        ),
      ),
      constraints: BoxConstraints.tightForFinite(
          width: double.infinity, height: switchHeight),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _button(
            context,
            index: 0,
            onPressed: () {
              setState(() {
                activeIndex = 0;
                _pageController.jumpToPage(0);
              });
            },
            text: '密码登录',
            radius: BorderRadius.only(topLeft: Radius.circular(radius)),
          ),
          _button(
            context,
            index: 1,
            onPressed: () {
              setState(() {
                activeIndex = 1;
                _pageController.jumpToPage(1);
              });
            },
            text: '验证码登陆',
            radius: BorderRadius.only(topRight: Radius.circular(radius)),
          ),
        ],
      ),
    );
  }

  Widget _button(
    BuildContext context, {
    required void Function()? onPressed,
    required String text,
    BorderRadius? radius,
    required int index,
    Color? activeColor,
    Color activeTextColor = Colors.white,
    Color color = Colors.white,
    Color? textColor,
  }) {
    activeColor ??= Theme.of(context).primaryColor;
    textColor ??= Theme.of(context).primaryColor;
    return Expanded(
      child: Material(
        borderRadius: radius,
        child: Ink(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: radius,
            color: index == activeIndex ? activeColor : color,
          ),
          child: InkWell(
            borderRadius: radius,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  color: index == activeIndex ? activeTextColor : textColor,
                ),
              ),
            ),
            splashColor: index == activeIndex
                ? Colors.white24
                : Theme.of(context).primaryColorLight,
            highlightColor: Colors.transparent,
            onTap: onPressed,
          ),
        ),
      ),
    );
  }

  Widget _switchForm(BuildContext context) {
    return Expanded(
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          activeIndex = index;
          setState(() {});
        },
        children: [
          _pswForm(context),
          _captchaForm(context),
        ],
      ),
    );
  }

  Widget _pswForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              validator: _phoneValidate,
              decoration: InputDecoration(
                labelText: '手机号',
                focusColor: Theme.of(context).primaryColor,
                hintText: '请输入手机号',
                icon: Icon(
                  Icons.phone_android,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              cursorColor: Theme.of(context).primaryColor,
            ),
            TextFormField(
              obscureText: true,
              controller: _password,
              decoration: InputDecoration(
                labelText: '密码',
                focusColor: Theme.of(context).primaryColor,
                hintText: '请输入密码',
                icon: Icon(
                  Icons.lock,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              cursorColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _captchaForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _phone,
              validator: _phoneValidate,
              decoration: InputDecoration(
                labelText: '手机号',
                focusColor: Theme.of(context).primaryColor,
                hintText: '请输入手机号',
                icon: Icon(
                  Icons.phone_android,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              cursorColor: Theme.of(context).primaryColor,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _captcha,
                    decoration: InputDecoration(
                      labelText: '验证码',
                      focusColor: Theme.of(context).primaryColor,
                      hintText: '请输入验证码',
                      icon: Icon(
                        Icons.vpn_key_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                  ),
                ),
                ElevatedButton(
                  onPressed: countdownTime <= 0 ? sendCaptcha : null,
                  child: Text(
                    countdownTime <= 0 ? '发送验证码' : '$countdownTime秒后重新发送',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      countdownTime <= 0
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _login(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: double.infinity, height: 60),
      child: Center(
        child: SizedBox(
          width: 150,
          height: 40,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus();
              activeIndex == 0 ? loginWithPassword() : loginWithCaptcha();
            },
            child: Text('登录'),
          ),
        ),
      ),
    );
  }
}
