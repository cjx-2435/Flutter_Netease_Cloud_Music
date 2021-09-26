import 'package:demo09/page/home_page.dart';
import 'package:demo09/page/login.dart';
import 'package:demo09/page/play_page/play_list.dart';
import 'package:demo09/page/play_page/play_mv.dart';
import 'package:flutter/cupertino.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(context) {
    return {
      '/HomePage': (context) => HomePage(),
      '/Login': (context) => LoginPage(),
      '/PlayList': (context) => PlayListPage(),
      '/PlayMV': (context) => PlayMVPage(),
    };
  }
}
