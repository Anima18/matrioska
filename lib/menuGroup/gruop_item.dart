import 'package:flutter/material.dart';

class GroupItem {
  String code;
  String name;
  Icon icon;
  List<GroupItem> children;

  GroupItem(this.code, this.name, this.icon, this.children);
}