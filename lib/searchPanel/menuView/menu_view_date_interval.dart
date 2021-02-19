import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/widget.dart';
import '../../common/constant.dart' as constant;
import '../../util/date_util.dart';
import '../../util/text_util.dart';

import '../menu_item.dart';
import '../searchBar.dart';
import 'menu_view.dart';

class DateIntervalMenuView extends MenuView {

  final DateIntervalMenuItem menuItem;
  final SearchBarCallback callback;

  DateIntervalMenuView(this.menuItem, this.callback);

  @override
  _DateIntervalState createState() {
    return _DateIntervalState();
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
    menuItem.addValue(value);
  }

  @override
  void setText(String text) {
    menuItem.text = text;
  }
}

class _DateIntervalState extends State<DateIntervalMenuView> {

  BuildContext context;
  String customBeginTime, customEndTime;
  String dateFormatValue;


  @override
  void initState() {
    dateFormatValue = widget.menuItem.getDateTimeFormat();
    customBeginTime = getBeginTime();
    customEndTime = getEndTime();
    widget.menuItem.dataList.forEach((element) {
      if(element.code == widget.menuItem.text) {
        element.selected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
        height: double.infinity,
        child: Column(
          children: [
            Container(
              height: 365,
              child: Column(
                children: [
                  Container(
                    height: 220,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: widget.menuItem.dataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var view = Container(
                            height: 44,
                            child: Center(
                                child: Text(listItemIndexOf(index).code, style: TextStyle(color: listItemIndexOf(index).selected ? widget.callback.activeColor : Colors.black),),

                            ),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(width: 1, color: constant.diverColor))
                            ),
                          );
                          return InkWell(
                              onTap: () => {listItemClick(index)},
                              child: view
                          );
                        }
                    ),
                  ),
                  Container(
                    height: 36,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: Color(0xffeeeeee)
                    ),
                    child: Text("自定义时间"),
                  ),
                  Container(
                    height: 30,
                    margin: EdgeInsets.only(top: 8, right:6, left: 6),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(child: Text("从:"), alignment: Alignment.centerLeft, padding: EdgeInsets.fromLTRB(0, 0, 6, 0),),
                        Expanded(
                          child: OutlineButton(
                            child: Text(getBeginTime(), style: TextStyle(fontSize: 12,),),
                            onPressed: () {
                              selectBeginTime();
                            },
                          ),
                        ),
                        Container(child: Text("至:"), alignment: Alignment.centerLeft, padding: EdgeInsets.fromLTRB(6, 0, 6, 0),),
                        Expanded(
                          child: OutlineButton(
                            child: Text(getEndTime(), style: TextStyle(fontSize: 12,),),
                            onPressed: () {
                              selectEndTime();
                            },
                          ),
                        ),
                      ],
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
                            widget.menuItem.valueList.clear();
                            widget.setText("");
                            listItemClick(-1);
                            dismiss();
                            widget.onSearch();
                          },
                        ),
                        SearchPanelButton(
                          title: "确认",
                          onPressed: () {
                            submit();
                          },
                        ),
                      ],
                    ),
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

  void submit() {
    dismiss();
    bool dataListSelected = false;
    widget.menuItem.dataList.forEach((element) {
      if(element.selected) {
        dataListSelected = true;
      }
    });
    if(!dataListSelected) {
      widget.menuItem.valueList.clear();
      if(TextUtils.isNotEmpty(customBeginTime) && TextUtils.isNotEmpty(customEndTime)) {
        widget.setValue(customBeginTime);
        widget.setValue(customEndTime);
        widget.setText("$customBeginTime 至 $customEndTime");
      }else if(TextUtils.isNotEmpty(customBeginTime) && TextUtils.isEmpty(customEndTime)) {
        customEndTime = DateUtil.format(DateTime.now(), dateFormatValue);
        widget.setValue(customBeginTime);
        widget.setValue(customEndTime);
        widget.setText("$customBeginTime 至今");
      }else if(TextUtils.isEmpty(customBeginTime) && TextUtils.isNotEmpty(customEndTime)) {
        customBeginTime = DateUtil.format(DateUtil.yearDuration(DateTime.now(), -10), dateFormatValue);
        widget.setValue(customBeginTime);
        widget.setValue(customEndTime);
        widget.setText("$customEndTime 之前");
      }
    }
    widget.onSearch();
  }

