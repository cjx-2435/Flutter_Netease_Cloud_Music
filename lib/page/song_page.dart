import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo09/api/config/http_client.dart';
import 'package:demo09/api/config/http_response.dart';
import 'package:demo09/model/detail_playlist.dart';
import 'package:demo09/store/http.dart';
import 'package:demo09/store/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SongPage extends StatefulWidget {
  const SongPage({Key? key}) : super(key: key);

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage>
    with SingleTickerProviderStateMixin {
  late HttpClient _dio;
  List<DetailPlayList>? _list;
  int? _index;
  late AnimationController _animationController;
  bool _isLike = false;

  Future<void> _getSongDetail() async {
    HttpResponse song = await _dio.get('/song/url?id=${_list![_index!].id}');
    if (song.ok) {
      context.read<PlayerModel>().play(song.data['data'][0]['url']);
    }
    await _isLikeMusic();
  }

  Future<void> _isLikeMusic() async {
    HttpResponse like =
        await _dio.get('/likelist?t=${DateTime.now().millisecondsSinceEpoch}');
    if (like.ok) {
      List<int> list = like.data['ids'].cast<int>();
      _isLike = list.contains(_list![_index!].id);
    }
  }

  @override
  void initState() {
    super.initState();
    _dio = context.read<HttpModel>().dio;
    _animationController =
        AnimationController(duration: Duration(seconds: 6), vsync: this);
  }

  @override
  void deactivate() async {
    super.deactivate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dynamic args = ModalRoute.of(context)?.settings.arguments;
    _list = args['list'];
    _index = args['index'];
    if ((_list?.isEmpty ?? false)) {
      throw new Exception('关键值为空');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black54,
        constraints: BoxConstraints.expand(),
        child: FutureBuilder(
          future: _getSongDetail(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return SpinKitWave(
                  color: Theme.of(context).primaryColor,
                  size: 32,
                );
              case ConnectionState.done:
              default:
                return Column(
                  children: [
                    _title(),
                    _poster(),
                    _progress(),
                    _bottomBar(),
                  ],
                );
            }
          },
        ),
      ),
    );
  }

  Widget _title() {
    return SafeArea(
      child: ListTile(
        title: Text(
          '${_list![_index!].name}',
          style: TextStyle(color: Colors.white70, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        subtitle: Text(
          "${_list![_index!].ar_name.join('/')}${_list![_index!].al_name != '' ? ' - ${_list![_index!].al_name}' : ''}",
          style: TextStyle(color: Colors.white54, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _poster() {
    return Expanded(
      child: Center(
        child: Builder(builder: (context) {
          if (context.watch<PlayerModel>().playingStatus) {
            _animationController.repeat();
          } else
            _animationController.stop();
          return RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(140),
              ),
              constraints: BoxConstraints.tightFor(width: 280, height: 280),
              child: UnconstrainedBox(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 200),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: '${_list![_index!].picUrl}',
                      placeholder: (context, url) => SpinKitFadingCircle(
                        color: Theme.of(context).primaryColor,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _progress() {
    return StatefulBuilder(
      builder: (context, setState) {
        int total = context.read<PlayerModel>().total;
        return Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                context.watch<PlayerModel>().currentDuration,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  thumbColor: Colors.redAccent,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4),
                  activeTrackColor: Colors.redAccent,
                  inactiveTrackColor: Colors.grey[800],
                  overlayColor: Colors.transparent,
                ),
                child: Slider.adaptive(
                  value: context.watch<PlayerModel>().percent,
                  onChanged: (v) {
                    context.read<PlayerModel>().setDragging = true;
                    context.read<PlayerModel>().setPercent = v;
                  },
                  onChangeEnd: (v) {
                    context.read<PlayerModel>().seek((total * v).floor());
                    context.read<PlayerModel>().setDragging = false;
                    context.read<PlayerModel>().resume();
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: Text(
                context.read<PlayerModel>().totalDuration,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _bottomBar() {
    return Container(
      height: 60,
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _like(Colors.white70, 26),
          _prev(Colors.white70, 36),
          _play(Colors.white70, 46),
          _next(Colors.white70, 36),
          _comment(Colors.white70, 26),
        ],
      ),
    );
  }

  Widget _like(Color? color, double size) {
    return StatefulBuilder(builder: (context, setState) {
      return IconButton(
        onPressed: () async {
          HttpResponse res = await _dio.get(
              '/like?id=${_list![_index!].id}&like=${!_isLike}&t=${DateTime.now().millisecondsSinceEpoch}');
          if (res.ok) {
            await _isLikeMusic();
            setState(() {});
          }
        },
        icon: Icon(
          _isLike ? Icons.favorite : Icons.favorite_border,
          color: _isLike ? Theme.of(context).primaryColor : color,
        ),
        iconSize: size,
      );
    });
  }

  Widget _prev(Color? color, double size) {
    return IconButton(
      onPressed: () {
        _index = _index == 0 ? (_list!.length - 1) : _index! - 1;
        setState(() {});
      },
      icon: Icon(
        Icons.skip_previous,
        color: color,
      ),
      iconSize: size,
    );
  }

  Widget _play(Color? color, double size) {
    return StatefulBuilder(builder: (context, setState) {
      return IconButton(
        onPressed: () async {
          if (context.read<PlayerModel>().playingStatus) {
            context.read<PlayerModel>().paused();
          } else
            context.read<PlayerModel>().resume();
        },
        icon: Icon(
          context.watch<PlayerModel>().playingStatus
              ? Icons.pause_circle_outline
              : Icons.play_circle_outline,
          color: color,
        ),
        iconSize: size,
      );
    });
  }

  Widget _next(Color? color, double size) {
    return IconButton(
      onPressed: () {
        _index = _index == _list!.length - 1 ? 0 : (_index! + 1);
        setState(() {});
      },
      icon: Icon(
        Icons.skip_next,
        color: color,
      ),
      iconSize: size,
    );
  }

  Widget _comment(Color? color, double size) {
    return IconButton(
      onPressed: () {
        print('评论');
      },
      icon: Icon(
        Icons.mode_comment,
        color: color,
        size: size,
      ),
      iconSize: size,
    );
  }
}
