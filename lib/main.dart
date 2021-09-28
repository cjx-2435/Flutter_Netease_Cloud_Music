import 'package:demo09/api/config/http_client.dart';
import 'package:demo09/api/config/http_config.dart';
import 'package:demo09/page/login.dart';
import 'package:demo09/route/routes.dart';
import 'package:demo09/store/account.dart';
import 'package:demo09/store/http.dart';
import 'package:demo09/store/player.dart';
import 'package:demo09/store/refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HttpClient? client;

  Future<void> _createHttpClient() async {
    String path =
        (await getApplicationDocumentsDirectory()).path + '/cookie.txt';
    HttpConfig dioConfig =
        HttpConfig(baseUrl: 'http://192.168.1.57:3000', cookiesPath: path);
    client = HttpClient(dioConfig: dioConfig);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Root 重构');
    return FutureBuilder(
      future: _createHttpClient(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return MaterialApp(
              home: Center(
                child: SpinKitWave(
                  color: Colors.red,
                  size: 100,
                ),
              ),
            );
          case ConnectionState.done:
          default:
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<HttpModel>(
                    create: (_) => HttpModel(client!)),
                ChangeNotifierProvider<AccountModel>(
                    create: (_) => AccountModel()),
                ChangeNotifierProvider<RefreshModel>(
                    create: (_) => RefreshModel()),
                ChangeNotifierProvider<PlayerModel>(
                    create: (_) => PlayerModel()),
              ],
              child: MaterialApp(
                // showPerformanceOverlay: true,
                theme: ThemeData(
                  primaryColor: Color(0xffd44439),
                  primaryColorLight: Colors.red[100],
                  primaryColorDark: Colors.red[800],
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                routes: Routes.getRoutes(context),
                home: LoginPage(),
                builder: EasyLoading.init(),
              ),
            );
        }
      },
    );
  }
}


