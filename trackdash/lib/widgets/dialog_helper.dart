import 'package:flutter/material.dart';

class DialogHelper extends StatelessWidget {
  final String title;
  final String body;
  final String confirmButton;
  final VoidCallback onConfirm;
  final String cancelButton;

  const DialogHelper(
      {Key? key,
      required this.title,
      required this.body,
      required this.confirmButton,
      required this.onConfirm,
      required this.cancelButton})
      : super(key: key);

  static void customDialog(BuildContext context, String title, String body,
      String confirmButton, VoidCallback onConfirm, String cancelButton) {
    showDialog<void>(
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
                onPressed: onConfirm,
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

  @override
  Widget build(BuildContext context) {
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
          onPressed: onConfirm,
        ),
        TextButton(
          child: Text(cancelButton),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
