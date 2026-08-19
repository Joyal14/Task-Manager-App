import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static Future<bool?> displayToast(String message, BuildContext context, int toastGravity) {
    return Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM, msg: '');
  }
}