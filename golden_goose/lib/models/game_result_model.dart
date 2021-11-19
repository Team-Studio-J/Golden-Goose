import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:golden_goose/models/game_result_single_record.dart';
import 'package:golden_goose/utils/formatter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'game_result_model.g.dart';

//flutter pub run build_runner build
@JsonSerializable()
class GameResultModel {
  int balanceAtStart;
  int balanceAtEnd;

  int longWhenRise;
  int holdWhenRise;
  int shortWhenRise;
  int longWhenFall;
  int holdWhenFall;
  int shortWhenFall;

  List<GameResultSingleRecord> records;


  int get longs => longWhenRise + longWhenFall;

  int get holds => holdWhenRise + holdWhenFall;

  int get shorts => shortWhenRise + shortWhenFall;

  int get correctCount => longWhenRise + shortWhenFall;

  int get incorrectCount => longWhenFall + shortWhenRise;

  int get trialCount => correctCount + incorrectCount;

  int get totalCount => longs + holds + shorts;

  double get winRate => correctCount / trialCount;

  double get holdRate => holds / totalCount;

  double get bettingRate => (longs + shorts) / totalCount;

  String get formattedWinRate => Formatter.formatPercent(rate: winRate);
  String get formattedHoldRate => Formatter.formatPercent(rate: holdRate);
  String get formattedBettingRate => Formatter.formatPercent(rate: bettingRate);

  GameResultModel({
    this.balanceAtStart = 0,
    this.balanceAtEnd = 0,
    this.longWhenRise = 0,
    this.holdWhenRise = 0,
    this.shortWhenRise = 0,
    this.longWhenFall = 0,
    this.holdWhenFall = 0,
    this.shortWhenFall = 0,
    this.records = const [],
  });

  factory GameResultModel.fromDocumentSnapshot(
          {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot}) =>
      GameResultModel.fromJson(documentSnapshot.data()!);

  factory GameResultModel.fromJson(Map<String, dynamic> json) =>
      _$GameResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameResultModelToJson(this);

}
