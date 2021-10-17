import 'package:demo09/api/config/http_client.dart';
import 'package:demo09/api/config/http_response.dart';
import 'package:demo09/model/detail_playlist.dart';
import 'package:demo09/model/playlist_data.dart';
import 'package:demo09/store/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class PlayListPage extends StatefulWidget {
  const PlayListPage({Key? key}) : super(key: key);

  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  PlayListData? data;
  String updateTime = '';
  List<int> likelist = [];
  List<DetailPlayList>? list;
  late HttpClient _dio;

  @override
  void initState() {
    super.initState();
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    _dio = context.read<HttpModel>().dio;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dynamic args = ModalRoute.of(context)?.settings.arguments;
    data = args['detail'];
    DateTime time = DateTime.fromMillisecondsSinceEpoch(data!.updateTime);
    updateTime =
        "最近更新：${time.year == DateTime.now().year ? '' : time.year.toString() + '年'} ${time.month}月 ${time.day}日";
    list = args['data'];
  }

  Future<void> _likelist() async {
    HttpResponse res =
        await _dio.get('/likelist?t=${DateTime.now().millisecondsSinceEpoch}');
    if (res.ok) {
      likelist = res.data['ids'].cast<int>();
    }
  }

  void _subscribe() async {
    HttpResponse res = await _dio.post(
        '/playlist/subscribe?t=${data!.subscribed! ? 2 : 1}&id=${data!.id}&timestamp=${DateTime.now().millisecondsSinceEpoch}');
    if (res.ok) {
      data!.subscribed = !data!.subscribed!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: _likelist(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return SizedBox();
            case ConnectionState.done:
            default:
              return CustomScrollView(
                slivers: [
                  _renderAppBar(),
                  _renderList(),
                ],
              );
          }
        },
      ),
    );
  }

  Widget _renderAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 280,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          data!.name,
          style: TextStyle(fontSize: 16),
        ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                data!.coverImgUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 5,
              bottom: 5,
              child: Text(
                updateTime,
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
                    '全部共${list!.length}首',
                    textScaleFactor: 1.4,
                  ),
                ),
                Expanded(
                  child: Ink(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: data!.subscribed!
                          ? Colors.grey[300]
                          : Theme.of(context).primaryColor,
                    ),
                    child: _subscribeControl(),
                  ),
                ),
              ],
            ),
          );
        } else
          return InkWell(
            splashColor: Theme.of(context).hoverColor,
            onTap: () async {
              await Navigator.pushNamed(context, '/SongPage', arguments: {
                'list': list,
                'index': index - 1,
              });
              setState(() {});
            },
            child: Container(
              constraints: BoxConstraints.tightFor(height: 70),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _numTag(index),
                        Expanded(
                          child: Row(
                            children: [
                              _songInfo(index),
                              _likeButton(index),
                            ],
                          ),
                        )
                      ],
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

  Widget _subscribeControl() {
    return data!.subscribed!
        ? _collectionControl(
            text: '取消收藏',
            textColor: Colors.black,
            splashColor: Colors.grey[100],
            onTap: () {
              _subscribe();
            })
        : _collectionControl(
            text: '+收藏(${data!.subscribedCount})',
            textColor: Colors.white,
            splashColor: Colors.redAccent,
            onTap: () {
              _subscribe();
            },
          );
  }

  Widget _numTag(index) {
    return Container(
      alignment: Alignment.center,
      width: 50,
      height: 50,
      child: Text(
        index.toString(),
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _songInfo(index) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            list![index - 1].name,
            style: TextStyle(fontSize: 18),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            "${list![index - 1].ar_name.join('/')}${list![index - 1].al_name != '' ? ' - ${list![index - 1].al_name}' : ''}",
            style: TextStyle(fontSize: 16, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _likeButton(index) {
    return StatefulBuilder(
      builder: (context, setState) {
        return IconButton(
          onPressed: () async {
            HttpResponse res = await _dio.get(
                '/like?id=${list![index - 1].id}&like=${!likelist.contains(list![index - 1].id)}&t=${DateTime.now().millisecondsSinceEpoch}');
            if (res.ok) {
              setState(() {});
            }
          },
          icon: likelist.contains(list![index - 1].id)
              ? Icon(
                  Icons.favorite,
                  color: Theme.of(context).primaryColor,
                )
              : Icon(
                  Icons.favorite_border,
                  color: Colors.grey,
                ),
        );
      },
    );
  }

  Widget _collectionControl({
    required String text,
    Color? textColor,
    Color? splashColor,
    void Function()? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(18),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          textScaleFactor: 1.4,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: textColor),
        ),
      ),
      splashColor: splashColor,
      onTap: onTap,
    );
  }
}
