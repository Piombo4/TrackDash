import 'package:flutter/material.dart';

Future<void> customDialog(BuildContext context, String title, String body,
    String confirmButton, VoidCallback action, String cancelButton) async {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(confirmButton),
              onPressed: action,
            ),
            TextButton(
              child: Text(cancelButton),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
