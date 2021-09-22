import 'package:demo09/iconfont/index.dart';
import 'package:demo09/model/shortcuts.dart';
import 'package:flutter/material.dart';

class HomeShortcuts extends StatefulWidget {
  const HomeShortcuts({Key? key}) : super(key: key);

  @override
  _HomeShortcutsState createState() => _HomeShortcutsState();
}

class _HomeShortcutsState extends State<HomeShortcuts> {
  List<ShortcutsModel> list = [];
  double size = 20;

  @override
  void initState() {
    super.initState();
    list.addAll(
      [
        {
          'icon': iconPersonalFM(
            size: size,
            color: Colors.red,
          ),
          'label': '私人FM',
        },
        {
          'icon': iconCalendar(
            size: size,
            color: Colors.red,
          ),
          'label': '每日推荐',
        },
        {
          'icon': iconMusicList(
            size: 28,
            color: Colors.red,
          ),
          'label': '歌单',
        },
        {
          'icon': iconRank(
            size: size,
            color: Colors.red,
          ),
          'label': '排行榜',
        },
      ].map(
        (e) => ShortcutsModel.fromMap(e),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('Home 捷径图标按钮重构');
    return ConstrainedBox(
      constraints: BoxConstraints.tight(
        Size(360, 90),
      ),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 45,
                  height: 45,
                  child: CircleAvatar(
                    child: list[index].icon,
                    backgroundColor: Color(0x45d59c9c),
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 5)),
                Text(
                  list[index].label,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            onTap: () {
              print(index);
            },
          );
        },
      ),
    );
  }
}
