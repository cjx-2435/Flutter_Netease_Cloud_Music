import 'package:flutter/material.dart';

class PlayMVPage extends StatefulWidget {
  const PlayMVPage({Key? key}) : super(key: key);

  @override
  _PlayMVPageState createState() => _PlayMVPageState();
}

class _PlayMVPageState extends State<PlayMVPage> {
  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context)?.settings.arguments);
    return Container(
      color: Colors.green,
    );
  }
}
