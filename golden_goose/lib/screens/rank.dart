import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/account_type.dart';
import 'package:golden_goose/databases/database.dart';
import 'package:golden_goose/models/account.dart';
import 'package:golden_goose/models/rank_model.dart';
import 'package:golden_goose/models/user_model.dart';
import 'package:golden_goose/utils/rank_text_converter.dart';
import 'package:golden_goose/widgets/balance_text.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:intl/intl.dart';

class Rank extends StatefulWidget {
  static const String path = "/Rank";

  const Rank({Key? key}) : super(key: key);

  @override
  _RankState createState() => _RankState();
}

class _RankState extends State<Rank> {
  final uc = Get.find<UserController>();
  var numberFormat = NumberFormat.currency(name: '', decimalDigits: 0);
  bool rankLoaded = false;

  @override
  void initState() {
    Database.getRankList().then((list) {
      setState(() {
        rankLoaded = true;
        totalRanks = list;
        expandRanks();
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
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Column(
                    children: [
                      buildRankInfo(
                        noFontHighlight: true,
                        color: Get.theme.colorScheme.onSurface.withOpacity(0.1),
                        user: uc.user,
                        account: uc.ofAccount(AccountType.rank),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("이번 주차 순위"),
                  SizedBox(height: 20),
                  buildList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Grid buildRankInfo(
      {required Color color,
      required UserModel user,
      required Account account,
      int? rank,
      bool? noFontHighlight}) {
    int? userRank = rank ?? user.rank;
    var fontColor = Colors.white;
    if (noFontHighlight != true) {
      if (uc.user.email == user.email) {
        fontColor = Colors.yellowAccent.withBlue(128);
      }
    }
    return Grid(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Grid(
                /*
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0))),
                 */
                color: color,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          "${user.nickname}",
                          style: TextStyle(
                              fontSize: 15,
                              color: fontColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: "순위 ",
                              style: TextStyle(fontSize: 12),
                            ),
                            TextSpan(
                              text: "${RankTextConverter.format(userRank)} ",
                              style: TextStyle(fontSize: 12),
                            ),
                            TextSpan(
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                                text:
                                    " ${getRankFluctuationText(user.unitTimeBeforeRank, userRank)}"),
                          ])),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: "잔고 ",
                              style: TextStyle(fontSize: 10),
                            ),
                            BalanceTextSpan(
                                fontSize: 10,
                                showSign: false,
                                showColor: false,
                                balance: account.balance).get(),
                          ])),
                        ],
                      ),
                    ]),
              ),
            ),
            SizedBox(
              width: 120,
              child: Grid(
                /*
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0))),
                 */
                padding: EdgeInsets.fromLTRB(10, 0, 8, 0),
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "게임 진행 횟수 ", style: TextStyle(fontSize: 10)),
                      TextSpan(
                          text: "${account.gameCount}",
                          style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ])),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(text: "승률 ", style: TextStyle(fontSize: 10)),
                      TextSpan(
                          text: "${account.formattedWinRate}",
                          style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ])),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(text: "베팅률 ", style: TextStyle(fontSize: 10)),
                      TextSpan(
                          text: "${account.formattedBettingRate}",
                          style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getRankFluctuationText(int? before, int? after) {
    if ((before == null) || (after == null)) return "-";
    var fluc = after - before;
    if (fluc == 0) return "-";
    if (fluc < 0) return "▲${-fluc}";
    if (fluc > 0) return "▼${fluc}";
    return "";
  }

  List<RankModel> totalRanks = [];
  List<RankModel> ranks = [];

  Widget buildList() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: ranks.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (!rankLoaded) return getLoadingTile();
        if (index >= totalRanks.length) return getEmptyTile();
        if (index == ranks.length) return getLastTile();
        return getRankModelTile(ranks[index], rank: index + 1);
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 10);
      },
    );
  }

  Widget getLastTile() {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: ButtonGrid(
            color: Colors.blueAccent.withOpacity(0.8),
            onTap: () {
              expandRanks();
            },
            child: Center(
                child: Text("+ 더보기",
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)))));
  }

  Widget getRankModelTile(RankModel rankModel, {int? rank}) {
    int userRank = rank ?? rankModel.rank;
    Color color = Colors.blue.withOpacity(0.2);
    if (userRank == 1) {
      color = Colors.blue.withOpacity(1);
    }
    if (userRank == 2) {
      color = Colors.blue.withOpacity(0.8);
    }
    if (userRank == 3) {
      color = Colors.blue.withOpacity(0.6);
    }
    //if(uc.user.email == rankModel.user.email) color = Colors.orange.withOpacity(.4);
    return buildRankInfo(
        color: color,
        user: rankModel.user,
        account: rankModel.rankAccount,
        rank: userRank);
  }

  Widget getEmptyTile() {
    return Container();
  }

  Widget getLoadingTile() {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: ButtonGrid(
            child: Center(
                child: CircularProgressIndicator(
          strokeWidth: 3,
        ))));
  }

  void expandRanks() {
    print(totalRanks.length);
    print(ranks.length);
    setState(() {
      ranks = totalRanks.sublist(0, min(ranks.length + 5, totalRanks.length));
    });
  }
}
