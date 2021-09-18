import 'package:demo09/api/config/index.dart';
import 'package:flutter/material.dart';

class HttpModel extends ChangeNotifier {
  HttpModel(this._dio);
  HttpClient _dio;

  HttpClient get dio => _dio;
}
