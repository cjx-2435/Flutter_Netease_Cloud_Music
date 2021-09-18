import 'package:flutter/cupertino.dart';

class ShortcutsModel {
  ShortcutsModel({
    required this.icon,
    required this.label,
  });
  ShortcutsModel.fromMap(Map<String, dynamic> map)
      : icon = map['icon'],
        label = map['label'];
  Icon icon;
  String label;
}
