

import 'package:demo09/api/config/http_response.dart';
import 'package:dio/dio.dart';

abstract class HttpTransformer {
  HttpResponse parse(Response response);
}
