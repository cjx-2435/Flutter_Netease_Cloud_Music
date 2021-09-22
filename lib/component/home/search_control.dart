import 'package:flutter/material.dart';

class SearchControl extends StatefulWidget {
  const SearchControl({Key? key}) : super(key: key);

  @override
  _SearchControlState createState() => _SearchControlState();
}

class _SearchControlState extends State<SearchControl> {
  String _search = '';
  TextEditingController? _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: _search);
    _textEditingController?.addListener(() {
      _search = _textEditingController!.text;
      setState(() {});
      print(_search);
    });
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Home 搜索框重构');
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
        child: TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIconConstraints:
                BoxConstraints.tightFor(width: 45, height: 30),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            hintStyle: TextStyle(color: Colors.white),
            hintText: '搜索音乐',
          ),
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.grey,
        ),
      ),
    );
  }
}


