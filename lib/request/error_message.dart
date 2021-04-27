import 'package:dio/dio.dart';

class ErrorMessage {

  static String handleDioError(DioError err) {
    String message = err.message;
    DioErrorType type = err.type;
    if (type == DioErrorType.connectTimeout ||
        type == DioErrorType.receiveTimeout) {
      message = "请求服务超时!";
    } else if (type == DioErrorType.response) {
      int statusCode = err.response!.statusCode!;
      if (statusCode >= 300 && statusCode < 400) {
        message = "请求重定向";
      } else if (statusCode >= 400 && statusCode < 500) {
        message = "请求包含语法错误或者请求无法实现";
      } else if (statusCode >= 500 && statusCode < 600) {
        message = "服务器遇到错误，无法完成请求";
      }
    } else if (type == DioErrorType.cancel) {
      message = "你取消了请求!";
    } else if (type == DioErrorType.other) {
      if (err.message.contains("FormatException")) {
        message = "请求URL格式不正确!";
      } else if (err.message.contains("Connection failed") || err.message.contains("Connection refused")) {
        message = "连接服务器失败,请检查网络或服务器是否开启";
      } else if(err.message.contains("No such file or directory")) {
        message = "上传的文件不存在";
      }
    }
    return message;
  }

}
