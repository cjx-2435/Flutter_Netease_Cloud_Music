import 'package:demo09/api/config/http_client.dart';
import 'package:demo09/api/config/http_response.dart';
import 'package:demo09/store/account.dart';
import 'package:demo09/store/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  HttpClient? _dio;
  String? nickname;
  String? avatar;
  String? bgImage;

  @override
  void initState() {
    super.initState();
    _dio = context.read<HttpModel>().dio;
  }

  Future<void> _getInfo() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    nickname = storage.getString('nickname');
    avatar = storage.getString('avatar');
    bgImage = storage.getString('bgImage');
  }

  Future<void> _loginOut() async {
    EasyLoading.show(
      status: '正在登出...',
    );
    HttpResponse? res =
        await _dio?.get('/logout?${DateTime.now().millisecondsSinceEpoch}');
    print(res?.ok);
    print(res?.error);
    if (res?.ok ?? false) {
      SharedPreferences storage = await SharedPreferences.getInstance();
      await storage.remove('nickname');
      await storage.remove('avatar');
      await storage.remove('bgImage');
      EasyLoading.showSuccess('已登出');
      await Navigator.of(context).pushReplacementNamed(
        '/Login',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Home 抽屉重构');
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(border: Border(bottom: BorderSide.none)),
            child: FutureBuilder(
              future: _getInfo(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return Container(
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            margin: EdgeInsets.only(right: 15),
                            child: CircleAvatar(),
                          ),
                          Expanded(
                            child: Text(
                              '游客',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    );
                  case ConnectionState.done:
                  default:
                    bgImage ??= '';
                    avatar ??= '';
                    return Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        image: (bgImage == null || bgImage?.length == 0)
                            ? null
                            : DecorationImage(
                                image: NetworkImage(bgImage!),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            margin: EdgeInsets.only(right: 15),
                            child: CircleAvatar(
                              backgroundImage:
                                  (avatar == null || avatar?.length == 0)
                                      ? null
                                      : NetworkImage(avatar!),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              nickname ?? '游客',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    );
                }
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: context.read<AccountModel>().isLogin
                      ? ElevatedButton.icon(
                          onPressed: () async {
                            await _loginOut();
                          },
                          icon: Icon(
                            Icons.login_outlined,
                            size: 24,
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor,
                            ),
                            fixedSize: MaterialStateProperty.all(
                              Size(double.infinity, 50),
                            ),
                          ),
                          label: Text(
                            '退出登录',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
   