import 'package:demo09/api/config/http_response.dart';
import 'package:demo09/api/config/http_transformer.dart';
import 'package:dio/dio.dart';

class DetailMVTransfromer extends HttpTransformer {
  @override
  HttpResponse parse(Response response) {
    if (response.data["code"] == 200 && response.data['data'] != null) {
      return HttpResponse.success(response.data['data']);
    }else {
      return HttpResponse.failure(
          errorMsg: response.data["message"], errorCode: response.data["code"]);
    }
  }

  /// 单例对象
  static DetailMVTransfromer _instance = DetailMVTransfromer._internal();

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  DetailMVTransfromer._internal();

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory DetailMVTransfromer.getInstance() => _instance;
}
