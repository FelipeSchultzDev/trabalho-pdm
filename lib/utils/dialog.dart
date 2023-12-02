import 'package:flutter/material.dart';

class DialogUtils {
  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.withOpacity(.8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
