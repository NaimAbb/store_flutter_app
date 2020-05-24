import 'package:flutter/material.dart';

class ButtonCommon extends StatelessWidget {
  final String text;
  final Function onPress;

  ButtonCommon(this.text, {this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: RaisedButton(
        onPressed: () {
          onPress();
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: const EdgeInsets.all(0.0),
        child: Ink(
          decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.lightBlue, Colors.blueAccent]),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Container(
            padding: const EdgeInsets.all(15),
            constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
            // min sizes for Material buttons
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
