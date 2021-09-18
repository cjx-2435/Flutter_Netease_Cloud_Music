import 'package:demo09/component/home/home_shortcuts.dart';
import 'package:demo09/component/home/home_swiper.dart';
import 'package:demo09/component/home/search_control.dart';
import 'package:flutter/material.dart';

class Find extends StatefulWidget {
  const Find({
    Key? key,
  }) : super(key: key);

  @override
  _FindState createState() => _FindState();
}

class _FindState extends State<Find> {
  @override
  Widget build(BuildContext context) {
    print('Home 页面重构');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(Icons.list),
        ),
        backgroundColor: Colors.black,
        title: SearchControl(),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    children: [Text('听歌识曲')],
                  );
                },
              );
            },
            icon: Icon(Icons.mic),
          ),
        ],
      ),
      body: ListView(
        children: [
          HomeSwiper(),
          HomeShortcuts(),
          ListTile(
            onTap: () {},
            title: Text(
              '推荐歌单',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
