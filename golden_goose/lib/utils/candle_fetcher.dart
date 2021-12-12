import 'dart:convert';

import 'package:golden_goose/data/binance_format.dart';
import 'package:golden_goose/data/interval_type.dart';
import 'package:golden_goose/data/market_type.dart';
import 'package:golden_goose/models/game_type_model.dart';
import 'package:golden_goose/utils/interactive_chart/candle_data.dart';
import 'package:http/http.dart' as http;

class CandleFetcher {
  static const String binanceAPIUrl = "https://api.binance.com";
  static const String binanceAPIKlinesEndpoint = "/api/v3/klines";

  static Future<List<CandleData>> fetchCandles(
      {required GameTypeModel gameTypeModel}) async {
    String url = "$binanceAPIUrl$binanceAPIKlinesEndpoint";
    url += "?";
    url +=
        "symbol=${gameTypeModel.marketType.symbolInBinanace}&interval=${gameTypeModel.intervalType.name}";
    url += "&startTime=${gameTypeModel.startTime}";
    if (gameTypeModel.endTime != null) {
      url += "&endTime=${gameTypeModel.endTime}";
    }
    url += "&limit=${gameTypeModel.limit}";
    final res = await http.get(Uri.parse(url));
    return (jsonDecode(res.body) as List<dynamic>)
        .map((e) => CandleDataExtension.getCandleDataFromJson(e))
        .toList();
  }
}
