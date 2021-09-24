import 'package:flutter/material.dart';

class RefreshModel extends ChangeNotifier {
  RefreshModel();
  bool _onRefresh = false;

  bool get onRefresh => _onRefresh;
  set onRefresh(bool status) {
    _onRefresh = status;
    notifyListeners();
  }
}
