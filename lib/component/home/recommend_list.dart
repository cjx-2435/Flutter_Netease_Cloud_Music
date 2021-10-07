import 'dart:convert';
import 'dart:developer';

import 'package:demo09/api/config/http_client.dart';
import 'package:demo09/api/config/http_response.dart';
import 'package:demo09/api/transformer/detail_mv.dart';
import 'package:demo09/api/transformer/detail_playlist.dart';
import 'package:demo09/api/transformer/recommend.dart';
import 'package:demo09/model/detail_mv.dart';
import 'package:demo09/model/detail_playlist.dart';
import 'package:demo09/model/play_list.dart';
import 'package:demo09/notify/network_progress.dart';
import 'package:demo09/store/http.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class RecommendList extends StatefulWidget {
  const RecommendList(
      {Key? key,
      required this.type,
      required this.url,
      required this.detailUrl})
      : super(key: key);

  final String type;
  final String url;
  final String detailUrl;

  @override
  _RecommendListState createState() => _RecommendListState();
}

class _RecommendListState extends State<RecommendList> {
  HttpClient? _dio;
  List<PlayList?> playlist = [];

  @override
  void initState() {
    super.initState();
    _dio = context.read<HttpModel>().dio;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('推荐didChangeDependencies');
  }

  @override
  void didUpdateWidget(RecommendList oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('推荐didUpdateWidget调用');
  }

  String formatNum(double num, int postion) {
    if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
        postion) {
      //小数点后有几位小数
      return (num.toStringAsFixed(postion)
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString());
    } else {
      return (num.toString()
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString());
    }
  }

  Future<void> getPlayList() async {
    // 开始发送请求
    NetworkProgressNotification(false).dispatch(context);
    HttpResponse? res = await _dio?.get(
      widget.url,
      httpTransformer: RecommendTransfromer.getInstance(),
    );
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (res?.ok ?? false) {
      playlist.clear();
      // 缓存请求数据
      await sharedPreferences.setStringList(
        widget.url,
        res?.data.map<String>((e) => json.encode(e)).toList(),
      );
      res!.data.forEach((item) {
        playlist.add(PlayList.fromMap(item));
      });
    } else {
      // 当响应完成返回304时，说明请求结果没有变化，使用之前缓存的数据
      if (res?.error?.code == 304) {
        if (sharedPreferences.getStringList(widget.url)?.isNotEmpty ?? false) {
          playlist.clear();
          sharedPreferences
              .getStringList(widget.url)!
              .map<Map<String, dynamic>>((e) => jsonDecode(e))
              .toList()
              .forEach((e) {
            playlist.add(PlayList.fromMap(e));
          });
        }
      } else
        Future.delayed(Duration(seconds: 5), () {
          setState(() {});
        });
    }
    // 请求发送完成
    NetworkProgressNotification(true).dispatch(context);
  }

  Future<void> getPlayListDetail(String url) async {
    HttpResponse? res = await _dio?.get(
      url,
      httpTransformer: DetailPlayListTransfromer.getInstance(),
    );
    if (res?.ok ?? false) {
      List<DetailPlayList> data = res!.data['tracks']
          .map<DetailPlayList>((e) => DetailPlayList.fromMap(e))
          .toList();
      print('开始跳转');
      await Navigator.pushNamed(context, '/PlayList', arguments: {
        'name': res.data['name'],
        'subscribed':res.data['subscribed'],
        'coverImg': Image.network(
          res.data['coverImgUrl'],
          fit: BoxFit.cover,
        ),
        'updateTime': res.data['updateTime'],
        'data': data,
      });
      print('返回');
    } else {
      print(res?.error);
    }
  }

  Future<void> getMVDetail(String url) async {
    HttpResponse? res = await _dio?.get(
      url,
      httpTransformer: DetailMVTransfromer.getInstance(),
    );
    if (res?.ok ?? false) {
      DetailMV mv = DetailMV.fromMap(res!.data);
      await Navigator.pushNamed(context, '/PlayMV', arguments: mv);
    } else {
      print(res?.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('推荐歌单/mv重构');
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: 180),
      child: FutureBuilder(
        future: getPlayList(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return _skeletonWiget();
            case ConnectionState.done:
            default:
              return StatefulBuilder(
                builder: (context, setState) {
                  return _renderPlayList(context);
                },
              );
          }
        },
      ),
    );
  }

  Widget _skeletonWiget() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          child: Column(
            children: [
              Expanded(
                child: Shimmer(
                  child: Container(
                    width: 100,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 7)),
              Shimmer(
                child: Container(
                  width: 80,
                  height: 30,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
      itemCount: 10,
    );
  }

  Widget _renderPlayList(BuildContext context) {
    playlist.forEach((element) {
      if (element!.playcount == null) {
        element.playcount = element.playCount;
      }
    });
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        child: Container(
                          width: 100,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                          ),
                          child: Image.network(
                            playlist[index]!.picUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      Positioned(
                        top: 3,
                        right: 3,
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.headset,
                                color: Colors.grey,
                                size: 12,
                              ),
                              Text(
                                playlist[index]!.playcount! >= 10000
                                    ? (playlist[index]!.playcount! >= 100000000
                                        ? '${formatNum((playlist[index]!.playcount! / 100000000), 2).toString()}亿'
                                        : '${formatNum((playlist[index]!.playcount! / 10000), 2).toString()}万')
                                    : playlist[index]!.playcount.toString(),
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 7)),
                Container(
                  width: 100,
                  height: 40,
                  child: Text(
                    playlist[index]!.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          onTap: () async {
            switch (widget.type) {
              case 'playlist':
                await getPlayListDetail(
                    '${widget.detailUrl}${playlist[index]?.id}');
                break;
              case 'mv':
                await getMVDetail('${widget.detailUrl}${playlist[index]?.id}');
                break;
              default:
                throw new Exception('请求未匹配成功');
            }
          },
        );
      },
      itemCount: playlist.length,
    );
  }
}
