import 'package:golden_goose/utils/interactive_chart/candle_data.dart';

enum BinanceKlineDataFormat {
  openTime,
  open,
  high,
  low,
  close,
  volume,
  closeTime,
  quoteAssetVolume,
  numberOfTrades,
  takerBuyBaseAsset,
  takerBuyQuoteAsset,
  ignore,
}

extension CandleDataExtension on CandleData {
  static CandleData getCandleDataFromJson(List<dynamic> json) {
    return CandleData(
      timestamp: DateTime
          .fromMillisecondsSinceEpoch(
          json[BinanceKlineDataFormat.openTime.index]).millisecondsSinceEpoch,
      open: double.parse(json[BinanceKlineDataFormat.open.index]),
      high: double.parse(json[BinanceKlineDataFormat.high.index]),
      low: double.parse(json[BinanceKlineDataFormat.low.index]),
      close: double.parse(json[BinanceKlineDataFormat.close.index]),
      volume: double.parse(json[BinanceKlineDataFormat.volume.index]),
    );
  }
}