import 'package:flutter/material.dart';
import '../common/widget.dart';

import 'tree_data.dart';
import 'tree_node.dart';


class TreeView extends StatefulWidget {
  final List<TreeData> data;

  final double offsetLeft;
  final IconButton? leadingIcon;
  final IconButton? childIcon;
  final Function? titleOnTap;
  final Function? leadingOnTap;
  final Function? trailingOnTap;
  final double scrollOffset;
  final ScrollListener? scrollListener;


  const TreeView({
    required this.data,
    this.leadingIcon,
    this.childIcon,
    this.offsetLeft = 24.0,
    this.titleOnTap,
    this.leadingOnTap,
    this.trailingOnTap,
    this.scrollOffset = 0.0,
    this.scrollListener
  }) : assert(data != null);


  @override
  TreeViewState createState() {
    return TreeViewState();
  }

}

class TreeViewState extends State<TreeView> {

  void itemClick(TreeData treeData) {
    widget.titleOnTap!(treeData);
    setState(() {
      clearSelected(widget.data);
      treeData.selected = true;
    });
  }
  void clearSelected(List<TreeData> list) {
    list.forEach((element) {
      element.selected = false;
      if(element.children != null) {
        clearSelected(element.children!);
      }
    });
  }

  List<TreeNode> _geneTreeNodes(List<TreeData>? list) {

    List treeNodes = <TreeNode>[];
    if(list != null) {
      for (int i = 0; i < list.length; i++) {
        final TreeData item = list[i];

        treeNodes.add(TreeNode(
          data: item,
          leadingIcon: widget.leadingIcon,
          childIcon: widget.childIcon,
          expaned: item.expanded,
          offsetLeft: widget.offsetLeft,
          titleOnTap: (treeItemData) {
            itemClick(treeItemData);
          },
          leadingOnTap: widget.leadingOnTap,
          trailingOnTap: widget.trailingOnTap,
          children: _geneTreeNodes(item.children),
        ));
      }
    }

    return treeNodes as List<TreeNode>;
  }

  ScrollController? controller;


  TreeViewState() {
    controller  = ScrollController();
    controller!.addListener(() {
      if(widget.scrollListener != null) {
        widget.scrollListener!(controller!.offset);
      }
    });
  }

  @override
  void initState() {
    //注册一个回调函数yourCallback
    WidgetsBinding.instance!.addPostFrameCallback((_) => controller!.jumpTo(widget.scrollOffset));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.data.length, (int index) {
          final TreeData item = widget.data[index];

          return TreeNode(
            data: item,
            leadingIcon: widget.leadingIcon,
            childIcon: widget.childIcon,
            expaned: item.expanded,
            offsetLeft: widget.offsetLeft,
            titleOnTap: (treeItemData) {
              itemClick(treeItemData);
            },
            leadingOnTap: widget.leadingOnTap,
            trailingOnTap: widget.trailingOnTap,
            children: _geneTreeNodes(item.children),
          );
        }),
      ),
    );
  }
}