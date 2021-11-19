import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:golden_goose/data/account_type.dart';
import 'package:golden_goose/data/interval_type.dart';
import 'package:golden_goose/data/market_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_type_model.g.dart';

@JsonSerializable()
class GameTypeModel {
  static final _random = Random();

  MarketType marketType;
  IntervalType intervalType;
  int startTime;
  int? endTime;
  int limit;
  AccountType accountType;

  GameTypeModel({
    required this.marketType,
    required this.intervalType,
    required this.startTime,
    this.endTime,
    required this.limit,
    required this.accountType,
  });

  factory GameTypeModel.fromDocumentSnapshot(
          {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) =>
      GameTypeModel.fromJson(documentSnapshot.data()!);

  factory GameTypeModel.fromJson(Map<String, dynamic> json) =>
      _$GameTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameTypeModelToJson(this);

  factory GameTypeModel.buildRandomGameTypeExceptThat(
      {MarketType? marketType,
      IntervalType? intervalType,
      int? startTime,
      int? limit,
      int? endTime,
      required AccountType accountType}) {
    MarketType selectedMarket =
        marketType ?? (MarketType.values..shuffle(_random)).first;
    IntervalType selectedInterval = intervalType ??
        IntervalType.values[_random.nextInt(IntervalType.values.length)];
    int selectedLimit = limit ?? 120;
    int nowInMilliseconds = DateTime.now().millisecondsSinceEpoch;
    int millisecondsPerInterval = selectedInterval.toMilliseconds();

    int selectedStartTime = startTime ??
        selectedMarket.firstTime +
            (_random.nextDouble() *
                    (nowInMilliseconds -
                        selectedMarket.firstTime -
                        millisecondsPerInterval * selectedLimit))
                .round();

    return GameTypeModel(
      marketType: selectedMarket,
      intervalType: selectedInterval,
      startTime: selectedStartTime,
      endTime: endTime,
      limit: selectedLimit,
      accountType: accountType,
    );
  }
}
