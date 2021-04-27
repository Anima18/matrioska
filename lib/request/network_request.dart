import 'dart:async';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'error_message.dart';

///成功回调
typedef void OnSuccess<T>(T data);

///错误回调
typedef void OnError(String message);

///请求进度回调
typedef void OnProgress(double progress);

///数据解析器
typedef T Transformer<T>(Map<String, dynamic>? json);

final Dio _dio = new Dio(BaseOptions(
  connectTimeout: 10000,
  receiveTimeout: 10000,
));

class RequestError implements Exception {
  final String message;
  RequestError(this.message);
}

class HeaderInterceptor extends InterceptorsWrapper {
  final Map<String, String>? requestHeaders;

  HeaderInterceptor(this.requestHeaders);


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(requestHeaders!);
    super.onRequest(options, handler);
  }
}

class NetworkRequest<T> {
  //请求地址
  final String url;
  //请求参数
  final Map<String, dynamic>? queryParameters;
  //请求body
  final Map<String, dynamic>? data;
  //请求头
  Map<String, String>? requestHeaders;
  //文件上传数据
  final List<String>? uploadFiles;
  //json数据解析
  final Transformer transformer;

  CancelToken? _token;

  static void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  static void setProxy(String proxy) {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client){
      client.findProxy = (uri){
        return "PROXY $proxy";
      };
    };
  }

  NetworkRequest({
      required this.url,
      required this.transformer,
      this.queryParameters,
      this.data,
      this.requestHeaders,
      this.uploadFiles,
      }) {
    if (this.requestHeaders != null) {
      _dio.interceptors.add(HeaderInterceptor(requestHeaders));
    }

  }

  void handleError(Exception e) {
    String message;
    if (e is DioError) {
      message = ErrorMessage.handleDioError(e);
    } else if (e is RequestError) {
      message = e.message;
    } else {
      message = e.toString();
    }
    throw RequestError(message);
  }

  Future<T> get() async {
    return await (_dio
        .get(url, cancelToken: _token, queryParameters: queryParameters)
        .then((response) => transformer(response.data))
        .catchError((e) {handleError(e);}));

  }

  Future<T> post() async {
    return await (_dio
        .post(url,
            cancelToken: _token,
            queryParameters: queryParameters,
            data: this.data)
        .then((response) => transformer(response.data))
        .catchError((e) {handleError(e);}));

  }

  Future<String> download({required String savePath, OnProgress? onProgress}) async {
    return await _dio.download(
      url,
      savePath,
      cancelToken: _token,
      onReceiveProgress: (int count, int total) {
        double progress = (count * 100 ~/ total).toDouble();
        if (onProgress != null) {
            onProgress(progress);
          }
      },
    ).then((response) {
      return savePath;
    }).catchError((e) {handleError(e);});
  }

  /*Future<T?> upload({OnSuccess<T?>? onSuccess, OnProgress? onProgress, OnError? onError}) async {
    T? data;
    try {
      FormData formData = FormData();
      for (String filePath in uploadFiles!) {
        //File file = new File(filePath);
        String fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
        var mapEntry = MapEntry(
          "files[]",
          await MultipartFile.fromFile(filePath, filename: fileName),
        );

        formData.files.add(mapEntry);
      }

      Response<Map<String, dynamic>> response = await _dio.post(url,
          cancelToken: _token,
          data: formData, onSendProgress: (int sent, int total) {
            double progress = (sent * 100 ~/ total).toDouble();;
        if (onProgress != null) {
          onProgress(progress);
        }
      });

      data = transformer(response.data);
      if (onSuccess != null) {
        onSuccess(data);
      }
    } catch (e) {
      handleError(e);
    }

    return data;
  }*/
}
