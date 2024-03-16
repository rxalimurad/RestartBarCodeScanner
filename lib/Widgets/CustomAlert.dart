import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final Function onOkPressed;
  final String OKTitle;

  const CustomAlertDialog(
      {required this.title,
      required this.message,
      required this.onOkPressed,
      this.OKTitle = 'OK'});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onOkPressed();
          },
          child: Text(OKTitle),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
