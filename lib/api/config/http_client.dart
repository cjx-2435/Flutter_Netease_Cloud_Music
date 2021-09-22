import 'package:demo09/api/config/app_dio.dart';
import 'package:demo09/api/config/http_config.dart';
import 'package:demo09/api/config/http_parse.dart';
import 'package:demo09/api/config/http_response.dart';
import 'package:demo09/api/config/http_transformer.dart';
import 'package:dio/dio.dart';

class HttpClient {
  late AppDio _dio;

  HttpClient({BaseOptions? options, HttpConfig? dioConfig})
      : _dio = AppDio(options: options, dioConfig: dioConfig);

  // /// 单例对象
  // static HttpClient _instance = HttpClient._internal();

  // /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  // HttpClient._internal({BaseOptions? options, HttpConfig? dioConfig})
  //     : _dio = AppDio(options: options, dioConfig: dioConfig);

  // /// 工厂构造方法，这里使用命名构造函数方式进行声明
  // factory HttpClient.getInstance(
  //     {BaseOptions? options, HttpConfig? dioConfig}) {
  //   return _instance =
  //       HttpClient._internal(dioConfig: dioConfig, options: options);
  // }

  Future<HttpResponse> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    HttpTransformer? httpTransformer,
  }) async {
    try {
      var response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  Future<HttpResponse> post(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      HttpTransformer? httpTransformer}) async {
    try {
      var response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  Future<HttpResponse> patch(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      HttpTransformer? httpTransformer}) async {
    try {
      var response = await _dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  Future<HttpResponse> delete(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      HttpTransformer? httpTransformer}) async {
    try {
      var response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  Future<HttpResponse> put(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      HttpTransformer? httpTransformer}) async {
    try {
      var response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  Future<Response> download(String urlPath, savePath,
      {ProgressCallback? onReceiveProgress,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      bool deleteOnError = true,
      String lengthHeader = Headers.contentLengthHeader,
      data,
      Options? options,
      HttpTransformer? httpTransformer}) async {
    try {
      var response = await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: data,
      );
      return response;
    } catch (e) {
      throw e;
    }
  }
}


