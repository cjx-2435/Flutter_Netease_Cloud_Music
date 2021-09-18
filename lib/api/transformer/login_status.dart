import 'package:demo09/api/config/http_response.dart';
import 'package:demo09/api/config/http_transformer.dart';
import 'package:dio/dio.dart';

class LoginStatusTransfromer extends HttpTransformer {
  @override
  HttpResponse parse(Response response) {
    if (response.data['data']["code"] == 200 &&
        response.data['data']["account"] != null) {
      return HttpResponse.success(response.data['data']);
    } else {
      if (response.data['data']['account'] == null) {
        return HttpResponse.failure(
          errorMsg: '状态:未登录',
          errorCode: response.data["code"],
        );
      }
      return HttpResponse.failure(
          errorMsg: response.data["message"], errorCode: response.data["code"]);
    }
  }

  /// 单例对象
  static LoginStatusTransfromer _instance = LoginStatusTransfromer._internal();

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  LoginStatusTransfromer._internal();

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory LoginStatusTransfromer.getInstance() => _instance;
}
