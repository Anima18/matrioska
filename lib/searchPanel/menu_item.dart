import 'package:matrioska/viewModel/view_state.dart';

import '../tree/tree_data.dart';

///查询工具栏菜单基类
class MenuItem {
  bool selected;
  final String code;
  final String name;
  String text;
  List<String?> valueList;
  MenuItem(this.code, this.name) : this.text = "", this.selected = false, this.valueList = [];

  void setValue(String? value) {
    valueList.clear();
    if(value != null && value.isNotEmpty) {
      valueList.add(value);
    }
  }

  void addValue(String? value) {
    valueList.add(value);
  }

  @override
  String toString() {
    return 'MenuItem{selected: $selected, code: $code, name: $name, text: $text, valueList: $valueList}';
  }
}


///输入菜单
class InputMenuItem extends MenuItem {
  InputMenuItem(String code, String name) : super(code, name);
  InputMenuItem.defaultValue(String code, String name, String defaultValue) : super(code, name) {
    this.text = defaultValue;
    this.valueList.add(defaultValue);
  }
}


///列表选择菜单
typedef OnRequestDataListener = void Function(DataChangeCallback callback);
abstract class DataChangeCallback {
  void onLoading();
  void onSuccess(List<ListItem> dataList);
  void onError(String message);
}
class ListItem{
  final String code;
  final String text;
  bool selected = false;
  bool showed = true;

  ListItem(this.code, this.text);
}

class ListMenuItem extends MenuItem {
  List<ListItem> dataList = [];
  OnRequestDataListener? dataListener;
  DataState viewStatus = DataState.loading;
  String? message;
  ///当前树列表滚动的位置
  double scrollOffset = 0.0;

  ListMenuItem(String code, String name) : super(code, name);

  ListMenuItem.static(String code, String name, List<ListItem> dataList) : super(code, name) {
    this.dataList = dataList;
  }

  ListMenuItem.network(String code, String name, OnRequestDataListener dataListener) : super(code, name) {
    this.dataListener = dataListener;
  }
}


///时间间隔菜单
enum DateFormatValue {
  yyyyMMdd, yyyyMMddHHmmss

}
class DateIntervalMenuItem extends MenuItem {
  List<ListItem> dataList = <ListItem>[
    ListItem("今天", "今天"),
    ListItem("一周内", "一周内"),
    ListItem("一月内", "一月内"),
    ListItem("三月内", "三月内"),
    ListItem("一年内", "一年内")
  ];
  final DateFormatValue format;
  DateIntervalMenuItem(String code, String name, this.format) : super(code, name);

  String getDateTimeFormat() {
    switch(format) {
      case DateFormatValue.yyyyMMdd:
        return "yyyy-MM-dd";
      case DateFormatValue.yyyyMMddHHmmss:
        return "yyyy-MM-dd HH:mm:ss";
      default:
        return "yyyy-MM-dd HH:mm:ss";
    }
  }
}

///树结构菜单
typedef OnRequestTreeDataListener = void Function(TreeDataChangeCallback callback);
abstract class TreeDataChangeCallback {
  void onLoading();
  void onSuccess(List<TreeData> dataList);
  void onError(String message);
}
class TreeMenuItem extends MenuItem {
  final OnRequestTreeDataListener dataListener;
  List<TreeData> dataList = [];
  DataState viewStatus = DataState.loading;
  String? message;
  ///当前树列表滚动的位置
  double scrollOffset = 0.0;

  TreeMenuItem(String code, String name,this.dataListener) : super(code, name);

  void clear(List<TreeData> treeDataList) {
    treeDataList.forEach((element) {
      element.selected = false;
      if(element.children != null) {
        clear(element.children!);
      }
    });
  }
}