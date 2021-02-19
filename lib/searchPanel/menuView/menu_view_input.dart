import 'package:flutter/material.dart';
import '../../common/constant.dart' as constant;
import '../../common/widget.dart';

import '../menu_item.dart';
import '../searchBar.dart';
import 'menu_view.dart';

class InputMenuView extends MenuView {
  final MenuItem menuItem;
  final SearchBarCallback callback;

  InputMenuView(this.menuItem, this.callback);


  @override
  _InputState createState() {
    return _InputState();
  }

  @override
  void onSearch() {
    callback.search(menuItem);
  }

  @override
  void onDismiss() {
    callback.hidden(menuItem);
  }

  @override
  void onShow() {
    callback.expanded(menuItem);
  }

  @override
  void setValue(String value) {
    menuItem.setValue(value);
  }

  @override
  void setText(String text) {
    menuItem.text = text;
  }

}

class _InputState extends State<InputMenuView> {
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    TextEditingController controller = TextEditingController();
    return Container(
      height: double.infinity,
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(6),
            //边框设置
            decoration: new BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              //设置四周边框
              border: new Border.all(width: 1, color: Colors.grey),
            ),
            child: TextField(
              maxLines: 5,
              decoration: InputDecoration.collapsed(hintText: widget.menuItem.name),
              controller: controller..text = widget.menuItem.text,
            ),
          ),
          Divider(color: constant.diverColorDark,),
          Padding(
            padding: EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchPanelButton(
                  title: "重置",
                  onPressed: () {
                    controller.text="";
                    widget.setValue("");
                    widget.setText("");
                    dismiss();
                    widget.onSearch();
                  },
                ),
                SearchPanelButton(
                  title: "确认",
                  onPressed: () {
                    widget.setValue(controller.text);
                    widget.setText(controller.text);
                    dismiss();
                    widget.onSearch();
                  },
                ),
              ],
            ),
          ),
          Expanded(
              child: InkWell(
                child: Container(
                  decoration: new BoxDecoration(
                    color: const Color(0x50000000),
                  ),
                ),
                onTap: () {
                  dismiss();
                },
              ))
        ],
      ),
    );
  }

  void dismiss() {
    widget.onDismiss();
    Navigator.pop(context);
  }
}
