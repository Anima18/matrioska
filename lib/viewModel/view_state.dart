
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:matrioska/util/keyboard_util.dart';

/// 页面状态类型
enum DataState {
  loading,//请求加载
  progress,//请求进度
  success,//请求成功
  error, //请求失败
  empty, //请求数据为空
  complete, //请求完成
}

class StatefulData<T>{
  DataState state;    //请求状态
  T data;         //请求数据
  String loadingMessage; //请求信息
  String errorMessage; //请求错误信息
  double progress;
  bool consume = false;

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

  StatefulData.complete() {
    state = DataState.complete;
  }

  StatefulData.progress(double value) {
    progress = value;
    state = DataState.progress;
  }

  @override
  String toString() {
    return 'ViewState{state: $state, data: $data, loadingMessage: $loadingMessage, errorMessage: $errorMessage, _progress: $progress}';
  }
}

abstract class Indicator {
  void show(String message);
  void close();
}

class StatefulDataMonitor<A> extends Selector0<StatefulData> {

  StatefulDataMonitor({
    Key key,
    Function(StatefulData) onSuccess,
    Function(String) onError,
    @required StatefulData Function(BuildContext, A) selector,
    @required ValueWidgetBuilder<StatefulData> builder,
  })  : assert(selector != null),
        super(
        key: key,
        builder: (context, viewState, child) {
          print(viewState.toString());
          if(!viewState.consume) {
            switch(viewState.state) {
              case DataState.loading:
                EasyLoading.show(status: viewState.loadingMessage);
                break;
              case DataState.success:
                EasyLoading.dismiss();
                break;
              case DataState.error:
                EasyLoading.dismiss();
                break;
              case DataState.progress:
                WidgetsBinding.instance.addPostFrameCallback((_){
                  EasyLoading.showProgress(viewState.progress,
                      status: '${(viewState.progress * 100).toStringAsFixed(0)}%');
                });

                break;
              case DataState.empty:
                // TODO: Handle this case.
                break;
              case DataState.complete:
                EasyLoading.dismiss();
                break;
            }
            viewState.consume = true;
          }

          return builder(context, viewState, child);
        },
        selector: (context) => selector(context, Provider.of(context)),
      );
}