  void selectBeginTime() {
    _selectDate(context, null, DateUtil.parse(customEndTime, dateFormatValue),
        DateUtil.parse(customBeginTime, dateFormatValue), (dateTimeValue) {
          setState(() {
            customBeginTime = dateTimeValue;
            widget.menuItem.dataList.forEach((element) {
              element.selected = false;
            });
          });
        });
  }

  void selectEndTime() {
    _selectDate(context, DateUtil.parse(customBeginTime, dateFormatValue), null,
        DateUtil.parse(customEndTime, dateFormatValue), (dateTimeValue) {
          setState(() {
            customEndTime = dateTimeValue;
            widget.menuItem.dataList.forEach((element) {
              element.selected = false;
            });
          });
        });
  }

  void listItemClick(int index) {
    widget.menuItem.valueList.clear();

    ListItem listItem = listItemIndexOf(index);
    setState(() {
      widget.menuItem.dataList.forEach((element) {
        element.selected = false;
      });
      listItem?.selected = true;
    });

    if(listItem == null) {
      return;
    }

    widget.setText(listItem.code);
    DateTime beginTime = DateTime.now() ;
    DateTime endTime = DateTime.now() ;
    switch(listItem.code) {
      case "今天":
        endTime = beginTime;
        break;
      case "一周内":
        endTime = DateUtil.weekDuration(beginTime, -1);
        break;
      case "一月内":
        endTime = DateUtil.monthDuration(beginTime, -1);
        break;
      case "三月内":
        endTime = DateUtil.monthDuration(beginTime, -3);
        break;
      case "一年内":
        endTime = DateUtil.yearDuration(beginTime, -1);
        break;
    }

    String beginTimeString = DateUtil.zero(endTime, dateFormatValue);
    String endTimeString = DateUtil.last(beginTime, dateFormatValue);
    widget.setValue(beginTimeString);
    widget.setValue(endTimeString);
    customBeginTime = beginTimeString;
    customEndTime = endTimeString;
    dismiss();
    widget.onSearch();
  }

  ListItem listItemIndexOf(int index) {
    List<ListItem> dataList = widget.menuItem.dataList;
    if(0 <= index && index < dataList.length) {
      return dataList[index];
    } else {
      return null;
    }

  }

  String getBeginTime() {
    if(customBeginTime != null) {
      return customBeginTime;
    }else {
      return widget.menuItem.valueList.length > 0 ? widget.menuItem.valueList[0] : "";
    }

  }

  String getEndTime() {
    if(customEndTime != null) {
      return customEndTime;
    }else {
      return widget.menuItem.valueList.length > 1
          ? widget.menuItem.valueList[1]
          : "";
    }
  }

  void dismiss() {
    widget.onDismiss();
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context, DateTime firstDate, DateTime lastDate, DateTime dateTime, void f(String dateTimeValue)) async {
    if(dateTime == null) {
      dateTime = DateTime.now();
    }
    if(firstDate == null) {
      firstDate = DateUtil.yearDuration(dateTime, -10);
    }
    if(lastDate == null) {
      lastDate = DateUtil.yearDuration(dateTime, 10);
    }
    final DateTime datePicker = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: firstDate,
        lastDate: lastDate);
    if (datePicker != null) {
      final TimeOfDay timePicked = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(dateTime));
      if (timePicked != null) {
        DateTime dateTime = DateUtil.combine(datePicker, timePicked);
        String dateTimeValue = DateUtil.format(dateTime, dateFormatValue);
        f(dateTimeValue);
      }
    }
  }
}