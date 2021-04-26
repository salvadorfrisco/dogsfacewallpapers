import 'package:flutter/material.dart';

class CircularIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 5.0,
        backgroundColor: Colors.yellowAccent,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      ),
    );
  }
}
