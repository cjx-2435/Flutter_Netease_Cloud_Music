import 'package:demo09/api/config/http_client.dart';
import 'package:demo09/component/home/home_shortcuts.dart';
import 'package:demo09/component/home/home_swiper.dart';
import 'package:demo09/component/home/recommend_playlist.dart';
import 'package:demo09/component/home/search_control.dart';
import 'package:demo09/store/http.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Find extends StatefulWidget {
  const Find({
    Key? key,
  }) : super(key: key);

  @override
  _FindState createState() => _FindState();
}

class _FindState extends State<Find> {
  HttpClient? _dio;

  @override
  void initState() {
    super.initState();
    _dio = context.read<HttpModel>().dio;
  }

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
          _recommendPlayListTile(),
          RecommendPlayList(),
        ],
      ),
    );
  }

  Widget _recommendPlayListTile() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
            child: Text(
              '推荐歌单',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 60),
          child: GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  '更多',
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
