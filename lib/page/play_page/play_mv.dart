import 'package:flutter/material.dart';

class PlayMVPage extends StatefulWidget {
  const PlayMVPage({Key? key}) : super(key: key);

  @override
  _PlayMVPageState createState() => _PlayMVPageState();
}

class _PlayMVPageState extends State<PlayMVPage> {
  @override
  Widget build(BuildContext context) {
    print('****************M V****************');
    print(ModalRoute.of(context)?.settings.arguments);
    print('****************M V****************');
    return Container(
      color: Colors.green,
    );
  }
}
