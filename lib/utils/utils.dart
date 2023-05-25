import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/app_color.dart';

class Utils {
  static showSnackBar(BuildContext context, {required String text}) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(backgroundColor: AppColor.blackColor, content: Text(text)));
  }





  static String dateToString(DateTime date, {String? format}) {
    DateFormat formatter = DateFormat(format);
    try {
      return formatter.format(date);
    } catch (e) {
      debugPrint('Error formatting date: $e');
    }
    return '';
  }

  static String dateUTCtoLocal(DateTime date, {String? format}) {
    DateFormat formatter = DateFormat(format);
    try {
      return formatter.format(date.toLocal());
    } catch (e) {
      debugPrint('Error formatting date: $e');
    }
    return '';
  }
}


class AppDateFormat{
  static String shortMonthFormat = "MMM dd, yyyy";
  static String dayMonthFormat = "MMM dd";
  static String fullDateTimeFormat = "MMM d yyyy, h:mm aa";
}