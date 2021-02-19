import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class DateUtil {
  static DateTime parse(String value, String formatString) {
    if(value == null || value.isEmpty) {
      return null;
    }
    var formatter =  DateFormat(formatString);
    return formatter.parse(value);
  }

  static String format(DateTime dateTime, String formatString) {
    var formatter =  DateFormat(formatString);
    return formatter.format(dateTime);
  }

  static String zero(DateTime dateTime, String formatString) {
    var zeroDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0, 0, 0);
    var formatter =  DateFormat(formatString);
    return formatter.format(zeroDateTime);
  }

  static String last(DateTime dateTime, String formatString) {
    var lastDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 999, 999);
    var formatter =  DateFormat(formatString);
    return formatter.format(lastDateTime);
  }

  static DateTime weekDuration(DateTime dateTime, int step) {
    return dateTime.add(Duration(days: 7 * step));
  }

  static DateTime monthDuration(DateTime dateTime, int step) {
    return new DateTime(dateTime.year, dateTime.month + step, dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);
  }

  static DateTime yearDuration(DateTime dateTime, int step) {
    return new DateTime(dateTime.year + step, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);
  }

  static DateTime combine(DateTime dateTime, TimeOfDay timeOfDay) {
    return new DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour, timeOfDay.minute, 0);
  }
}