
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:matrioska/util/keyboard_util.dart';

/// 页面状态类型
enum DataState {
  loading,//请求加载
  progress,//请求进度
  success,//请求成功
  error, //请求失败
  empty, //请求数据为空
}

class StatefulData<T>{
  DataState state;    //请求状态
  T data;         //请求数据
  String loadingMessage; //请求信息
  String errorMessage; //请求错误信息
  int _progress;

  StatefulData(); //请求进度



  StatefulData.loading(String message) {
    state = DataState.loading;
    loadingMessage = message;
  }


  StatefulData.error(String message) {
    state = DataState.error;
    errorMessage = message;
  }

  StatefulData.success(T t) {
    state = DataState.success;
    data = t;
  }

  StatefulData.empty() {
    state = DataState.empty;
    errorMessage = "没有数据";
  }

  StatefulData.progress(int value) {
    _progress = value;
    state = DataState.progress;
  }

  @override
  String toString() {
    return 'ViewState{state: $state, data: $data, loadingMessage: $loadingMessage, errorMessage: $errorMessage, _progress: $_progress}';
  }
}

abstract class Indicator {
  void show(String message);
  void close();
}

class StatefulDataMonitor<A> extends Selector0<StatefulData> {
  final void Function(StatefulData) onSuccess;
  final void Function(String) onError;

  StatefulDataMonitor({
    Key key,
    @required this.onSuccess,
    @required this.onError,
    @required StatefulData Function(BuildContext, A) selector,
    @required Widget child,
    Indicator indicator,
  })  : assert(selector != null),
        super(
        key: key,
        builder: (context, viewState, _) {
          switch(viewState.state) {
            case DataState.loading:
              print(viewState.loadingMessage);

              WidgetsBinding.instance.addPostFrameCallback((_){
                indicator?.show(viewState.loadingMessage);
              });
              break;
            case DataState.success:
              indicator?.close();
              KeyboardUtil.hide(context);
              onSuccess(viewState);
              break;
            case DataState.error:
              indicator?.close();
              KeyboardUtil.hide(context);
              onError(viewState.errorMessage);
              break;
            case DataState.progress:
            // TODO: Handle this case.
              break;
          }
          return child;
        },
        selector: (context) => selector(context, Provider.of(context)),
      );
}
