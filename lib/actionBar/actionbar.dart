import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'action_item.dart';

typedef OnActionTap = void Function(ActionItem item);

const int item_max = 4;

class ActionBar extends StatelessWidget {
  final List<ActionItem> data;
  final OnActionTap onActionTap;
  final int itemLimit;

  List<ActionItem> normalItems = [];
  List<ActionItem> otherItems = [];

  double sw = 0, sh = 0;
  ActionBar(
      {required this.data,
      this.itemLimit = item_max,
      required this.onActionTap}) {
    if (data.length > itemLimit) {
      normalItems = data.getRange(0, itemLimit - 1).toList();
      normalItems.add(ActionItem("more", "更多", Icons.more_horiz));
      otherItems =
          data.getRange(itemLimit - 1, data.length).toList().reversed.toList();
    } else {
      normalItems = data;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("==========ActionBar build============");
    sw = MediaQuery.of(context).size.width; //屏幕宽度
    sh = MediaQuery.of(context).size.height; //屏幕高度

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            width: 0.5, //宽度
            color: Colors.black12, //边框颜色
          ),
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: normalItems.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, position) {
          return _ActionItemView(
            element: normalItems[position],
            onItemTap: (element) {
              if (element.code == "more") {
                _showMorMenu(context, otherItems, onActionTap);
              } else {
                onActionTap(element);
              }
            },
          );
        },
      ),
    );
  }

  void _showMorMenu(BuildContext context, List<ActionItem> otherActionItems,
      OnActionTap onActionTap) {
    showMenu<ActionItem>(
      context: context,
      elevation: 1,
      items: otherActionItems
          .map((e) => PopupMenuItem<ActionItem>(
              value: e,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    e.icon,
                    size: 20,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    e.name,
                    style: TextStyle(fontSize: 12),
                  )
                ],
              )))
          .toList(),
      position: RelativeRect.fromLTRB(
          sw - 100, sh - otherActionItems.length * 48 - 56 - 16, 0, sh - 56),
    ).then<void>((ActionItem? value) {
      if (value != null) {
        onActionTap(value);
      }
    });
  }
}

class _ActionItemView extends StatelessWidget {
  const _ActionItemView(
      {Key? key, required this.element, required this.onItemTap})
      : super(key: key);

  final ActionItem element;
  final OnActionTap onItemTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        color: Colors.white,
        child: InkWell(
          child: Container(
            width: 56,
            margin: EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  element.icon,
                  size: 20,
                ),
                Padding(padding: EdgeInsets.only(top: 4)),
                Text(
                  element.name,
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          ),
          onTap: () {
            this.onItemTap(element);
          },
        ),
      ),
    );
  }
}
