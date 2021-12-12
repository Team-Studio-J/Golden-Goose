import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/account_type.dart';
import 'package:golden_goose/data/market_type.dart';
import 'package:golden_goose/models/game_result_model.dart';
import 'package:golden_goose/repositories/ad_helper.dart';
import 'package:golden_goose/screens/result.dart';
import 'package:golden_goose/screens/settings.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:golden_goose/widgets/nation_avatar.dart';
import 'package:intl/intl.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
  static const AccountType type = AccountType.rank;
  var numberFormat = NumberFormat.currency(name: '', decimalDigits: 0);

  // TODO: Add a BannerAd instance
  late BannerAd _ad;

  // TODO: Add _isAdLoaded
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    // TODO: Create a BannerAd instance
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    // TODO: Load an ad
    _ad.load();
  }

  @override
  void dispose() {
    _ad.dispose();

    super.dispose();
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
                            NationAvatar(nation: uc.user.nation),
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 100,
                              child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Obx(() => Text(
                                        "${uc.user.nickname} ",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ))),
                            ),
                            RichText(
                                text: TextSpan(text: uc.user.formattedRank))
                          ],
                        ),
                        Row(children: [
                          InkWell(
                              onTap: () => Get.to(() => Settings()),
                              child: const Icon(Icons.edit)),
                          const SizedBox(width: 10),
                          InkWell(
                              onTap: () => Get.offAll(() => Login()),
                              child: const Icon(Icons.logout)),
                        ]),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        text: uc
                                            .ofAccount(type)
                                            .formattedBalance)),
                                const SizedBox(height: 10),
                                RichText(
                                    text: TextSpan(
                                        style: const TextStyle(fontSize: 12),
                                        text:
                                            uc.user.formattedRegistrationDate)),
                                RichText(
                                    text: TextSpan(
                                        style: const TextStyle(fontSize: 12),
                                        text: uc.user.email)),
                              ]),
                          Grid(
                            child: Row(children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      fit:BoxFit.scaleDown,
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: "num of Games".tr+' ',
                                            style: TextStyle(fontSize: 10)),
                                        TextSpan(
                                            text:
                                                "${uc.ofAccount(type).gameCount}",
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey)),
                                      ])),
                                    ),

                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: "Win rate".tr+' ',
                                            style: TextStyle(fontSize: 10)),
                                        TextSpan(
                                            text: uc
                                                .ofAccount(type)
                                                .formattedWinRate,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey)),
                                      ])),
                                    ),
                                  ]),
                              const SizedBox(width: 10),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: "Long ratio".tr+' ',
                                          style: TextStyle(fontSize: 10)),
                                      TextSpan(
                                          text: uc
                                              .ofAccount(type)
                                              .formattedLongOnTrialRatio,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey)),
                                    ])),
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: "Short ratio".tr+' ',
                                          style: TextStyle(fontSize: 10)),
                                      TextSpan(
                                          text: uc
                                              .ofAccount(type)
                                              .formattedShortOnTrialRatio,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey)),
                                    ])),
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: "Betting rate".tr+' ',
                                          style: TextStyle(fontSize: 10)),
                                      TextSpan(
                                          text: uc
                                              .ofAccount(type)
                                              .formattedBettingRate,
                                          style: const TextStyle(
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
            const SizedBox(height: 20),
            buildCard(context),
            const SizedBox(height: 40),
            Container(
              child: AdWidget(ad: _ad),
              width: _ad.size.width.toDouble(),
              height: 80.0,
              alignment: Alignment.center,
            ),
            const SizedBox(height: 40),
            Center(child: Text("Trading History".tr)),
            const SizedBox(height: 0),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Text("Last 20 games".tr,
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
          color: const Color.fromRGBO(80, 80, 80, 1),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                    flex: 10,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text.rich(TextSpan(
                            text: "Short Scalpers",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ))))),
                const Spacer(
                  flex: 13,
                ),
                const Expanded(
                    flex: 10,
                    child: Text("Coming Soon",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700))),
                const Spacer(
                  flex: 10,
                ),
                Expanded(
                    flex: 10,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Obx(() =>
                            RichText(text: TextSpan(text: uc.user.nickname))))),
              ]),
        ),
      ),
    ]);
  }

  Widget buildHistories() {
    return Obx(() {
      return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: uc.ofResults(type).length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (uc.ofResults(type).isEmpty) return getEmptyTile();
          if (index >= uc.ofResults(type).length) return Container();
          return getHistoryTile(uc.ofResults(type)[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          if (index == uc.ofResults(type).length - 1) return Container();
          return getSeparator();
        },
      );
    });
  }

  Widget getSeparator() {
    return Column(children: [
      const SizedBox(height: 2),
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
      const SizedBox(height: 2),
    ]);
  }

  Widget getLoadingTile() {
    return const SizedBox(
        width: double.infinity,
        height: 30,
        child: ButtonGrid(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                    text: "Selected market".tr,
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
                        TextSpan(text: "Trading P/L".tr, style: TextStyle(fontSize: 10)),
                      ])),
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(text: "Profit rate".tr, style: TextStyle(fontSize: 10)),
                    ])),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "Trading date".tr, style: TextStyle(fontSize: 10)),
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
              gameResultModel: gameResult,
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
                    text: gameResult.gameTypeModel.marketType.name,
                    style: const TextStyle(fontSize: 12),
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
                            text: gameResult.formattedRevenue,
                            style: TextStyle(
                                fontSize: 10,
                                color: getColorByValue(
                                    gameResult.revenue.toDouble()))),
                      ])),
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: gameResult.formattedRevenueRate,
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
                      text: gameResult.formattedDate,
                      style: const TextStyle(fontSize: 10, color: Colors.grey)),
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

  Widget getEmptyTile() {
    return SizedBox(
      height: 30,
      child: Grid(child: FittedBox(child: Text("Empty History".tr))),
    );
  }
}
