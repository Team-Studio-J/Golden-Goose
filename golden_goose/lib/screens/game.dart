import 'dart:convert';

import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/mock_data.dart';
import 'package:golden_goose/repositories/repository.dart';
import 'package:golden_goose/screens/home.dart';
import 'package:interactive_chart/interactive_chart.dart';
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
                child: Text(market,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              /*
              SafeArea(
                minimum: const EdgeInsets.all(24.0),
                child: SizedBox(
                  height: appSize.height * 0.6 + (SliverAppBar().toolbarHeight * 2),
                  child: StreamBuilder(
                    stream: _channel == null ? null : _channel!.stream,
                    builder: (context, snapshot) {
                      updateCandlesFromSnapshot(snapshot);
                      return Candlesticks(
                        onIntervalChange: (String value) async {
                          binanceFetch(value);
                        },
                        candles: candles,
                        interval: interval,
                      );
                    },
                  ),
                ),
              ),
               */
              SizedBox(child: get(context), height: 400),
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
                          child: Grid(
                              child: RichText(
                                  text: TextSpan(children: [
                            TextSpan(text: "Balance"),
                            TextSpan(text: "\n"),
                            TextSpan(
                              text: "1,220,340 \$",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            TextSpan(
                                text: " +2,400",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 10)),
                          ]))),
                        ),
                        Expanded(
                          child: Grid(child: Text("Balance")),
                        ),
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

  List<CandleData> _data = MockDataTesla.candles;

  Widget get(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(0, 24.0, 0, 24.0),
      child: Grid(
        decoration: BoxDecoration(),
        child: InteractiveChart(
          /** Only [candles] is required */
          candles: _data,
          /** Uncomment the following for examples on optional parameters */
          initialVisibleCandleCount: 30,

          /** Example styling */
          style: ChartStyle(
            //priceGainColor: Colors.green.withAlpha(255).withOpacity(0.8),
            priceGainColor: const Color.fromARGB(255, 38, 166, 154),
            priceLossColor: const Color.fromARGB(255, 239, 83, 80),
            volumeColor: Colors.orange.withOpacity(0.8),
            trendLineStyles: [
              Paint()
                ..strokeWidth = .0
                ..strokeCap = StrokeCap.round
                ..color = Colors.blue,
              Paint()
                ..strokeWidth = .0
                ..strokeCap = StrokeCap.round
                ..color = Colors.blue,
            ],
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
          onCandleResize: (width) => print("each candle is $width wide"),
        ),
      ),
    );
  }
}
