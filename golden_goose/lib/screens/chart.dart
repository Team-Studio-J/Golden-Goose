import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/account_type.dart';
import 'package:golden_goose/data/market_type.dart';
import 'package:golden_goose/models/game_type_model.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:golden_goose/widgets/nation_avatar.dart';

import 'game.dart';

class Chart extends StatelessWidget {
  static const String path = "/Chart";
  final uc = Get.find<UserController>();
  final List<MarketType> _games = MarketType.values;

  Chart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 20),
            Column(
              children: const [
                Center(
                  child: Text("누 적 적 립 금",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Center(
                  child: Text("Coming Soon",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      NationAvatar(nation: uc.user.nation),
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 100,
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${uc.user.nickname} ",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Grid(
                              child: RichText(
                                  text: TextSpan(children: [
                            const TextSpan(text: "Rank"),
                            const TextSpan(text: "\n"),
                            TextSpan(
                              text: uc.user.formattedRank,
                              style:
                                  const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ]))),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Grid(
                              child: RichText(
                                  text: TextSpan(children: [
                            const TextSpan(text: "Balance\n"),
                            TextSpan(
                              text: uc
                                  .ofAccount(AccountType.rank)
                                  .formattedBalance,
                              style:
                                  const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ]))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Center(child: Text("Select Market")),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: _games.length,
                    //physics: AlwaysScrollableScrollPhysics(),
                    physics: const NeverScrollableScrollPhysics(),
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
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ])))),
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
