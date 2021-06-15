import 'package:flutter/material.dart';

import 'gruop_item.dart';


typedef OnItemTap = void Function(GroupItem item);

class MenuGroupView extends StatelessWidget {
  final List<GroupItem> data;
  final int crossAxisCount;
  final OnItemTap onItemTap;

  MenuGroupView({required this.data, required this.crossAxisCount, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    List<Widget> slivers = [];
    data.forEach((group) {
      final titleView = SliverToBoxAdapter(child: Padding(padding: EdgeInsets.only(top: 10, bottom: 10, left: 16),child: Text(group.name)),);
      final gridView = SliverGrid(

          delegate: SliverChildBuilderDelegate((context, index) {
            return _ElementItem(element: group.children[index], onItemTap: onItemTap,);
          }, childCount: group.children.length),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
          )
      );
      slivers.add(titleView);
      slivers.add(gridView);
    });
    return Container(
      height: double.infinity,
      width: double.infinity,

      child: CustomScrollView(
        slivers: slivers,
      ),
    );
  }
}


class _ElementItem extends StatelessWidget {
  const _ElementItem({
    Key? key,
    required this.element,
    required this.onItemTap
  }) : super(key: key);

  final GroupItem element;
  final OnItemTap onItemTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        color: Colors.white,
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              element.icon,
              Text(
                element.name,
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
          onTap: () {
            this.onItemTap(element);
          },
        ),
      ),
    );
  }
}
