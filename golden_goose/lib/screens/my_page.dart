import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/account_type.dart';
import 'package:golden_goose/databases/database.dart';
import 'package:golden_goose/models/account.dart';
import 'package:golden_goose/models/game_result_model.dart';
import 'package:golden_goose/screens/result.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:golden_goose/widgets/nation_avartar.dart';
import 'package:golden_goose/models/game_type_model.dart';
import 'package:golden_goose/data/market_type.dart';
import 'package:intl/intl.dart';

import 'login.dart';

class MyPage extends StatefulWidget {
  static const String path = "/MyPage";

  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final ac = Get.find<AuthController>();
  final uc = Get.find<UserController>();
  var numberFormat = NumberFormat.currency(name: '', decimalDigits: 0);
  bool historyLoaded = false;
  List<GameResultModel> histories = [];

  @override
  void initState() {
    Database.getGameHistoryList(ac.user!, AccountType.rank).then((list) {
      setState(() {
        historyLoaded = true;
        histories = list;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Grid(
                //color: Colors.orange.withOpacity(0.8),
                color: Colors.indigo.withOpacity(0.8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            NationAvartar(nation: uc.user.nation),
                            SizedBox(width: 6),
                            SizedBox(
                              width: 100,
                              child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${uc.user.nickname}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                            RichText(
                                text:
                                    TextSpan(text: "${uc.user.formattedRank}"))
                          ],
                        ),
                        InkWell(
                            onTap: () => Get.offAll(() => Login()),
                            child: Icon(Icons.logout)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        text:
                                            "${uc.ofAccount(AccountType.rank).formattedBalance}")),
                                SizedBox(height: 10),
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(fontSize: 12),
                                        text:
                                            uc.user.formattedRegistrationDate)),
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(fontSize: 12),
                                        text: "${uc.user.email}")),
                              ]),
                          Grid(
                            child: Row(children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: "게임 진행 횟수 ",
                                          style: TextStyle(fontSize: 10)),
                                      TextSpan(
                                          text:
                                              "${uc.ofAccount(AccountType.rank).gameCount}",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey)),
                                    ])),
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: "승률 ",
                                          style: TextStyle(fontSize: 10)),
                                      TextSpan(
                                          text:
                                              "${uc.ofAccount(AccountType.rank).formattedWinRate}",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey)),
                                    ])),
                                  ]),
                              SizedBox(width: 10),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: "롱비율 ",
                                          style: TextStyle(fontSize: 10)),
                                      TextSpan(
                                          text:
                                              "${uc.ofAccount(AccountType.rank).formattedLongRatio}",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey)),
                                    ])),
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: "숏비율 ",
                                          style: TextStyle(fontSize: 10)),
                                      TextSpan(
                                          text:
                                              "${uc.ofAccount(AccountType.rank).formattedShortRatio}",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey)),
                                    ])),
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: "베팅률 ",
                                          style: TextStyle(fontSize: 10)),
                                      TextSpan(
                                          text:
                                              "${uc.ofAccount(AccountType.rank).formattedBettingRate}",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey)),
                                    ])),
                                  ]),
                            ]),
                          )
                        ])
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            buildCard(context),
            SizedBox(height: 40),
            Center(child: Text("매매 일지")),
            SizedBox(height: 0),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8,0,8,0),
                  child: Text("최근 20게임 출력",
                      style: TextStyle(fontSize: 8, color: Colors.grey)),
                )),
            Grid(
              color: Colors.transparent,
              child: Column(
                children: [
                  getExplainTile(),
                  getSeparator(),
                  buildHistories(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildCard(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: MediaQuery.of(context).size.width * 0.7 * 0.62,
        width: MediaQuery.of(context).size.width * 0.7,
        child: Grid(
          color: Color.fromRGBO(80, 80, 80, 1),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 10,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text.rich(TextSpan(
                            text: "Short Scalpers",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ))))),
                Spacer(
                  flex: 13,
                ),
                Expanded(
                    flex: 10,
                    child: Text("Comming Soon",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700))),
                Spacer(
                  flex: 10,
                ),
                Expanded(
                    flex: 10,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                            text: TextSpan(text: "${uc.user.nickname}")))),
              ]),
        ),
      ),
    ]);
  }

  Widget buildHistories() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: histories.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (!historyLoaded) return getLoadingTile();
        if (index >= histories.length) return Container();
        return getHistoryTile(histories[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        if (index == histories.length - 1) return Container();
        return getSeparator();
      },
    );
  }

  Widget getSeparator() {
    return Column(children: [
      SizedBox(height: 2),
      Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
              flex: 20,
              child:
                  Container(height: 1, color: Colors.white.withOpacity(0.05))),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
      SizedBox(height: 2),
    ]);
  }

  Widget getLoadingTile() {
    return const SizedBox(
        width: double.infinity,
        height: 30,
        child: ButtonGrid(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Center(
                child: SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ))));
  }

  Widget getExplainTile() {
    return SizedBox(
      height: 30,
      child: Grid(
        decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.6),
            borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: "마켓 종류",
                    style: TextStyle(fontSize: 12),
                  ),
                ])),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(text: "매매손익", style: TextStyle(fontSize: 10)),
                      ])),
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(text: "수익률", style: TextStyle(fontSize: 10)),
                    ])),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "매매 일자", style: TextStyle(fontSize: 10)),
                ])),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getHistoryTile(GameResultModel gameResult) {
    return SizedBox(
      height: 30,
      child: ButtonGrid(
        onTap: () => Get.to(() => Result(
              gameAccount: gameResult.gameAccount,
              gameResultModel: gameResult,
              initialAccount: Account(balance: gameResult.balanceAtStart),
            )),
        borderRadius: BorderRadius.circular(5),
        color: Get.theme.colorScheme.onBackground.withOpacity(0.34),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: "${gameResult.gameTypeModel.marketType.name}",
                    style: TextStyle(fontSize: 12),
                  ),
                ])),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "${gameResult.formattedRevenue}",
                            style: TextStyle(
                                fontSize: 10,
                                color: getColorByValue(
                                    gameResult.revenue.toDouble()))),
                      ])),
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "${gameResult.formattedRevenueRate}",
                          style: TextStyle(
                              fontSize: 10,
                              color: getColorByValue(gameResult.revenueRate))),
                    ])),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "${gameResult.formattedDate}",
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                ])),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColorByValue(double value) {
    if (value.isNaN || value.isInfinite || value == 0.0) return Colors.grey;
    return value > 0.0 ? Colors.green : Colors.red;
  }
}
