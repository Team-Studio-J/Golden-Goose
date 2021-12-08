import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/data/interval_type.dart';
import 'package:golden_goose/data/market_type.dart';
import 'package:golden_goose/models/game_result_model.dart';
import 'package:golden_goose/utils/candle_fetcher.dart';
import 'package:golden_goose/utils/formatter.dart';
import 'package:golden_goose/utils/interactive_chart/candle_data.dart';
import 'package:golden_goose/widgets/candlechart.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:intl/intl.dart';

class Result extends StatefulWidget {
  static const String path = "/Result";

  final GameResultModel gameResultModel;
  final List<CandleData>? candles;

  const Result({Key? key, required this.gameResultModel, this.candles})
      : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final uc = Get.find<UserController>();

  final percentFormat = NumberFormat.decimalPercentPattern(decimalDigits: 2);

  final numberFormat = NumberFormat.currency(name: '', decimalDigits: 0);

  List<CandleData> candles = [];

  bool loaded = false;

  @override
  void initState() {
    if (widget.candles == null) {
      CandleFetcher.fetchCandles(
        gameTypeModel: widget.gameResultModel.gameTypeModel,
      ).then((value) => setState(() {
            candles = value;
            loaded = true;
          }));
    } else {
      setState(() {
        candles = widget.candles!;
        loaded = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ListView(physics: const BouncingScrollPhysics(), children: [
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Text("매매 결과",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
      SizedBox(
          height: 400,
          child: !loaded
              ? const Center(
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator()))
              : CandleChart(
                  data: candles,
                  initialVisibleCandleCount: candles.length,
                  overlayInfo: (index) {
                    var candleNow = candles[index];
                    final date = DateFormat("yyyy.MM.dd HH:mm").format(
                        DateTime.fromMillisecondsSinceEpoch(
                            candleNow.timestamp));
                    if (index == 0) {
                      return {
                        "": date,
                        "Open": candleNow.open?.asAbbreviated() ?? "-",
                        "High": candleNow.high?.asAbbreviated() ?? "-",
                        "Low": candleNow.low?.asAbbreviated() ?? "-",
                        "Close": candleNow.close?.asAbbreviated() ?? "-",
                        "Volume":
                            candleNow.volume?.asVolumeAbbreviated() ?? "-",
                      };
                    }

                    String getRatio(double? before, double? after) {
                      if (before == null || after == null || after.isNaN)
                        return "-";
                      return percentFormat.format((after - before) / after);
                    }

                    String getVolumeRatio(double? before, double? after) {
                      if (before == null || after == null || before.isNaN)
                        return "-";
                      return percentFormat.format((after) / before);
                    }

                    var candle1Before = candles[index - 1];
                    return {
                      "": date,
                      "Open":
                          "${candleNow.open!.asAbbreviated()} (${getRatio(candle1Before.open, candleNow.open)})",
                      "High":
                          "${candleNow.high!.asAbbreviated()} (${getRatio(candle1Before.high, candleNow.high)})",
                      "Low":
                          "${candleNow.low!.asAbbreviated()} (${getRatio(candle1Before.low, candleNow.low)})",
                      "Close":
                          "${candleNow.close!.asAbbreviated()} (${getRatio(candle1Before.close, candleNow.close)})",
                      "Volume":
                          "${candleNow.volume!.asVolumeAbbreviated()} (${getVolumeRatio(candle1Before.volume, candleNow.volume)})",
                    };
                  },
                )),
      Padding(
        padding: const EdgeInsets.all(17.0),
        child: Grid(
          color: Colors.transparent,
          child: Column(
            children: [
              Grid(
                color: Colors.indigo,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("매매 코인", style: TextStyle(fontSize: 13)),
                        Text(
                          widget.gameResultModel.gameTypeModel.marketType
                              .symbolInBinanace,
                          textAlign: TextAlign.right,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("시간 간격", style: TextStyle(fontSize: 13)),
                        Text(widget
                            .gameResultModel.gameTypeModel.intervalType.name)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("차트 시간대", style: TextStyle(fontSize: 13)),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  _dateFormat(
                                      DateTime.fromMillisecondsSinceEpoch(widget
                                          .gameResultModel
                                          .gameTypeModel
                                          .startTime)),
                                  style: const TextStyle(
                                    fontSize: 10,
                                  )),
                              Text(
                                  _dateFormat(
                                      DateTime.fromMillisecondsSinceEpoch(widget
                                              .gameResultModel
                                              .gameTypeModel
                                              .startTime +
                                          widget.gameResultModel.gameTypeModel
                                                  .limit *
                                              widget.gameResultModel
                                                  .gameTypeModel.intervalType
                                                  .toMilliseconds())),
                                  style: const TextStyle(
                                    fontSize: 10,
                                  )),
                            ])
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Grid(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("매매 후 잔고", style: TextStyle(fontSize: 13)),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: numberFormat.format(
                                  widget.gameResultModel.gameAccount.balance)),
                          TextSpan(
                              text:
                                  " ${widget.gameResultModel.formattedRevenue}",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Formatter.getColorByValue(
                                      widget.gameResultModel.revenueRate))),
                        ])),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("승률", style: TextStyle(fontSize: 13)),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: widget.gameResultModel.gameAccount
                                  .formattedWinRate),
                        ])),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("롱 횟수", style: TextStyle(fontSize: 13)),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "${widget.gameResultModel.gameAccount.longs}",
                              style: const TextStyle(color: Colors.blue)),
                          const TextSpan(
                              text: " ", style: TextStyle(color: Colors.white)),
                          TextSpan(
                              text: widget.gameResultModel.gameAccount
                                  .formattedLongOnTrialRatio,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 10)),
                        ])),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("홀드 횟수", style: TextStyle(fontSize: 13)),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "${widget.gameResultModel.gameAccount.holds}"),
                          const TextSpan(
                              text: " ", style: TextStyle(color: Colors.white)),
                          TextSpan(
                              text: widget.gameResultModel.gameAccount
                                  .formattedHoldOnTotalRatio,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 10)),
                        ])),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("숏 횟수", style: TextStyle(fontSize: 13)),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "${widget.gameResultModel.gameAccount.shorts}",
                              style: const TextStyle(color: Colors.red)),
                          const TextSpan(
                              text: " ", style: TextStyle(color: Colors.white)),
                          TextSpan(
                              text: widget.gameResultModel.gameAccount
                                  .formattedShortOnTrialRatio,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 10)),
                        ])),
                      ],
                    ),
                    getSeparator(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("진행중 평균 가격 변동률",
                            style: TextStyle(fontSize: 13)),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: widget.gameResultModel
                                  .formattedAverageAbsFluctuateRate,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ])),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("베팅 평균 기대 수익",
                            style: TextStyle(fontSize: 13)),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: widget.gameResultModel
                                  .formattedExpectedIncomeOnBetting,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Formatter.getColorByValue(
                                      widget.gameResultModel.revenueRate))),
                        ])),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("롱 평균 기대 수익",
                            style: TextStyle(fontSize: 13)),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: widget.gameResultModel
                                  .formattedExpectedIncomeOnLong,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Formatter.getColorByValue(widget
                                      .gameResultModel.revenueOnLong
                                      .toDouble()))),
                        ])),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("숏 평균 기대 수익",
                            style: TextStyle(fontSize: 13)),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: widget.gameResultModel
                                  .formattedExpectedIncomeOnShort,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Formatter.getColorByValue(widget
                                      .gameResultModel.revenueOnShort
                                      .toDouble()))),
                        ])),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("홀드시 평균 가격 변동률",
                            style: TextStyle(fontSize: 13)),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: widget.gameResultModel
                                  .formattedAverageAbsFluctuateRateOnHolds,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ])),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ])));
  }

  String _dateFormat(DateTime date) {
    return "${date.year}.${date.month}.${date.day} ${date.hour}:${date.minute}";
  }

  Widget getSeparator() {
    return Column(children: [
      const SizedBox(height: 6),
      Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
              flex: 20,
              child:
                  Container(height: 1, color: Colors.white.withOpacity(0.2))),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
      const SizedBox(height: 6),
    ]);
  }
}

