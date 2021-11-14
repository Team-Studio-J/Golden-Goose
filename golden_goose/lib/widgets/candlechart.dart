import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:golden_goose/screens/home.dart';
import 'package:golden_goose/utils/interactive_chart/candle_data.dart';
import 'package:golden_goose/utils/interactive_chart/chart_style.dart';
import 'package:golden_goose/utils/interactive_chart/interactive_chart.dart';

import 'grid.dart';

class CandleChart extends StatelessWidget {
  const CandleChart({
    Key? key,
    required List<CandleData> data,
    this.initialVisibleCandleCount,
  }) : _data = data, super(key: key);

  final int? initialVisibleCandleCount;
  final List<CandleData> _data;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
      child: Grid(
        decoration: BoxDecoration(),
        child: InteractiveChart(
          /** Only [candles] is required */
          candles: _data,
          /** Uncomment the following for examples on optional parameters */
          initialVisibleCandleCount: initialVisibleCandleCount ?? 30,
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
          //overlayInfo: (candle) => {},
          /** Callbacks */
          // onTap: (candle) => print("user tapped on $candle"),
          // onCandleResize: (width) => print("each candle is $width wide2"),
        ),
      ),
    );
  }
}
