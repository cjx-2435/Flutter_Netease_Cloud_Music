import 'package:demo09/api/config/http_client.dart';
import 'package:demo09/api/config/http_response.dart';
import 'package:demo09/api/transformer/recommend.dart';
import 'package:demo09/model/play_list.dart';
import 'package:demo09/store/http.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class RecommendPlayList extends StatefulWidget {
  const RecommendPlayList({Key? key}) : super(key: key);

  @override
  _RecommendPlayListState createState() => _RecommendPlayListState();
}

class _RecommendPlayListState extends State<RecommendPlayList> {
  HttpClient? _dio;
  List<PlayList?> playlist = [];

  @override
  void initState() {
    super.initState();
    _dio = context.read<HttpModel>().dio;
  }

  Future<void> _getPlayList() async {
    HttpResponse? res = await _dio?.get(
      '/recommend/resource?${DateTime.now().millisecondsSinceEpoch}',
      httpTransformer: RecommendTransfromer.getInstance(),
    );
    if (res?.ok ?? false) {
      playlist.clear();
      res!.data.forEach((item) {
        playlist.add(PlayList.fromMap(item));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: 180),
      child: FutureBuilder(
        future: _getPlayList(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return _skeletonWiget();
            case ConnectionState.done:
            default:
              return _renderPlayList();
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
                  height: 20,
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

  Widget _renderPlayList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
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
              ),
              Padding(padding: EdgeInsets.only(bottom: 7)),
              Container(
                width: 100,
                height: 20,
                child: Text(
                  playlist[index]!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: playlist.length,
    );
  }
}
