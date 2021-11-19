import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/account_type.dart';
import 'package:golden_goose/data/market_type.dart';
import 'package:golden_goose/models/game_type_model.dart';
import 'package:golden_goose/widgets/grid.dart';

import 'game.dart';

class Chart extends StatelessWidget {
  static const String path = "/Chart";
  final uc = Get.find<UserController>();
  final List<MarketType> _games = MarketType.values;

  @override
  Widget build(BuildContext context) {
    Size appSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(height: 20),
            Column(
              children: [
                const Center(
                  child: const Text("누 적 적 립 금",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const Center(
                  child: const Text("2,324,203 \$",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Salvatorie J",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Grid(
                              child: RichText(
                                  text: TextSpan(children: [
                            TextSpan(text: "Rank"),
                            TextSpan(text: "\n"),
                            TextSpan(
                              text: "1 st",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            TextSpan(
                                text: " +1",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 10)),
                          ]))),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Grid(
                              child: RichText(
                                  text: TextSpan(children: [
                            TextSpan(text: "Balance\n"),
                            TextSpan(
                              text: "1,252,321\$",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            TextSpan(
                                text: " +24,132\$",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 10)),
                          ]))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(child: Text("Select Market")),
                  SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: _games.length,
                    //physics: AlwaysScrollableScrollPhysics(),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Get.to(() => Game(
                                gameTypeModel:
                                    GameTypeModel.buildRandomGameTypeExceptThat(
                                        marketType: _games[index],
                                        limit: 150,
                                        accountType: AccountType.rank),
                              ));
                        },
                        child: Grid(
                            child: Center(
                                child: RichText(
                                    text: TextSpan(children: [
                          TextSpan(
                              text: _games[index].name,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ])))),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 1,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
