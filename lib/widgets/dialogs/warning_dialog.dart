import 'package:flutter/material.dart';

Future<bool> showWarningDialog(
  String title,
  String message,
  BuildContext context,
) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text("Proceed"),
        ),
      ],
    ),
  );
}
