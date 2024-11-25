// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ButnTyp2 extends StatelessWidget {
  ButnTyp2({
    required this.text,
    this.txtcolor,
    required this.size,
    this.btnHeight,
    required this.btnColor,
    required this.borderRadius,
    super.key,
  });

  String text;
  Color? txtcolor;
  double size;
  double? btnHeight;
  Color btnColor;
  double borderRadius;

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(8),
      height: btnHeight ?? 40,
      width: screen.width * 0.5,
      decoration: BoxDecoration(
        color: btnColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 0),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: size,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
