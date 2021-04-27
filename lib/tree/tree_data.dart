

class TreeData {
  final String code;
  final String title;
  final dynamic data;
  bool expanded = false;
  bool selected = false;
  List<TreeData>? children;

  TreeData(this.code, this.title, this.data, {this.expanded = false}) : assert(code != null && code != null && title != null) ;

  @override
  String toString() {
    return 'TreeData{code: $code, title: $title, data: $data, expanded: $expanded, selected: $selected, children: $children}';
  }
}