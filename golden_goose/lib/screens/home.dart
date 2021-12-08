import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/account_type.dart';
import 'package:golden_goose/widgets/balance_text.dart';
import 'package:golden_goose/widgets/grid.dart';

class Home extends StatelessWidget {
  static const String path = "/Home";
  final uc = Get.find<UserController>();

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Column(
                    children: const [
                      Center(
                        child: Text("오 징 어 게 임",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ),
                      Center(
                        child: Text("누 적 적 립 금",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Center(
                        child: Text("2,324,203 \$",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 70),
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
                                children: const [
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
                                          const Text("Balance",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                          const SizedBox(height: 2),
                                          Obx(() {
                                            return Text.rich(BalanceTextSpan(
                                              balance: uc
                                                  .ofAccount(AccountType.rank)
                                                  .balance,
                                              showSign: false,
                                              showColor: false,
                                              normalColor: null,
                                              fontSize: 16,
                                            ).get());
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                      flex: 50,
                                      child: Grid(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(),
                                          const Text("Recent",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                          const SizedBox(height: 2),
                                          const Text("80.2%",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
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
    );
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
