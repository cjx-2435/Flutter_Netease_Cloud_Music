
import 'package:demo09/store/player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: context.read<PlayerModel>().getVisibleStatus
          ? Container(
              height: context.watch<PlayerModel>().getHeight,
              width: double.infinity,
              color: Colors.red,
            )
          : SizedBox(
              height: context.watch<PlayerModel>().getHeight,
            ),
    );
  }
}
