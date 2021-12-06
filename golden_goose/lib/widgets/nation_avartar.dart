import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:golden_goose/utils/formatter.dart';

class NationAvartar extends StatelessWidget {
  final String? nation;
  const NationAvartar({Key? key, this.nation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return nation != null
        ? CircleAvatar(
        maxRadius: 16,
        backgroundColor:
        Colors.primaries[nation.hashCode % Colors.primaries.length],
        child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "${nation}",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            )))
        : const SizedBox(
      width: 0.0,
      height: 0.0,
    );  }
}
