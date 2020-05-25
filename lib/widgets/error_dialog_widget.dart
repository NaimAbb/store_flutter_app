import 'package:flutter/material.dart';

class ErrorDialogWidget extends StatelessWidget {
  final String message;

  ErrorDialogWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        borderSide: BorderSide(
          style: BorderStyle.none,
        ),
      ),
      content: Container(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error,
              color: Colors.red,
              size: 70,
            ),
            SizedBox(
              height: 20,
            ),
            Text(message),
          ],
        ),
      ),
    );
  }
}