extension Formatting on double {
  String asPercent() {
    final format = this < 100 ? "##0.00" : "#,###";
    final v = NumberFormat(format, "en_US").format(this);
    return "${this >= 0 ? '+' : ''}$v%";
  }

  String asAbbreviated() {
    if (this >= 1e18) return toStringAsExponential(3);
    if (this >= 0.001 && this < 1)
      return "${(this * 1000).toStringAsFixed(3)}m";
    if (this < 0.001) return "${(this * 1000000).toStringAsFixed(3)}µ";
    if (this >= 1 && this < 1000) return toStringAsFixed(2);
    return NumberFormat("#,###,###,###,###", "en_US").format(this);
  }

  String asVolumeAbbreviated() {
    if (this >= 1 && this < 1000) return toStringAsFixed(3);
    if (this >= 1e18) return toStringAsExponential(3);
    if (this >= 0.001 && this < 1)
      return "${(this * 1000).toStringAsFixed(3)}m";
    if (this < 0.001) return "${(this * 1000000).toStringAsFixed(3)}µ";
    final s = NumberFormat("#,###", "en_US").format(this).split(",");
    const suffixes = ["K", "M", "B", "T", "Q"];
    return "${s[0]}.${s[1]}${suffixes[s.length - 2]}";
  }
}
