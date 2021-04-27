import 'package:flutter/material.dart';

class GlobalDialog {
  final navigatorKey = GlobalKey<NavigatorState>();

  static GlobalDialog? _instance;
  static GlobalDialog? get instance => _getInstance();

  static GlobalKey<NavigatorState> init() {
    return _getInstance()!.navigatorKey;
  }

  GlobalDialog._internal();

  static GlobalDialog? _getInstance() {
    if (_instance == null) _instance = GlobalDialog._internal();
    return _instance;
  }

  static void show(String message, {String title="提示", VoidCallback? okCallback, VoidCallback? cancelCallback, bool cancelable = false}) {
    final context = _instance!.navigatorKey.currentState!.overlay!.context;
    List<Widget> actions = [];
    if(okCallback != null) {
      actions.add(FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
            okCallback();
          },
          child: Text("确定")));
    }
    if(cancelCallback != null) {
      actions.add(FlatButton(onPressed: () {
        Navigator.of(context).pop();
        cancelCallback();
      }, child: Text("取消")));
    }
    final dialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: actions,
    );
    showDialog(context: context, barrierDismissible: cancelable, builder: (x) => dialog);
  }
}