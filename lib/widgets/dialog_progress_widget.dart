import 'package:flutter/material.dart';


class DialogProgressWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Center(child: CircularProgressIndicator()),
    );
  }

}