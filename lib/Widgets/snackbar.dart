import 'package:flutter/material.dart';

void showSnackbar(
  BuildContext context, {
  required String message,
  Duration duration = const Duration(seconds: 3),
  Color backgroundColor = Colors.black87,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
    ),
  );
}
