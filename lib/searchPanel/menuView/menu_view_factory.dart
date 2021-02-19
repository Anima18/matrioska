
import '../menu_item.dart';
import '../searchBar.dart';
import 'menu_view.dart';
import 'menu_view_date_interval.dart';
import 'menu_view_input.dart';
import 'menu_view_list.dart';
import 'menu_view_tree.dart';

class MenuViewFactory {
    static MenuView of(MenuItem menuItem, SearchBarCallback callback) {
      if(menuItem is InputMenuItem) {
        return InputMenuView(menuItem, callback);
      }else if(menuItem is ListMenuItem) {
        return ListMenuView(menuItem, callback);
      }else if(menuItem is DateIntervalMenuItem) {
        return DateIntervalMenuView(menuItem, callback);
      }else if(menuItem is TreeMenuItem) {
        return TreeMenuView(menuItem, callback);
      }
    }
}