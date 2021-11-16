import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:intl/intl.dart';

class Rank extends StatelessWidget {
  static const String path = "/Rank";
  final uc = Get.find<UserController>();

  Rank({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Column(
                      children: [
                        const Center(
                          child: const Text("오 징 어 게 임",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ),
                        const Center(
                          child: const Text("누 적 적 립 금",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        const Center(
                          child: const Text("2,324,203 \$",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    SizedBox(
                      height: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Grid(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Rank",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30)),
                                        SizedBox(height: 10),
                                        Text("1st",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 25)),
                                      ],
                                    )),
                              )),
                          Expanded(
                              flex: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 50,
                                      child: Grid(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Container(),
                                            Text("Balanace",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                            SizedBox(height: 2),
                                            Obx(() {
                                              return buildBalanceText("${uc.user.rankMoney}");
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Expanded(
                                        flex: 50,
                                        child: Grid(
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Container(),
                                                Text("Recent",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15)),
                                                SizedBox(height: 2),
                                                Text("80.2%",
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.normal,
                                                        fontSize: 15)),
                                              ],
                                            ))),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /*
              Container(
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.onBackground.withOpacity(0.44),
                  borderRadius: BorderRadius.all(Radius.circular(04.0)),
                ),
                child: Column(
                  children: List.generate(10, (index) => ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Map'),

                  )),
                ),
              ),

               */

              // Obx(() => CryptoListWidget(cc.list.value)),
            ],
          ),
        ),
      ),
    );
  }

  Text buildBalanceText(String text) {
    return Text(text,
        style: TextStyle(
            fontWeight:
            FontWeight.normal,
            fontSize: 15));
  }
}

class VerticalVarWithPadding extends StatelessWidget {
  final double? width;

  const VerticalVarWithPadding({Key? key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width ?? 8.0),
      child: Container(width: 1, color: Colors.white),
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

    this.onTap,
  }) : super(key: key);
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final BorderRadius borderRadius;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Ink(
        decoration: BoxDecoration(
          color: decoration == null
              ? Get.theme.colorScheme.onBackground.withOpacity(0.14)
              : decoration!.color,
          borderRadius: decoration != null && decoration!.borderRadius != null
              ? decoration!.borderRadius
              : borderRadius,
        ),
        child: Grid(child: child, decoration: BoxDecoration()),
      ),
    );
  }
}