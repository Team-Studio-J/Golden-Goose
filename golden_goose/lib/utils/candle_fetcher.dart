import 'dart:convert';
import 'package:golden_goose/data/binanace_format.dart';
import 'package:golden_goose/utils/interactive_chart/candle_data.dart';
import 'package:http/http.dart' as http;


class CandleFetcher {
  static const String BINANCE_API_URL = "https://api.binance.com";
  static const String BINANCE_API_KLINES_ENDPOINT = "/api/v3/klines";
  static Future<List<CandleData>> fetchCandles(
      {required String symbol,
      required String interval,
      int? startTime,
      int? endTime,
      int? limit}) async {
    String url = "$BINANCE_API_URL$BINANCE_API_KLINES_ENDPOINT";
    url += "?";
    url += "symbol=$symbol&interval=$interval";
    if (startTime != null) url += "&startTime=$startTime";
    if (endTime != null) url += "&endTime=$endTime";
    if (limit != null) url += "&limit=$limit";
    final res = await http.get(Uri.parse(url));
    return (jsonDecode(res.body) as List<dynamic>)
        .map((e) => CandleDataExtension.getCandleDataFromJson(e))
        .toList();
  }
}
