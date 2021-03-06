import 'package:demo09/api/config/http_client.dart';
import 'package:demo09/component/home/home_shortcuts.dart';
import 'package:demo09/component/home/home_swiper.dart';
import 'package:demo09/component/home/recommend_list.dart';
import 'package:demo09/component/home/search_control.dart';
import 'package:demo09/notify/network_progress.dart';
import 'package:demo09/store/http.dart';
import 'package:demo09/store/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';

class Find extends StatefulWidget {
  const Find({
    Key? key,
  }) : super(key: key);

  @override
  _FindState createState() => _FindState();
}

class _FindState extends State<Find> with SingleTickerProviderStateMixin {
  late HttpClient _dio;
  int _requestCounter = 0;
  late EasyRefreshController _easyRefreshController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
    _dio = context.read<HttpModel>().dio;
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Home ้กต้ข้ๆ');
    return Scaffold(
      backgroundColor: Colors.black87,
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
              context.read<PlayerModel>().setVisibleStatus =
                  !context.read<PlayerModel>().visibleStatus;
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    children: [Text('ๅฌๆญ่ฏๆฒ')],
                  );
                },
              );
            },
            icon: Icon(Icons.mic),
          ),
        ],
      ),
      body: NotificationListener<NetworkProgressNotification>(
        // ็ๅฌๅญ็ปไปถ่ฏทๆฑๆฏๅฆๅฎๆ
        onNotification: (notification) {
          if (!notification.compeleted) {
            _requestCounter++;
          } else {
            _requestCounter--;
          }
          if (_requestCounter <= 0) {
            _easyRefreshController.finishRefresh();
          }
          return true;
        },
        child: EasyRefresh(
          header: MaterialHeader(
            backgroundColor: Colors.black54,
            valueColor: ColorTween(
              begin: Theme.of(context).primaryColor,
              end: Theme.of(context).primaryColor,
            ).animate(_animationController),
          ),
          enableControlFinishRefresh: true,
          onRefresh: () async {
            setState(() {});
          },
          controller: _easyRefreshController,
          child: ListView(
            children: [
              HomeSwiper(),
              HomeShortcuts(),
              _listTile('ๆจ่ๆญๅ', onTap: () {}),
              RecommendList(
                type: 'playlist',
                url: '/recommend/resource',
                detailUrl: '/playlist/detail?id=',
              ),
              _listTile('ๆจ่MV', onTap: () {}),
              RecommendList(
                type: 'mv',
                url: '/personalized/mv',
                detailUrl: '/mv/url?id=',
              ),
              Builder(builder: (context) {
                return context.watch<PlayerModel>().visibleStatus
                    ? SizedBox(
                        height: 60,
                      )
                    : SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listTile(String title, {void Function()? onTap}) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 5, 5),
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 60),
          child: GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  'ๆดๅค',
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
