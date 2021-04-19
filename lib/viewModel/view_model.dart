
import 'package:flutter/material.dart';

class ViewModel extends ChangeNotifier {
  /// 防止页面销毁后,异步任务才完成,导致报错
  bool _disposed = false;


  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    // debugPrint('view_state_model dispose -->$runtimeType');
    super.dispose();
  }
}
