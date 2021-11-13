import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/game_button_type.dart';
import 'package:golden_goose/data/mock_data.dart';
import 'package:golden_goose/repositories/repository.dart';
import 'package:golden_goose/screens/home.dart';
import 'package:golden_goose/utils/interactive_chart/candle_data.dart';
import 'package:golden_goose/utils/interactive_chart/chart_style.dart';
import 'package:golden_goose/utils/interactive_chart/interactive_chart.dart';
import 'package:intl/src/intl/number_format.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Game extends StatefulWidget {
  static const String path = "/Game";

  const Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  String market = Get.arguments["market"];
  static const String path = "/Game";
  final uc = Get.find<UserController>();
  double balance = 1000000;
  double balanceFluctuate = 0;
  double winRateFluctuate = 0;
  double winRate = 0;
  int rateCounter = 0;
  int correctCounter = 0;
  var percentFormat = NumberFormat.decimalPercentPattern(decimalDigits: 2);
  var numberFormat = NumberFormat.currency(name: '', decimalDigits: 0);
  AnimationController? animateController1;
  AnimationController? animateController2;
  AnimationController? animateController3;
  AnimationController? animateController4;

  List<Candle> candles = [];
  WebSocketChannel? _channel;

  String interval = "1m";

  void binanceFetch(String interval) {
    fetchCandles(symbol: "BTCUSDT", interval: interval).then(
      (value) => setState(
        () {
          this.interval = interval;
          candles = value;
        },
      ),
    );
    if (_channel != null) _channel!.sink.close();
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://stream.binance.com:9443/ws'),
    );
    _channel!.sink.add(
      jsonEncode(
        {
          "method": "SUBSCRIBE",
          "params": ["btcusdt@kline_" + interval],
          "id": 1
        },
      ),
    );
  }

  @override
  void initState() {
    binanceFetch("1m");
    super.initState();
  }

  @override
  void dispose() {
    if (_channel != null) _channel!.sink.close();
    super.dispose();
  }

  void updateCandlesFromSnapshot(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.data != null) {
      final data = jsonDecode(snapshot.data as String) as Map<String, dynamic>;
      if (data.containsKey("k") == true &&
          candles[0].date.millisecondsSinceEpoch == data["k"]["t"]) {
        candles[0] = Candle(
            date: candles[0].date,
            high: double.parse(data["k"]["h"]),
            low: double.parse(data["k"]["l"]),
            open: double.parse(data["k"]["o"]),
            close: double.parse(data["k"]["c"]),
            volume: double.parse(data["k"]["v"]));
      } else if (data.containsKey("k") == true &&
          data["k"]["t"] - candles[0].date.millisecondsSinceEpoch ==
              candles[0].date.millisecondsSinceEpoch -
                  candles[1].date.millisecondsSinceEpoch) {
        candles.insert(
            0,
            Candle(
                date: DateTime.fromMillisecondsSinceEpoch(data["k"]["t"]),
                high: double.parse(data["k"]["h"]),
                low: double.parse(data["k"]["l"]),
                open: double.parse(data["k"]["o"]),
                close: double.parse(data["k"]["c"]),
                volume: double.parse(data["k"]["v"])));
      }
    }
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
                child: Text(market,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(child: get(), height: 400),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Salvatorie J",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
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
                                    RichText(text: TextSpan(text: "Balance")),
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
                                                  animateController2 = controller
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
                                                  animateController2 = controller
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
                    Row(
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  int index = 0;
  int offset = 60;
  List<CandleData> _data = MockDataTesla.candles.sublist(0, 60);
  late InteractiveChart chart;

  Widget get() {
    chart = InteractiveChart(
      /** Only [candles] is required */
      candles: _data,
      /** Uncomment the following for examples on optional parameters */
      initialVisibleCandleCount: 30 + index,
      now: 0,

      /** Example styling */
      style: ChartStyle(
        //priceGainColor: Colors.green.withAlpha(255).withOpacity(0.8),
        priceGainColor: const Color.fromARGB(255, 38, 166, 154),
        priceLossColor: const Color.fromARGB(255, 239, 83, 80),
        volumeColor: Colors.orange.withOpacity(0.8),
        //priceGridLineColor: Colors.blue[200]!.withOpacity(0.5),
        priceGridLineColor: Colors.white.withOpacity(0.2),
        priceLabelWidth: 0,
        //priceLabelStyle: TextStyle(color: Colors.blue[200]),
        //timeLabelStyle: TextStyle(color: Colors.blue[200]),
        //selectionHighlightColor: Colors.red.withOpacity(0.2),
        //overlayBackgroundColor: Colors.red[900]!.withOpacity(0.6),
        //overlayTextStyle: TextStyle(color: Colors.red[100]),
        timeLabelHeight: 0,
      ),
      /** Customize axis labels */
      timeLabel: (timestamp, visibleDataCount) => "",
      priceLabel: (price) => "",
      /** Customize overlay (tap and hold to see it)
       ** Or return an empty object to disable overlay info. */
      overlayInfo: (candle) => {},
      /** Callbacks */
      onTap: (candle) => print("user tapped on $candle"),
      onCandleResize: (width) => print("each candle is $width wide2"),
    );
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(0, 24.0, 0, 24.0),
      child: Grid(
        decoration: BoxDecoration(),
        child: chart,
      ),
    );
  }

  void run(GameButtonType type) {
    index++;
    goFrontOneCandle();
    print("index : ${index}");
    print("offset : ${offset}");
    print("${_data[index + (offset -2)]}");
    print("${_data[index + (offset -1)]}");
    double before = _data[index + (offset - 2)].close!;
    double after = _data[index + (offset - 1)].close!;
    double rate = (after - before) / before;
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

  void goFrontOneCandle() {
    // chart 에서 true 일시 한칸 앞으로 간다
    _data = MockDataTesla.candles.sublist(0, offset + index);
    goFront = true;
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
}
