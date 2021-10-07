import 'package:demo09/model/detail_playlist.dart';
import 'package:flutter/material.dart';

class PlayListPage extends StatefulWidget {
  const PlayListPage({Key? key}) : super(key: key);

  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  bool? subscribed;
  String? name;
  Image? coverImg;
  String? updateTime;
  List<DetailPlayList>? list;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic data = ModalRoute.of(context)?.settings.arguments;
    name = data?['name'];
    subscribed = data?['subscribed'] ?? false;
    coverImg = data?['coverImg'];
    DateTime time = DateTime.fromMillisecondsSinceEpoch(data?['updateTime']);
    updateTime =
        "最近更新：${time.year == DateTime.now().year ? '' : time.year.toString() + '年'} ${time.month}月 ${time.day}日";
    list = data?['data'];
    print('subscribed$subscribed');
    return Material(
      child: CustomScrollView(
        slivers: [
          _renderAppBar(),
          _renderList(),
        ],
      ),
    );
  }

  Widget _renderAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 280,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          name ?? '',
          style: TextStyle(fontSize: 16),
        ),
        background: Stack(
          children: [
            SizedBox.expand(child: coverImg),
            Positioned(
              left: 5,
              bottom: 5,
              child: Text(
                updateTime ?? '',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == 0) {
          return Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              border: Border.all(width: 1, color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(Icons.play_circle_outline),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Text(
                    '播放全部 (共${list!.length}首)',
                    textScaleFactor: 1.4,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print('收藏状态:$subscribed');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(18),
                        ),
                        color: subscribed!
                            ? Colors.grey[300]
                            : Theme.of(context).primaryColor,
                      ),
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.center,
                      child: subscribed!
                          ? Text('取消收藏', style: TextStyle(color: Colors.black))
                          : Text('收藏', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else
          return InkWell(
            child: Container(
              constraints: BoxConstraints.tightFor(height: 70),
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 50,
                            height: 50,
                            child: Text(
                              index.toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  list![index - 1].name,
                                  style: TextStyle(fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${list![index - 1].ar_name.join('/')} - ${list![index - 1].al_name}",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  index == list!.length
                      ? SizedBox()
                      : Divider(
                          color: Colors.grey,
                          height: 1,
                          indent: 0,
                        ),
                ],
              ),
            ),
          );
      }, childCount: list!.length + 1),
    );
  }
}
