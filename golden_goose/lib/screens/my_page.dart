import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/account_type.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:golden_goose/widgets/nation_avartar.dart';
import 'package:intl/intl.dart';

class MyPage extends StatefulWidget {
  static const String path = "/MyPage";

  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final uc = Get.find<UserController>();
  var numberFormat = NumberFormat.currency(name: '', decimalDigits: 0);
  bool rankLoaded = false;

  @override
  void initState() {
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
                        InkWell(onTap: () {}, child: Icon(Icons.logout)),
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
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        text:
                                        "${uc.ofAccount(AccountType.rank).formattedBalance}")),
                                SizedBox(height: 10),
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(fontSize: 12),
                                        text:
                                        uc.user.registrationDate == null ? "" : _dateFormat(uc.user.registrationDate!))),
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(fontSize: 12),
                                        text:
                                        "${uc.user.email}")),
                              ]
                          ),
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
            SizedBox(height: 20),
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
  String _dateFormat(DateTime date) {
    return "${date.year}.${date.month}.${date.day}";
  }
}
