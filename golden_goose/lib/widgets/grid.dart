import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Grid extends StatelessWidget {
  const Grid({Key? key, this.child, this.padding, this.decoration})
      : super(key: key);
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;

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
            color: Get.theme.colorScheme.onBackground.withOpacity(0.14),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
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
