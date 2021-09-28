import 'package:flutter/material.dart';

class PlayerModel extends ChangeNotifier {
  PlayerModel();
  double _height = 0;
  bool _isPlaying = false;
  bool _isVisible = false;

  set setPlayingStatus(bool status) {
    _isPlaying = status;
    notifyListeners();
  }

  set setVisibleStatus(bool status) {
    _isVisible = status;
    if (_isVisible)
      _height = 60;
    else
      _height = 0;
    notifyListeners();
  }

  bool get getPlayingStatus => _isPlaying;
  bool get getVisibleStatus => _isVisible;
  double get getHeight => _height;
}
