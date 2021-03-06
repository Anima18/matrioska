import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrioska/viewModel/view_state.dart';
import 'package:provider/provider.dart';

import '../../common/constant.dart' as constant;
import '../../common/widget.dart';
import '../../stateView/StateView.dart';
import '../menu_item.dart';
import '../searchBar.dart';
import 'menu_view.dart';

class ListMenuView extends MenuView {
  final ListMenuItem menuItem;
  final SearchBarCallback callback;
  final Color activeColor;

  ListMenuView(this.menuItem, this.callback, this.activeColor);

  @override
  _ListState createState() {
    return _ListState(menuItem);
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
  void setValue(String? value) {
    menuItem.setValue(value);
  }

  @override
  void setText(String text) {
    menuItem.text = text;
  }
}

class _ListState extends State<ListMenuView> implements DataChangeCallback {
  final ListMenuItem menuItem;
  late BuildContext context;
  ScrollController? controller;

  _ListState(this.menuItem) {

    controller  = ScrollController();
    controller!.addListener(() {
      menuItem.scrollOffset = controller!.offset;
    });
  }

  @override
  void initState() {
    requestData();
    //注册一个回调函数yourCallback
    WidgetsBinding.instance!.addPostFrameCallback((_) => controller!.jumpTo(menuItem.scrollOffset));
  }

  void requestData() {
    if (menuItem.dataListener != null) {
      if (menuItem.viewStatus == DataState.loading) {
        menuItem.dataListener!(this);
      }
    } else {
      menuItem.viewStatus = DataState.success;
    }
  }

  List<ListItem> dataList() {
    return menuItem.dataList;
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
              viewState: menuItem.viewStatus,
              errorMessage: menuItem.message,
              builder: (context, _) => buildListView(),
              onRetry: () {
                print("stateView retry");
                menuItem.dataListener!(this);
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

  Widget buildListView() {
    return Column(
      children: [
        Container(
          height: 250,
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            controller: controller,
            itemCount: dataList().length,
            itemBuilder: (context, position) {
              return Provider.value(
                  value: widget.activeColor,
                  child: ListViewItemView(dataList()[position], (listItem) {
                    itemClick(listItem);
                    widget.setText(listItem.text);
                    widget.setValue(listItem.code);
                    dismiss();
                    widget.onSearch();
                  }),
              );
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
                  itemClick(null);
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

  void itemClick(ListItem? listItem) {
    setState(() {
      menuItem.dataList.forEach((element) {
        element.selected = false;
      });
      listItem?.selected = true;
    });
  }

  void dismiss() {
    widget.onDismiss();
    Navigator.pop(context);
  }

  @override
  void onError(String message) {
    setState(() {
      menuItem.viewStatus = DataState.error;
      menuItem.message = message;
    });
  }

  @override
  void onSuccess(List<ListItem> dataList) {
    setState(() {
      menuItem.viewStatus = DataState.success;
      widget.menuItem.dataList = dataList;
      menuItem.message = "";
    });
  }

  @override
  void onLoading() {
    setState(() {
      menuItem.viewStatus = DataState.loading;
    });
  }
}

typedef OnItemClickListener = void Function(ListItem item);

class ListViewItemView extends StatefulWidget {
  final ListItem listItem;
  final OnItemClickListener clickListener;

  ListViewItemView(this.listItem, this.clickListener);

  @override
  ListViewItemState createState() {
    return ListViewItemState();
  }
}

class ListViewItemState extends State<ListViewItemView> {
  @override
  Widget build(BuildContext context) {
    Color activeColor = context.read<Color>();
    var itemView = Container(
      child: Container(
        width: double.infinity,
        height: 48,
        child: Center(
          child: Text(
            widget.listItem.text,
            style: TextStyle(
                color: widget.listItem.selected ? activeColor : Colors.black),
          ),
        ),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: constant.diverColor))),
      ),
    );
    return InkWell(
        onTap: () => widget.clickListener(widget.listItem), child: itemView);
  }
}
