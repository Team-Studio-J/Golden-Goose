import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/interval_type.dart';
import 'package:golden_goose/data/market_type.dart';
import 'package:golden_goose/models/account.dart';
import 'package:golden_goose/models/game_result_model.dart';
import 'package:golden_goose/utils/interactive_chart/candle_data.dart';
import 'package:golden_goose/widgets/candlechart.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:intl/src/intl/number_format.dart';

class Result extends StatelessWidget {
  Result(
      {Key? key,
      required this.initialAccount,
      required this.gameAccount,
      required this.gameResultModel,
      required this.candles})
      : super(key: key);
  static const String path = "/Result";

  final uc = Get.find<UserController>();

  GameResultModel gameResultModel;
  Account initialAccount;
  Account gameAccount;
  List<CandleData> candles;
  var percentFormat = NumberFormat.decimalPercentPattern(decimalDigits: 2);
  var numberFormat = NumberFormat.currency(name: '', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
                child:
                    ListView(physics: const BouncingScrollPhysics(), children: [
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
                children: [
                  Text("매매 코인"),
                  Text(
                      "${gameResultModel.gameTypeModel.marketType.symbolInBinanace}")
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("시간 간격"),
                  Text("${gameResultModel.gameTypeModel.intervalType.name}")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("차트 시간대"),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(
                        "${_dateFormat(DateTime.fromMillisecondsSinceEpoch(gameResultModel.gameTypeModel.startTime))}",
                        style: TextStyle(
                          fontSize: 10,
                        )),
                    Text(
                        "${_dateFormat(DateTime.fromMillisecondsSinceEpoch(gameResultModel.gameTypeModel.startTime + gameResultModel.gameTypeModel.limit * gameResultModel.gameTypeModel.intervalType.toMilliseconds()))}",
                        style: TextStyle(
                          fontSize: 10,
                        )),
                  ])
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("매매 후 잔고"),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${numberFormat.format(gameAccount.balance)}"),
                    gameAccount.balance - initialAccount.balance >= 0
                        ? TextSpan(
                            text:
                                " ${numberFormat.format(gameAccount.balance - initialAccount.balance)}",
                            style: TextStyle(color: Colors.green))
                        : TextSpan(
                            text:
                                " ${numberFormat.format(gameAccount.balance - initialAccount.balance)}",
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
                    TextSpan(
                        text: "${percentFormat.format(gameAccount.winRate)}"),
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
                        text: "${gameAccount.longs}",
                        style: TextStyle(color: Colors.blue)),
                  ])),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("홀드 횟수"),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "${gameAccount.holds}"),
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
                        text: "${gameAccount.shorts}",
                        style: TextStyle(color: Colors.red)),
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
