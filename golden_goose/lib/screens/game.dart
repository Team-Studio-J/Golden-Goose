import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/game_button_type.dart';
import 'package:golden_goose/data/interval_type.dart';
import 'package:golden_goose/data/market_type.dart';
import 'package:golden_goose/databases/database.dart';
import 'package:golden_goose/models/account.dart';
import 'package:golden_goose/models/game_result_model.dart';
import 'package:golden_goose/models/game_result_single_record.dart';
import 'package:golden_goose/models/game_type_model.dart';
import 'package:golden_goose/screens/result.dart';
import 'package:golden_goose/utils/candle_fetcher.dart';
import 'package:golden_goose/utils/interactive_chart/candle_data.dart';
import 'package:golden_goose/utils/interactive_chart/interactive_chart.dart';
import 'package:golden_goose/widgets/balance_text.dart';
import 'package:golden_goose/widgets/candlechart.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:intl/intl.dart';

class Game extends StatefulWidget {
  GameTypeModel gameTypeModel;
  static const String path = "/Game";

  Game({Key? key, required this.gameTypeModel}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  final AuthController ac = Get.find<AuthController>();
  final UserController uc = Get.find<UserController>();
  static const initialOffset = 60;
  late Account initialAccount;
  late Account gameAccount;
  int balanceFluctuate = 0;
  double winRateFluctuate = 0;
  double winRate = 0;
  var percentFormat = NumberFormat.decimalPercentPattern(decimalDigits: 2);
  var numberFormat = NumberFormat.currency(name: '', decimalDigits: 0);
  AnimationController? animateController1;
  AnimationController? animateController2;
  AnimationController? animateController3;
  AnimationController? animateController4;

  List<CandleData> candles = [];
  List<GameResultSingleRecord> records = [];
  bool isCandleUpdated = false;

  @override
  void initState() {
    print(
        "market: ${widget.gameTypeModel.marketType.symbolInBinanace}, interval: $interval, startTime: ${widget.gameTypeModel.startTime}, endTime: ${widget.gameTypeModel.endTime}, limit: ${widget.gameTypeModel.limit}");
    CandleFetcher.fetchCandles(
      symbol: widget.gameTypeModel.marketType.symbolInBinanace,
      interval: widget.gameTypeModel.intervalType.name,
      startTime: widget.gameTypeModel.startTime,
      endTime: widget.gameTypeModel.endTime,
      limit: widget.gameTypeModel.limit,
    ).then((value) => setState(() {
          candles = value;
          // visibleLastOffset = candles.length - 1;
          assignCandleToData();
        }));
    initialAccount = uc.ofAccount(widget.gameTypeModel.accountType);
    gameAccount = Account(balance: initialAccount.balance);
    updateUser(must: true);
    super.initState();
  }

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
            Center(
              child: Text(widget.gameTypeModel.marketType.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
                child: _data.length == 0
                    ? Center(
                        child: SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator()))
                    : CandleChart(data: _data),
                height: 400),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Salvatorie J",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      RichText(
                          text: TextSpan(
                              text:
                                  "${candles.length - 1 - visibleLastOffset} left")),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Grid(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                      text: const TextSpan(text: "Balance")),
                                  Row(children: [
                                    balanceFluctuate > 0
                                        ? FadeInUp(
                                            from: 5,
                                            duration:
                                                Duration(milliseconds: 300),
                                            controller: (controller) =>
                                                animateController1 = controller
                                                  ..forward(from: 0.0),
                                            child: Text.rich(BalanceTextSpan(
                                              balance: gameAccount.balance,
                                              fontSize: 10,
                                              showSign: false,
                                              showColor: false,
                                            ).get()),
                                          )
                                        : FadeInDown(
                                            from: 5,
                                            duration:
                                                Duration(milliseconds: 300),
                                            controller: (controller) =>
                                                animateController1 = controller
                                                  ..forward(from: 0.0),
                                            child: Text.rich(BalanceTextSpan(
                                                    balance:
                                                        gameAccount.balance,
                                                    fontSize: 10,
                                                    showSign: false,
                                                    showColor: false)
                                                .get()),
                                          ),
                                    balanceFluctuate > 0
                                        ? FadeOutUp(
                                            from: 20,
                                            duration:
                                                Duration(milliseconds: 1000),
                                            controller: (controller) =>
                                                animateController2 = controller
                                                  ..forward(from: 0.0),
                                            child: Text.rich(BalanceTextSpan(
                                              balance: balanceFluctuate,
                                              fontSize: 10,
                                              showColor: true,
                                              symbol: '',
                                            ).get()),
                                          )
                                        : FadeOutDown(
                                            from: 20,
                                            duration:
                                                Duration(milliseconds: 1000),
                                            controller: (controller) =>
                                                animateController2 = controller
                                                  ..forward(from: 0.0),
                                            child: Text.rich(BalanceTextSpan(
                                              balance: balanceFluctuate,
                                              fontSize: 10,
                                              showColor: true,
                                              symbol: '',
                                            ).get()),
                                          ),
                                    /*
                                    FadeTransition(
                                      opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: curve)),
                                      child: Text(" ${percentFormat.format(
                                          winRateFluctuate)}", style: TextStyle(
                                          color: Colors.green, fontSize: 10)),
                                    )

                                     */
                                  ]),
                                ]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Grid(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(text: TextSpan(text: "Win Rate")),
                                  Row(children: [
                                    winRateFluctuate > 0
                                        ? FadeInUp(
                                            from: 5,
                                            duration:
                                                Duration(milliseconds: 300),
                                            controller: (controller) =>
                                                animateController3 = controller
                                                  ..forward(from: 0.0),
                                            child: Text(
                                                "${percentFormat.format(winRate)}",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10)),
                                          )
                                        : FadeInDown(
                                            from: 5,
                                            duration:
                                                Duration(milliseconds: 300),
                                            controller: (controller) =>
                                                animateController3 = controller
                                                  ..forward(from: 0.0),
                                            child: Text(
                                                "${percentFormat.format(winRate)}",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10)),
                                          ),
                                    winRateFluctuate > 0
                                        ? FadeOutUp(
                                            from: 20,
                                            duration:
                                                Duration(milliseconds: 1000),
                                            controller: (controller) =>
                                                animateController4 = controller
                                                  ..forward(from: 0.0),
                                            child: Text(
                                                " +${percentFormat.format(winRateFluctuate)}",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 10)),
                                          )
                                        : FadeOutDown(
                                            from: 20,
                                            duration:
                                                Duration(milliseconds: 1000),
                                            controller: (controller) =>
                                                animateController4 = controller
                                                  ..forward(from: 0.0),
                                            child: Text(
                                                " ${percentFormat.format(winRateFluctuate)}",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 10)),
                                          ),
                                    /*
                                    FadeTransition(
                                      opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: curve)),
                                      child: Text(" ${percentFormat.format(
                                          winRateFluctuate)}", style: TextStyle(
                                          color: Colors.green, fontSize: 10)),
                                    )

                                     */
                                  ]),
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Expanded(
                            flex: 2,
                            child: ButtonGrid(
                                onTap: () {
                                  run(GameButtonType.long);
                                },
                                decoration: BoxDecoration(color: Colors.blue),
                                child: Center(child: Text("Long")))),
                        Spacer(),
                        Expanded(
                            flex: 2,
                            child: ButtonGrid(
                                onTap: () {
                                  run(GameButtonType.hold);
                                },
                                decoration: BoxDecoration(color: Colors.grey),
                                child: Center(child: Text("Hold")))),
                        Spacer(),
                        Expanded(
                            flex: 2,
                            child: ButtonGrid(
                                onTap: () {
                                  run(GameButtonType.short);
                                },
                                decoration: BoxDecoration(color: Colors.red),
                                child: Center(child: Text("Short")))),
                        Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getFadeInWidget() {
    Widget text = Text("${percentFormat.format(winRate)}",
        style: TextStyle(color: Colors.grey, fontSize: 10));
    if (winRateFluctuate == 0) {
      return text;
    }
    return winRateFluctuate > 0
        ? FadeInUp(
            from: 5,
            duration: Duration(milliseconds: 300),
            controller: (controller) =>
                animateController3 = controller..forward(from: 0.0),
            child: text,
          )
        : FadeInDown(
            from: 5,
            duration: Duration(milliseconds: 300),
            controller: (controller) =>
                animateController3 = controller..forward(from: 0.0),
            child: text,
          );
  }

  int visibleLastOffset = initialOffset - 1;
  List<CandleData> _data = [];

  void run(GameButtonType type) {
    if (!isCandleUpdated) return;
    if (!canGoFront()) {
      updateUser(must: true);
      Get.off(() => Result(
            gameResultModel: GameResultModel(
                records: records,
                gameAccount: gameAccount,
                balanceAtStart: initialAccount.balance,
                gameTypeModel: widget.gameTypeModel),
            initialAccount: initialAccount,
            gameAccount: gameAccount,
            candles: candles,
          ));
      return;
    }
    goFrontOneCandle();
    print("visibleLastOffset : ${visibleLastOffset}");
    print("${_data[visibleLastOffset]}");
    double before = _data[visibleLastOffset - 1].close!;
    double after = _data[visibleLastOffset].close!;
    double rate = (after - before) / before;
    countButtons(type, rate);
    if (type != GameButtonType.hold) {
      evaluateRate(type, rate);
      evaluateBalance(type, rate);
      if (animateController1 != null) animateController1!.forward(from: 0.0);
      if (animateController2 != null) animateController2!.forward(from: 0.0);
      if (animateController3 != null) animateController3!.forward(from: 0.0);
      if (animateController4 != null) animateController4!.forward(from: 0.0);
    }
    records.add(GameResultSingleRecord(
      balanceBefore: gameAccount.balance - balanceFluctuate,
      balanceAfter: gameAccount.balance,
      volumeBefore: _data[visibleLastOffset].volume!,
      volumeAfter: _data[visibleLastOffset - 1].volume!,
      closingPriceAfter: _data[visibleLastOffset].close!,
      closingPriceBefore: _data[visibleLastOffset - 1].close!,
      buttonType: type,
    ));
    updateUser();
    setState(() {});
  }

  bool canGoFront() {
    return visibleLastOffset < candles.length - 1;
  }

  void goFrontOneCandle() {
    // chart 에서 true 일시 한칸 앞으로 간다
    if (canGoFront()) {
      visibleLastOffset++;
      assignCandleToData();
      goFront = true;
    }
  }

  void assignCandleToData() {
    isCandleUpdated = true;
    _data = candles.sublist(0, visibleLastOffset + 1);
  }

  void evaluateRate(GameButtonType type, double rate) {
    if (type == GameButtonType.hold) {
      return;
    }

    var beforeWinRate = winRate;
    winRate = gameAccount.winRate;
    winRateFluctuate = winRate - beforeWinRate;
  }

  void evaluateBalance(GameButtonType type, double rate) {
    int beforeBalance = gameAccount.balance;

    switch (type) {
      case GameButtonType.long:
        gameAccount.balance += (rate * gameAccount.balance).round();
        break;
      case GameButtonType.hold:
        break;
      case GameButtonType.short:
        gameAccount.balance += -(rate * gameAccount.balance).round();
        break;
    }

    balanceFluctuate = gameAccount.balance - beforeBalance;
  }

  void countButtons(GameButtonType type, double rate) {
    if (rate >= 0) {
      switch (type) {
        case GameButtonType.long:
          gameAccount.longWhenRise++;
          break;
        case GameButtonType.hold:
          gameAccount.holdWhenRise++;
          break;
        case GameButtonType.short:
          gameAccount.shortWhenRise++;
          break;
      }
    } else {
      switch (type) {
        case GameButtonType.long:
          gameAccount.longWhenFall++;
          break;
        case GameButtonType.hold:
          gameAccount.holdWhenFall++;
          break;
        case GameButtonType.short:
          gameAccount.shortWhenFall++;
          break;
      }
    }
  }

  @override
  void dispose() {
    updateUser(must: true);
    super.dispose();
  }

  void updateUser({bool must: false}) {
    if (!must) {
      if (Random().nextInt(100) >= 10) return; //10% 확률로 업데이트
    }
    print("update account!");
    Database.accountUpdate(
        ac.user!,
        Account.nullSafeMapper(
          balance: gameAccount.balance,
          gameCount: initialAccount.gameCount + 1,
          longWhenRise: initialAccount.longWhenRise + gameAccount.longWhenRise,
          holdWhenRise: initialAccount.holdWhenRise + gameAccount.holdWhenRise,
          shortWhenRise:
              initialAccount.shortWhenRise + gameAccount.shortWhenRise,
          longWhenFall: initialAccount.longWhenFall + gameAccount.longWhenFall,
          holdWhenFall: initialAccount.holdWhenFall + gameAccount.holdWhenFall,
          shortWhenFall:
              initialAccount.shortWhenFall + gameAccount.shortWhenFall,
        ),
        widget.gameTypeModel.accountType);
  }
}
