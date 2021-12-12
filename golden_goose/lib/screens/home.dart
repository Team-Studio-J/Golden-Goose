import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/account_type.dart';
import 'package:golden_goose/databases/database.dart';
import 'package:golden_goose/models/account.dart';
import 'package:golden_goose/repositories/ad_helper.dart';
import 'package:golden_goose/widgets/balance_text.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Home extends StatefulWidget {
  static const String path = "/Home";

  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final uc = Get.find<UserController>();
  final ac = Get.find<AuthController>();

  late RewardedAd _rewardedAd;
  bool isAdLoaded = false;
  RewardItem? reward;

  @override
  void initState() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('$ad loaded.');
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (RewardedAd ad) =>
                print('$ad onAdShowedFullScreenContent.'),
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              print('$ad onAdDismissedFullScreenContent.');
              if (reward != null) {
                Get.snackbar(
                    "Rewarded".tr, "earned".tr + " \$${reward!.amount}",
                    snackPosition: SnackPosition.BOTTOM);
              }
              ad.dispose();
              setState(() {
                isAdLoaded = false;
              });
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              print('$ad onAdFailedToShowFullScreenContent: $error');
              ad.dispose();
              setState(() {
                isAdLoaded = false;
              });
            },
            onAdImpression: (RewardedAd ad) =>
                print('$ad impression occurred.'),
          );
          _rewardedAd = ad;
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  @override
  void dispose() {
    if (isAdLoaded) {
      _rewardedAd.dispose();
    }
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
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Center(
                        child: Text("Accumulated Reserves".tr,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Center(
                        child: Text("Coming Soon",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
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
                                  color: Colors.indigo.withOpacity(0.8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Rank".tr,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30)),
                                            const SizedBox(height: 10),
                                            Text(uc.user.formattedRank,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 25)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          child: Center(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(uc.user.nickname,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 25)),
                                            ),
                                          ),
                                        ),
                                      ),
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
                                      color: Colors.blue.withOpacity(0.8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(),
                                          Text("Balance".tr,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20)),
                                          const SizedBox(height: 2),
                                          Obx(() => Text.rich(BalanceTextSpan(
                                                balance: uc
                                                    .ofAccount(AccountType.rank)
                                                    .balance,
                                                showSign: false,
                                                showColor: false,
                                                normalColor: null,
                                                fontSize: 16,
                                              ).get())),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                      flex: 50,
                                      child: Grid(
                                          color:
                                              Colors.lightBlue.withOpacity(0.8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(),
                                              Text("Last Game".tr,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14)),
                                              Text("Win Rate".tr,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 16)),
                                              const SizedBox(height: 2),
                                              Obx(() {
                                                var result = uc.ofLastResult(
                                                    AccountType.rank);
                                                if (result == null) {
                                                  return const Text("-");
                                                }
                                                return Text(
                                                    result.gameAccount
                                                        .formattedWinRate,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 15));
                                              }),
                                            ],
                                          ))),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      height: 100,
                      child: isAdLoaded
                          ? ButtonGrid(
                              color: Colors.blue.withOpacity(0.8),
                              onTap: () {
                                _rewardedAd.show(onUserEarnedReward:
                                    (RewardedAd ad, RewardItem reward) {
                                  this.reward = reward;
                                  Database.updateAccount(
                                      ac.user!,
                                      Account.nullSafeMapper(
                                        balance: uc
                                                .ofAccount(AccountType.rank)
                                                .balance +
                                            reward.amount.toInt(),
                                      ),
                                      AccountType.rank);
                                  Database.updateAccount(
                                      ac.user!,
                                      Account.nullSafeMapper(
                                        balance: uc
                                                .ofAccount(AccountType.unrank)
                                                .balance +
                                            reward.amount.toInt(),
                                      ),
                                      AccountType.unrank);
                                });
                              },
                              child: Center(
                                  child: Text("Watch Ads for rewards".tr,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700))))
                          : Grid(
                              color: Colors.orange.withOpacity(0.8),
                              child: Center(
                                  child: Text("Preparing for rewards".tr,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600))))),
                  const SizedBox(height: 20),
                  const SizedBox(
                      height: 100,
                      child:
                          Grid(child: Center(child: Text("Shop Coming Soon")))),
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
