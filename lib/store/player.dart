import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayerModel extends ChangeNotifier {
  PlayerModel(this._player);

  AudioPlayer _player;
  String? _currentSong;
  int _current = 0;
  int _total = 0;
  double _percent = 0;
  String _currentDuration = '00:00';
  String _totalDuration = '00:00';
  bool _isPlaying = false;
  bool _isVisible = false;
  bool _isDragging = false;

  void _calcCurrentDuration() {
    int minutes = (_current / 1000 / 60).floor();
    int seconds = ((_current - minutes * 1000 * 60) / 1000).floor();
    _currentDuration =
        '${minutes < 10 ? "0$minutes" : minutes}:${seconds < 10 ? "0$seconds" : seconds}';
  }

  void _calcTotalDuration() {
    int minutes = (_total / 1000 / 60).floor();
    int seconds = ((_total - minutes * 1000 * 60) / 1000).floor();
    _totalDuration =
        '${minutes < 10 ? "0$minutes" : minutes}:${seconds < 10 ? "0$seconds" : seconds}';
  }

  void paused() async {
    int status = await _player.pause();
    notifyListeners();
  }

  void resume() async {
    int status = await _player.resume();
    notifyListeners();
  }

  void seek(int length) async {
    await _player.seek(Duration(milliseconds: length));
    notifyListeners();
  }

  void play(String url) async {
    // 播放状态绑定
    _player.onPlayerStateChanged.listen((status) {
      switch (status) {
        case PlayerState.PLAYING:
          _isPlaying = true;
          break;
        case PlayerState.COMPLETED:
        case PlayerState.PAUSED:
        case PlayerState.STOPPED:
          _isPlaying = false;
          break;
      }
      notifyListeners();
    });

    if (url == _currentSong && _isPlaying) {
      return;
    } else if (url == _currentSong && !_isPlaying) {
      resume();
    } else {
      int released = await _player.release();
      if (released == 1) {
        int status = await _player.play(url);
        if (status == 1) {
          Duration total = await _player.onDurationChanged.first;
          _total = total.inMilliseconds;
          _calcTotalDuration();
          _player.onAudioPositionChanged.listen((position) {
            _current = position.inMilliseconds;
            _calcCurrentDuration();
            if (!_isDragging) {
              _percent = (_current > _total ? _total : _current) / _total;
              notifyListeners();
            }
          });
        }
      }
    }
  }

  set setTotal(int total) {
    _total = total;
    notifyListeners();
  }

  set setCurrent(int length) {
    _current = length;
    notifyListeners();
  }

  set setVisibleStatus(bool status) {
    _isVisible = status;
    notifyListeners();
  }

  set setPercent(double percent) {
    _percent = percent > 1 ? 1 : percent;
    notifyListeners();
  }

  set setDragging(bool stauts) {
    _isDragging = stauts;
  }

  bool get playingStatus => _isPlaying;
  bool get visibleStatus => _isVisible;
  AudioPlayer get audioPlayer => _player;
  int get total => _total;
  int get current => _current;
  double get percent => _percent > 1 ? 1 : _percent;
  String get totalDuration => _totalDuration;
  String get currentDuration => _currentDuration;
}
