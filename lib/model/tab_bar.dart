import 'package:flutter/cupertino.dart';

class TabBarModel {
  TabBarModel({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
    this.active = false,
  });
  TabBarModel.fromMap(Map<String, dynamic> map)
      : this.activeIcon = map['activeIcon'],
        this.inactiveIcon = map['inactiveIcon'],
        this.label = map['label'],
        this.active = map['active'] ?? false;
  Icon activeIcon;
  Icon inactiveIcon;
  String label;
  bool active;
}
