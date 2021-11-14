import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/coin.dart';
import 'package:golden_goose/data/game_button_type.dart';
import 'package:golden_goose/screens/home.dart';
import 'package:golden_goose/screens/result.dart';
import 'package:golden_goose/utils/candle_fetcher.dart';
import 'package:golden_goose/utils/interactive_chart/candle_data.dart';
import 'package:golden_goose/utils/interactive_chart/interactive_chart.dart';
import 'package:golden_goose/utils/time.dart';
import 'package:golden_goose/widgets/candlechart.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:intl/src/intl/number_format.dart';

class Game extends StatefulWidget {
  static const possibleInterval = [
    '1h',
    '2h',
    '4h',
    '6h',
    '8h',
    '12h',
    '1d',
    //'3d',
  ];
  static final _random = Random();

  static Map<String, dynamic> getRandomGameArgumentExceptThat(
      {Coin? market,
      String? interval,
      int? startTime,
      int? endTime,
      int? limit}) {
    Coin selectedMarket = market ?? (Coin.values..shuffle(_random)).first;
    String selectedInterval =
        interval ?? possibleInterval[_random.nextInt(possibleInterval.length)];
    int selectedLimit = limit ?? 120;
    int nowInMilliseconds = DateTime.now().millisecondsSinceEpoch;
    int millisecondsPerInterval = Time.intervalToMilliseconds(selectedInterval);
    return {
      "market": selectedMarket,
      "interval": selectedInterval,
      "startTime": startTime ??
          selectedMarket.firstTime +
              (_random.nextDouble() *
                      (nowInMilliseconds -
                          selectedMarket.firstTime -
                          millisecondsPerInterval * selectedLimit))
                  .round(),
      "endTime": endTime,
      "limit": selectedLimit,
    };
  }

  static const String path = "/Game";

  const Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  static const initialOffset = 60;
  Coin market = Get.arguments["market"];
  String interval = Get.arguments["interval"];
  int startTime = Get.arguments["startTime"];
  int? endTime = Get.arguments["endTime"];
  int limit = Get.arguments["limit"];
  static const String path = "/Game";
  final uc = Get.find<UserController>();
  double firstBalance = 1000000;
  double balance = 1000000;
  double balanceFluctuate = 0;
  double winRateFluctuate = 0;
  double winRate = 0;
  int rateCounter = 0;
  int correctCounter = 0;
  int longs = 0;
  int shorts = 0;
  int holds = 0;
  var percentFormat = NumberFormat.decimalPercentPattern(decimalDigits: 2);
  var numberFormat = NumberFormat.currency(name: '', decimalDigits: 0);
  AnimationController? animateController1;
  AnimationController? animateController2;
  AnimationController? animateController3;
  AnimationController? animateController4;

  List<CandleData> candles = [];

  @override
  void initState() {
    print(
        "market: ${market.symbolInBinanace}, interval: $interval, startTime: $startTime, endTime: $endTime, limit: $limit");
    CandleFetcher.fetchCandles(
      symbol: market.symbolInBinanace,
      interval: interval,
      startTime: startTime,
      endTime: endTime,
      limit: limit,
    ).then((value) => setState(() {
          candles = value;
          // visibleLastOffset = candles.length - 1;
          assignCandleToData();
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size appSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: Center(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 20),
              Column(
                children: [
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
              Center(
                child: Text(market.name,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                  child: _data.length == 0
                      ? Container()
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
                                                  animateController1 =
                                                      controller
                                                        ..forward(from: 0.0),
                                              child: Text(
                                                  "${numberFormat.format(balance)} \$",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10)),
                                            )
                                          : FadeInDown(
                                              from: 5,
                                              duration:
                                                  Duration(milliseconds: 300),
                                              controller: (controller) =>
                                                  animateController1 =
                                                      controller
                                                        ..forward(from: 0.0),
                                              child: Text(
                                                  "${numberFormat.format(balance)} \$",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10)),
                                            ),
                                      balanceFluctuate > 0
                                          ? FadeOutUp(
                                              from: 20,
                                              duration:
                                                  Duration(milliseconds: 1000),
                                              controller: (controller) =>
                                                  animateController2 =
                                                      controller
                                                        ..forward(from: 0.0),
                                              child: Text(
                                                  " +${numberFormat.format(balanceFluctuate)}",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 10)),
                                            )
                                          : FadeOutDown(
                                              from: 20,
                                              duration:
                                                  Duration(milliseconds: 1000),
                                              controller: (controller) =>
                                                  animateController2 =
                                                      controller
                                                        ..forward(from: 0.0),
                                              child: Text(
                                                  " ${numberFormat.format(balanceFluctuate)}",
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
                                                  animateController3 =
                                                      controller
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
                                                  animateController3 =
                                                      controller
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
                                                  animateController4 =
                                                      controller
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
                                                  animateController4 =
                                                      controller
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
    if (!canGoFront()) {
      Get.off(() => Result(),
          arguments: Result.buildResultArguments(
              market: market,
              interval: interval,
              startTime: startTime,
              limit: limit,
              lastBalance: balance.round(),
              firstBalance: firstBalance.round(),
              winRate: winRate,
              longs: longs,
              holds: holds,
              shorts: shorts,
              candles: candles));
      return;
    }
    goFrontOneCandle();
    print("visibleLastOffset : ${visibleLastOffset}");
    print("${_data[visibleLastOffset]}");
    double before = _data[visibleLastOffset - 1].close!;
    double after = _data[visibleLastOffset].close!;
    double rate = (after - before) / before;
    countButtons(type);
    if (type != GameButtonType.hold) {
      evaluateRate(type, rate);
      evaluateBalance(type, rate);
      if (animateController1 != null) animateController1!.forward(from: 0.0);
      if (animateController2 != null) animateController2!.forward(from: 0.0);
      if (animateController3 != null) animateController3!.forward(from: 0.0);
      if (animateController4 != null) animateController4!.forward(from: 0.0);
    }
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
    _data = candles.sublist(0, visibleLastOffset + 1);
  }

  void evaluateRate(GameButtonType type, double rate) {
    if (rate == 0) {
      return;
    }
    if (type == GameButtonType.hold) {
      return;
    }

    rateCounter++;
    if (type == GameButtonType.long && rate > 0 ||
        type == GameButtonType.short && rate < 0) {
      correctCounter++;
    }
    var beforeWinRate = winRate;
    winRate = correctCounter / rateCounter;
    winRateFluctuate = winRate - beforeWinRate;
  }

  void evaluateBalance(GameButtonType type, double rate) {
    var beforeBalance = balance;

    switch (type) {
      case GameButtonType.long:
        balance += rate * balance;
        break;
      case GameButtonType.hold:
        break;
      case GameButtonType.short:
        balance += -rate * balance;
        break;
    }

    balanceFluctuate = balance - beforeBalance;
  }

  void countButtons(GameButtonType type) {
    switch(type) {
      case GameButtonType.long:
        longs++;
        break;
      case GameButtonType.hold:
        holds++;
        break;
      case GameButtonType.short:
        shorts++;
        break;
    }
  }
}
