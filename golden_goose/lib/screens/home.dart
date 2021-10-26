import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  static const String path = "/Home";

  Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child:
      Center(child: Column(
        children: const [
          Text("Hello World"),
        ],
      ))),
    );
  }
}
