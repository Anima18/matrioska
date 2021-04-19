
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'error_message.dart';

typedef void OnSuccess<T>(T data);
typedef void OnError(String message);
typedef void OnProgress(int progress);
typedef T JsonParser<T>(Map<String, dynamic> json);

final  Dio _dio = new Dio(BaseOptions(
  connectTimeout: 10000,
  receiveTimeout: 10000,
));

class HeaderInterceptor extends InterceptorsWrapper {

  final Map<String, String> requestHeaders;

  HeaderInterceptor(this.requestHeaders);

  @override
  Future onRequest(RequestOptions options) {
    options.headers.addAll(requestHeaders);
    return super.onRequest(options);
  }
}

class NetworkRequest<T> {
  //请求地址
  final String url;
  //请求参数
  final Map<String, dynamic> queryParameters;
  //请求body
  final Map<String, dynamic> data;
  //文件保存地址
  final String saveFilePath;
  //请求头
  Map<String, String> requestHeaders;
  //文件上传数据
  final List<String> uploadFiles;

  final JsonParser jsonParser;


  CancelToken _token;

  NetworkRequest({@required this.url,
    this.queryParameters,
    this.data,
    this.requestHeaders,
    this.saveFilePath,
    this.uploadFiles,
    @required this.jsonParser}) {
    if(this.requestHeaders != null) {
      _dio.interceptors.add(HeaderInterceptor(requestHeaders));
    }
    /*(_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client){
      client.findProxy = (uri){
        return "PROXY 192.168.60.177:8888";
      };
    };*/
  }

  Future<T> get({OnSuccess<T> onSuccess, OnError onError}) async {
    T data;
    try {
      Response<Map<String, dynamic>> response = await _dio.get(url, cancelToken: _token, queryParameters: queryParameters);
      data = jsonParser(response.data);
      if(onSuccess != null) {
        onSuccess(data);
      }
    } on DioError catch (e) {
      if(onError != null) {
        onError(ErrorMessage.handleDioError(e));
      }
    }
    return Future<T>(()=>data);
  }

  Future<T> post({OnSuccess<T> onSuccess, OnError onError}) async {
    T data;
    try {
      Response<Map<String, dynamic>> response = await _dio.post(url,
          cancelToken: _token,
          queryParameters: queryParameters,
          data: this.data
      );

      data = jsonParser(response.data);
      if(onSuccess != null) {
        onSuccess(data);
      }
    } on DioError catch (e) {
      if(onError != null) {
        onError(ErrorMessage.handleDioError(e));
      }
    }
    return Future<T>(()=>data);
  }

  Future<String> download({OnSuccess<String> onSuccess, OnProgress onProgress, OnError onError}) async {
    String data;
    try {
      await _dio.download(
        url,
        saveFilePath,
        cancelToken: _token,
        onReceiveProgress: (int count, int total) {
          int progress = count * 100 ~/ total;
          if(onProgress != null) {
            onProgress(progress);
          }
        },
      );

      if(onSuccess != null) {
        onSuccess(saveFilePath);
      }
      data = saveFilePath;
    } on DioError catch (e) {
      if(onError != null) {
        onError(ErrorMessage.handleDioError(e));
      }
    }
    return Future<String>(()=>data);
  }

  Future<T> upload({OnSuccess<T> onSuccess, OnProgress onProgress, OnError onError}) async {
    T data;
    try {
      FormData formData = FormData();
      for(String filePath in uploadFiles) {
        //File file = new File(filePath);
        String fileName = filePath.substring(filePath.lastIndexOf("/")+1);
        var mapEntry = MapEntry(
          "files[]",
          await MultipartFile.fromFile(filePath,
              filename: fileName),
        );

        formData.files.add(mapEntry);
      }

      Response<Map<String, dynamic>> response = await _dio.post(url,
          cancelToken: _token,
          data: formData,
          onSendProgress: (int sent, int total) {
            int progress = sent * 100 ~/ total;
            if(onProgress != null) {
              onProgress(progress);
            }
          });

      data = jsonParser(response.data);
      if(onSuccess != null) {
        onSuccess(data);
      }
    } on DioError catch (e) {
      if(onError != null) {
        onError(ErrorMessage.handleDioError(e));
      }
    }
    return Future<T>(()=>data);
  }

}

