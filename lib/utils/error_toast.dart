import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ErrorToast {
  BuildContext context;
  FToast fToast;

  ErrorToast(this.context) : fToast = FToast() {
    fToast.init(context);
  }

  void showErrorToast(String error, int durationSecs) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.red,
      ),
      child: Text(
        error,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: durationSecs),
    );
  }
}
