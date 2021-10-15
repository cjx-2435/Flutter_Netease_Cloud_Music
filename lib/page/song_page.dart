import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SongPage extends StatefulWidget {
  const SongPage({Key? key}) : super(key: key);

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  double _value = 0;
  double _start = 0;
  double _end = 0;
  GlobalKey _progressKey = GlobalKey<State<LinearProgressIndicator>>();

  @override
  void initState() {
    super.initState();
    if (EasyLoading.isShow) EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return Scaffold(
      body: Container(
        color: Colors.black54,
        constraints: BoxConstraints.expand(),
        child: Column(
          children: [
            _title(),
            _poster(),
            _progress(),
            _bottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return SafeArea(
      child: ListTile(
        title: Text(
          '主标题',
          style: TextStyle(color: Colors.white70, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        subtitle: Text(
          '副标题',
          style: TextStyle(color: Colors.white54, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _poster() {
    return Expanded(
      child: Center(
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
                child: Image.asset(
                  'asset/images/image.webp',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _progress() {
    return StatefulBuilder(builder: (context, setState) {
      return Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              '00:00',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                height: 40,
                child: Align(
                  child: LinearProgressIndicator(
                    key: _progressKey,
                    color: Theme.of(context).primaryColor,
                    backgroundColor: Colors.grey,
                    value: _value,
                  ),
                  alignment: Alignment.center,
                ),
              ),
              onHorizontalDragStart: (e) {
                _value += 0.01;
                _start = e.localPosition.dx;
                setState(() {});
                print('拖拽起点：$_start');
              },
              onHorizontalDragEnd: (e) {
                if (_value > 0) {
                  _value += 0.01;
                }
                // double width = _progressKey.currentContext!.size!.width;
                double _end = e.velocity.pixelsPerSecond.dx;
                setState(() {});
                print('拖拽结束点：$_end');
                print(_end - _start);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              '03:12',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      );
    });
  }

  Widget _bottomBar() {
    return Container(
      height: 80,
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
        onPressed: () {
          setState(() {});
          print('喜欢');
        },
        icon: Icon(
          Icons.favorite_border,
          color: color,
        ),
        iconSize: size,
      );
    });
  }

  Widget _prev(Color? color, double size) {
    return IconButton(
      onPressed: () {
        print('上一首');
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
        onPressed: () {
          setState(() {});
          print('播放/暂停');
        },
        icon: Icon(
          Icons.play_circle_outline,
          color: color,
        ),
        iconSize: size,
      );
    });
  }

  Widget _next(Color? color, double size) {
    return IconButton(
      onPressed: () {
        print('下一首');
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
