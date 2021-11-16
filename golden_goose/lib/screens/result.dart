import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/coin.dart';
import 'package:golden_goose/utils/interactive_chart/candle_data.dart';
import 'package:golden_goose/utils/time.dart';
import 'package:golden_goose/widgets/candlechart.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:intl/src/intl/number_format.dart';

class Result extends StatelessWidget {
  static Map<String, dynamic> buildResultArguments({
    required Coin market,
    required String interval,
    required int startTime,
    required int limit,
    required int lastBalance,
    required int firstBalance,
    required double winRate,
    required int longs,
    required int holds,
    required int shorts,
    required List<CandleData> candles,
  }) {
    return {
      "market": market,
      "interval": interval,
      "startTime": startTime,
      "limit": limit,
      "lastBalance": lastBalance,
      "firstBalance": firstBalance,
      "winRate": winRate,
      "longs": longs,
      "holds": holds,
      "shorts": shorts,
      "candles": candles,
    };
  }

  Result({Key? key}) : super(key: key);
  static const String path = "/Result";

  final uc = Get.find<UserController>();

  Coin market = Get.arguments["market"];
  String interval = Get.arguments["interval"];
  int startTime = Get.arguments["startTime"];
  int limit = Get.arguments["limit"];
  int lastBalance = Get.arguments["lastBalance"];
  int firstBalance = Get.arguments["firstBalance"];
  double winRate = Get.arguments["winRate"];
  int longs = Get.arguments["longs"];
  int holds = Get.arguments["holds"];
  int shorts = Get.arguments["shorts"];
  List<CandleData> candles = Get.arguments["candles"];
  var percentFormat = NumberFormat.decimalPercentPattern(decimalDigits: 2);
  var numberFormat = NumberFormat.currency(name: '', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
                child: ListView(physics: BouncingScrollPhysics(), children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: const Center(
          child: const Text("매매 결과",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
      SizedBox(
          height: 400,
          child: CandleChart(
            data: candles,
            initialVisibleCandleCount: candles.length,
          )),
      Padding(
        padding: const EdgeInsets.all(17.0),
        child: Grid(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("매매 코인"), Text("${market.symbolInBinanace}")],
              ),
              SizedBox(height:10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("시간 간격"), Text("${interval}")],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("차트 시간대"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                      children:[
                    Text(
                        "${_dateFormat(DateTime.fromMillisecondsSinceEpoch(startTime))}",
                        style: TextStyle(fontSize: 10,)),
                    Text(
                        "${_dateFormat(DateTime.fromMillisecondsSinceEpoch(startTime + limit * Time.intervalToMilliseconds(interval)))}",
                        style: TextStyle(fontSize: 10,)),

                  ])
                ],
              ),
              SizedBox(height:10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("매매 후 잔고"),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "${numberFormat.format(lastBalance)}"),
                    lastBalance - firstBalance >= 0
                        ? TextSpan(
                            text:
                                " ${numberFormat.format(lastBalance - firstBalance)}",
                            style: TextStyle(color: Colors.green))
                        : TextSpan(
                            text:
                                " ${numberFormat.format(lastBalance - firstBalance)}",
                            style: TextStyle(color: Colors.red)),
                  ])),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("승률"),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "${percentFormat.format(winRate)}"),
                  ])),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("롱 횟수"),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${longs}", style: TextStyle(color: Colors.blue)),
                  ])),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("홀드 횟수"),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "${holds}"),
                  ])),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("숏 횟수"),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${shorts}", style: TextStyle(color: Colors.red)),
                  ])),
                ],
              ),
            ],
          ),
        ),
      ),
    ]))));
  }

  String _dateFormat(DateTime date) {
    return "${date.year}.${date.month}.${date.day} ${date.hour}:${date.minute}";
  }
}
