// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ButnTile extends StatefulWidget {
  ButnTile(
      {required this.icnName,
      this.bgColor,
      this.height,
      this.width,
      this.borderRadius,
      this.margin,
      super.key});

  String icnName;
  Color? bgColor;
  double? height;
  double? width;
  double? borderRadius;
  double? margin;

  @override
  State<ButnTile> createState() => _ButnTileState();
}

class _ButnTileState extends State<ButnTile> {
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Container(
      width: screen.width * (widget.width ?? 0.18),
      height: screen.height * (widget.height ?? 0.08),
      decoration: BoxDecoration(
        color: widget.bgColor ?? const Color.fromARGB(228, 255, 255, 255),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
      ),
      child: Container(
        margin: EdgeInsets.all(widget.margin ?? 5),
        decoration: BoxDecoration(
            //color: Colors.white,
            image: DecorationImage(
                fit: BoxFit.contain, image: AssetImage(widget.icnName))),
      ),
    );
  }
}
