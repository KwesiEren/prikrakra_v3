// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';

class GlassBox extends StatefulWidget {
  GlassBox(
      {this.bgcolor,
      this.height,
      this.width,
      this.spreadX,
      this.spreadY,
      this.borderRadius,
      super.key,
      required this.child});

  Color? bgcolor;
  final Widget child;
  num? height;
  num? width;
  double? borderRadius;
  double? spreadX;
  double? spreadY;

  @override
  State<GlassBox> createState() => _GlassBoxState();
}

class _GlassBoxState extends State<GlassBox> {
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.white),
          ),
          // Glass Container
          Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widget.borderRadius ?? 20),
                      topRight: Radius.circular(widget.borderRadius ?? 20)),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: widget.spreadX ?? 10.0,
                          sigmaY: widget.spreadY ?? 10.0),
                      child: Container(
                        height: screen.height * (widget.height ?? 0.6),
                        width: screen.width * (widget.width ?? 0.90),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft:
                                  Radius.circular(widget.borderRadius ?? 20),
                              topRight:
                                  Radius.circular(widget.borderRadius ?? 20)),
                          border: Border.all(
                            color: const Color.fromARGB(255, 73, 67, 67)
                                .withOpacity(0.2),
                            width: 1.5,
                          ),
                          color: widget.bgcolor ??
                              const Color.fromARGB(255, 143, 134, 134)
                                  .withOpacity(0.15),
                        ),
                      )))),
          Container(
            child: widget.child,
          )
        ],
      ),
    );
  }
}
