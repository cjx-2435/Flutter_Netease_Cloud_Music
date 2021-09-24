import 'package:demo09/component/home/user_info.dart';
import 'package:demo09/iconfont/index.dart';
import 'package:demo09/model/tab_bar.dart';
import 'package:demo09/page/tab_page/community.dart';
import 'package:demo09/page/tab_page/find.dart';
import 'package:demo09/page/tab_page/follow.dart';
import 'package:demo09/page/tab_page/my.dart';
import 'package:demo09/page/tab_page/podcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TabBarModel> _tabbar = [
    {
      'activeIcon': iconHome(color: Colors.white),
      'inactiveIcon': iconHome(color: Colors.grey),
      'label': '发现',
      'active': true,
    },
    {
      'activeIcon': iconPodcast(color: Colors.white),
      'inactiveIcon': iconPodcast(color: Colors.grey),
      'label': '播客',
      'active': false,
    },
    {
      'activeIcon': iconMusic(color: Colors.white),
      'inactiveIcon': iconMusic(color: Colors.grey),
      'label': '我的',
      'active': false,
    },
    {
      'activeIcon': iconFollow(color: Colors.white),
      'inactiveIcon': iconFollow(color: Colors.grey),
      'label': '关注',
      'active': false,
    },
    {
      'activeIcon': iconCommunity(color: Colors.white),
      'inactiveIcon': iconCommunity(color: Colors.grey),
      'label': '云村',
      'active': false,
    },
  ].map((e) => TabBarModel.fromMap(e)).toList();
  int _currentIndex = 0;

  void handleBarChange(index) {
    if (_currentIndex == index) return;
    _tabbar[_currentIndex].active = false;
    _currentIndex = index;
    _tabbar[index].active = true;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('App重构');
    return KeyboardDismissOnTap(
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            Find(),
            Podcast(),
            My(),
            Follow(),
            Community(),
          ],
        ),
        drawer: UserInfo(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: handleBarChange,
          selectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          fixedColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          items: _tabbar.map((item) {
            return BottomNavigationBarItem(
              icon: CircleAvatar(
                child: item.active ? item.activeIcon : item.inactiveIcon,
                backgroundColor: item.active
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
              ),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}
