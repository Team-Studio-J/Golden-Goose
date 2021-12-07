import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/interval_type.dart';
import 'package:golden_goose/data/market_type.dart';
import 'package:golden_goose/models/account.dart';
import 'package:golden_goose/models/game_result_model.dart';
import 'package:golden_goose/utils/candle_fetcher.dart';
import 'package:golden_goose/utils/interactive_chart/candle_data.dart';
import 'package:golden_goose/widgets/candlechart.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:intl/intl.dart';

class Result extends StatefulWidget {
  static const String path = "/Result";

  final GameResultModel gameResultModel;
  final Account initialAccount;
  final Account gameAccount;
  List<CandleData>? candles;

  Result(
      {Key? key,
        required this.initialAccount,
        required this.gameAccount,
        required this.gameResultModel,
        this.candles})
      : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final uc = Get.find<UserController>();

  final percentFormat = NumberFormat.decimalPercentPattern(decimalDigits: 2);

  final numberFormat = NumberFormat.currency(name: '', decimalDigits: 0);

  bool loaded = false;


  @override
  void initState() {
    if(widget.candles == null) {
      CandleFetcher.fetchCandles(
        symbol: widget.gameResultModel.gameTypeModel.marketType.symbolInBinanace,
        interval: widget.gameResultModel.gameTypeModel.intervalType.name,
        startTime: widget.gameResultModel.gameTypeModel.startTime,
        endTime: widget.gameResultModel.gameTypeModel.endTime,
        limit: widget.gameResultModel.gameTypeModel.limit,
      ).then((value) => setState(() {
        widget.candles = value;
        loaded = true;
      }));

    } else {
      setState(() {
        loaded = true;
      });
    }
    super.initState();
  }

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
          child: !loaded
              ? Center(
              child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator()))
              : CandleChart(
            data: widget.candles!,
            initialVisibleCandleCount: widget.candles!.length,
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
                      "${widget.gameResultModel.gameTypeModel.marketType.symbolInBinanace}")
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("시간 간격"),
                  Text("${widget.gameResultModel.gameTypeModel.intervalType.name}")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("차트 시간대"),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(
                        "${_dateFormat(DateTime.fromMillisecondsSinceEpoch(widget.gameResultModel.gameTypeModel.startTime))}",
                        style: TextStyle(
                          fontSize: 10,
                        )),
                    Text(
                        "${_dateFormat(DateTime.fromMillisecondsSinceEpoch(widget.gameResultModel.gameTypeModel.startTime + widget.gameResultModel.gameTypeModel.limit * widget.gameResultModel.gameTypeModel.intervalType.toMilliseconds()))}",
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
                        text: "${numberFormat.format(widget.gameAccount.balance)}"),
                    widget.gameAccount.balance - widget.initialAccount.balance >= 0
                        ? TextSpan(
                            text:
                                " ${numberFormat.format(widget.gameAccount.balance - widget.initialAccount.balance)}",
                            style: TextStyle(color: Colors.green))
                        : TextSpan(
                            text:
                                " ${numberFormat.format(widget.gameAccount.balance - widget.initialAccount.balance)}",
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
                        text: "${percentFormat.format(widget.gameAccount.winRate)}"),
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
                        text: "${widget.gameAccount.longs}",
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
                    TextSpan(text: "${widget.gameAccount.holds}"),
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
                        text: "${widget.gameAccount.shorts}",
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
