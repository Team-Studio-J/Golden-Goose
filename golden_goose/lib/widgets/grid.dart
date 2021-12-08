import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Grid extends StatelessWidget {
  const Grid({Key? key, this.child, this.padding, this.decoration, this.color})
      : super(key: key);
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: width,
      //height: height,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(8.0),
        child: child,
      ),
      //margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: decoration ??
          BoxDecoration(
            color:
                color ?? Get.theme.colorScheme.onBackground.withOpacity(0.14),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            boxShadow: const [
              /*
          BoxShadow(
            color: Get.theme.colorScheme.onSurface.withOpacity(0.38),
            blurRadius: 4.0,
            offset: Offset(0.0, 4.0),
          ),
           */
            ],
          ),
    );
  }
}

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({
    Key? key,
    this.child,
    this.padding,
    this.decoration,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.color,
    this.onTap,
  }) : super(key: key);
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  final BoxDecoration? decoration;
  final BorderRadius borderRadius;
  final Color? color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Ink(
        decoration: BoxDecoration(
          color: color ??
              (decoration == null
                  ? Get.theme.colorScheme.onBackground.withOpacity(0.14)
                  : decoration!.color),
          borderRadius: decoration != null && decoration!.borderRadius != null
              ? decoration!.borderRadius
              : borderRadius,
        ),
        child:
            Grid(padding: padding, child: child, decoration: const BoxDecoration()),
      ),
    );
  }
}
