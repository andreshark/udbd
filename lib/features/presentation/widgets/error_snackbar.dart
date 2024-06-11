import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext _, String message, String title) async {
  // ignore: unused_local_variable
  final snackBar = SnackBar(
    content: Text(message),
    // behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
  );
  ScaffoldMessenger.of(_).showSnackBar(snackBar);
}
