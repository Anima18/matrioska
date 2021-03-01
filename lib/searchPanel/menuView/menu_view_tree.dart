import 'package:flutter/material.dart';
import '../../common/widget.dart';
import '../../stateView/StateView.dart';
import '../../tree/tree_data.dart';
import '../../common/constant.dart' as constant;
import '../../tree/tree_view.dart';
import '../menu_item.dart';
import '../searchBar.dart';
import 'menu_view.dart';

class TreeMenuView extends MenuView {

  final TreeMenuItem menuItem;
  final SearchBarCallback callback;
  final Color activeColor;

  TreeMenuView(this.menuItem, this.callback, this.activeColor);

  @override
  State createState() {
    return _TreeMenuState(menuItem);
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

class _TreeMenuState extends State<TreeMenuView> implements TreeDataChangeCallback {

  final TreeMenuItem menuItem;
  BuildContext context;
  _TreeMenuState(this.menuItem);

  @override
  void initState() {
    requestData();
  }

  void requestData() {
    if (menuItem.dataListener != null) {
      if (menuItem.viewStatus == ViewStatus.loading) {
        menuItem.dataListener(this);
      }
    } else {
      menuItem.viewStatus = ViewStatus.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      height: double.infinity,
      child: Column(
        children: [
          Container(
            height: 320,
            child: StateView(
              viewStatus: menuItem.viewStatus,
              errorMessage: menuItem.message,
              child: buildTreeView(),
              onRetry: () {
                print("stateView retry");
                menuItem.dataListener(this);
              },
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

  Widget buildTreeView() {
    return Column(
      children: [
        Container(
          height: 250,
          child: TreeView(
            scrollOffset: menuItem.scrollOffset,
            scrollListener: (offset){
              menuItem.scrollOffset = offset;
            },
            data: menuItem.dataList,
            leadingIcon: IconButton(
              icon: Image(
                image: AssetImage("assets/ic_folder.png", package: "matrioska"),
              ),
              iconSize: 10,
            ),
            titleOnTap: (TreeData treeData) {
              widget.setText(treeData.title);
              widget.setValue(treeData.code);
              dismiss();
              widget.onSearch();
            },
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
                  setState(() {
                    menuItem.clear(menuItem.dataList);
                  });
                  widget.setText("");
                  widget.setValue(null);
                  dismiss();
                  widget.onSearch();
                },
              ),
              SearchPanelButton(
                title: "确认",
                onPressed: () {
                  dismiss();
                  widget.onSearch();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void dismiss() {
    widget.onDismiss();
    Navigator.pop(context);
  }

  @override
  void onError(String message) {
    setState(() {
      menuItem.viewStatus = ViewStatus.error;
      menuItem.message = message;
    });
  }

  @override
  void onSuccess(List<TreeData> dataList) {
    setState(() {
      menuItem.viewStatus = ViewStatus.content;
      widget.menuItem.dataList = dataList;
      menuItem.message = "";
    });
  }

  @override
  void onLoading() {
    setState(() {
      menuItem.viewStatus = ViewStatus.loading;
    });
  }
}